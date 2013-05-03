Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab3ECONv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:13:51 -0400
Received: from fallback7.mail.ru ([94.100.176.135]:35282 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab3ECONu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:13:50 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 May 2013 10:13:50 EDT
Message-ID: <5183D196.2080305@list.ru>
Date: Fri, 03 May 2013 19:02:46 +0400
From: Stas Sergeev <stsp@list.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jarkko Huijts <jarkko.huijts@gmail.com>
CC: Alan Cox <alan@linux.intel.com>,
        Linux kernel <linux-kernel@vger.kernel.org>,
        Caylan Van Larson <i@caylan.net>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Regression: ftdi_sio is slow (since Wed Oct 10 15:05:06 2012)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

We have a regression because of this patch:
http://lkml.indiana.edu/hypermail/linux/kernel/1210.1/01456.html
While it is arguably reasonable to have this for tcdrain or close,
it also slows down poll/select a lot because n_tty_poll() does this:

tty_chars_in_buffer(tty) < WAKEUP_CHARS

And it also slows down TIOCOUTQ ioctl I think (not measured).
The slowdown of select() is big, the customer reports the inability
to work that way.

Is this patch really needed? I mean, if the time to check TEMT is
longer than to xmit that char, then what's the use?
Or, if it is really a big deal, I guess it would be necessary to add
a separate, .chars_in_buffer_fast method.

Thoughts?
