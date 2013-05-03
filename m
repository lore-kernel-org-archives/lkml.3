Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933545Ab3ECQcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 12:32:33 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:44794 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760550Ab3ECQca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 12:32:30 -0400
Date: Fri, 3 May 2013 09:30:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Stas Sergeev <stsp@list.ru>
Cc: Jarkko Huijts <jarkko.huijts@gmail.com>, Alan Cox <alan@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
        Linux kernel <linux-kernel@vger.kernel.org>,
        Caylan Van Larson <i@caylan.net>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression: ftdi_sio is slow (since Wed Oct 10 15:05:06 2012)
Message-ID: <20130503163008.GA30699@kroah.com>
References: <5183D196.2080305@list.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5183D196.2080305@list.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 07:02:46PM +0400, Stas Sergeev wrote:
> Hi.
> 
> We have a regression because of this patch:
> http://lkml.indiana.edu/hypermail/linux/kernel/1210.1/01456.html
> While it is arguably reasonable to have this for tcdrain or close,
> it also slows down poll/select a lot because n_tty_poll() does this:
> 
> tty_chars_in_buffer(tty) < WAKEUP_CHARS

What do you mean "slows down"?

> And it also slows down TIOCOUTQ ioctl I think (not measured).
> The slowdown of select() is big, the customer reports the inability
> to work that way.

Inability to work what way?

> Is this patch really needed? I mean, if the time to check TEMT is
> longer than to xmit that char, then what's the use?
> Or, if it is really a big deal, I guess it would be necessary to add
> a separate, .chars_in_buffer_fast method.

We need some way to check the chars in the buffer, is the device you are
using just very slow to respond to this request?  How slow?  Do you have
a test case that we can see how it is affected?

thanks,

greg k-h
