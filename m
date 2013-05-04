Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791Ab3EDLqF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 07:46:05 -0400
Received: from smtp46.i.mail.ru ([94.100.177.106]:54265 "EHLO smtp46.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab3EDLqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 07:46:01 -0400
Message-ID: <51850295.6020601@list.ru>
Date: Sat, 04 May 2013 16:44:05 +0400
From: Stas Sergeev <stsp@list.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Jarkko Huijts <jarkko.huijts@gmail.com>,
        Alan Cox <alan@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Linux kernel <linux-kernel@vger.kernel.org>,
        Caylan Van Larson <i@caylan.net>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression: ftdi_sio is slow (since Wed Oct 10 15:05:06 2012)
References: <5183D196.2080305@list.ru> <20130503163008.GA30699@kroah.com> <5183F62A.1020801@list.ru> <20130503165231.GA1966@kroah.com> <5183FC83.8090602@list.ru> <20130503171618.GA16686@kroah.com> <51840186.7000608@list.ru> <20130503203419.GA25932@kroah.com> <51843132.9040304@list.ru> <20130504111535.GC16818@localhost>
In-Reply-To: <20130504111535.GC16818@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

04.05.2013 15:15, Johan Hovold пишет:
> The query takes longer than the transmit at decent baudrates (>=38k)
> and under the assumption that flow control isn't causing any delays.
>
> But you do have a point, and I have been meaning to look into whether
> the added overhead of checking the hardware buffers could be mitigated
> by adding wait_until_sent support to usb-serial. This way the we would
> only query the hardware buffers on tty_wait_until_sent (e.g. at close)
> and select and TIOCMOUTQ would not suffer. This is also the way things
> are handled in serial_core.
Thanks for taking a look.
Indeed, it seems .wait_until_sent is the best candidate for that
kind of things, and the patch in question would even match its
description be it using .wait_until_sent and not .chars_in_buffer.
Please count on testing your patches here when they are ready.
