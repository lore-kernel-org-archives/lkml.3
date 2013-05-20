Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3ETKHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:07:14 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:38751 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3ETKHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:07:12 -0400
Date: Mon, 20 May 2013 12:07:03 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Caylan Larson <i@caylan.net>
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Hurley <peter@hurleysoftware.com>, Stas Sergeev <stsp@list.ru>,
        Jarkko Huijts <jarkko.huijts@gmail.com>,
        Alan Cox <alan@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 0/7] USB: serial: add wait_until_sent-support
Message-ID: <20130520100703.GB21474@localhost>
References: <20130505182913.GE16818@localhost>
 <1367778753-22297-1-git-send-email-jhovold@gmail.com>
 <81D166EE-BB85-4A72-A6FA-A1F6B5633CB0@caylan.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81D166EE-BB85-4A72-A6FA-A1F6B5633CB0@caylan.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 10:46:37AM -0500, Caylan Larson wrote:
> Johan,
> 
> I have tested these patches and the performance is much better.  Thank you.

Thanks for testing. The patches are already in the usb tree (usb-linus
branch) and should show up in v3.10-rc soon.

Johan

> Tested-by: Caylan Larson <i@caylan.net>
> 
> Caylan
> 
> 
> On May 5, 2013, at 1:32 PM, Johan Hovold <jhovold@gmail.com> wrote:
> 
> > These patches add wait_until_sent-support to usb-serial, which removes
> > the need to check hardware buffers in chars_in_buffer.
> > 
> > This fixes a problem in ftdi_sio (since 3.7) where select or TIOCMOUTQ
> > would take much longer than before due the hardware buffers being
> > queried.
> > 
> > Hardware buffers are also currently checked in chars_in_buffer in io_ti
> > (since 3.8) and ti_usb_3410_5052 (in 3.10).
> > 
> > Note that simply removing the hardware-buffer checks (e.g. for the
> > stable trees) would break tty_wait_until_sent, which is used, for
> > instance, by tcdrain, tcsendbreak, and close.
