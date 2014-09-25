Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaIYKR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:17:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58056 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaIYKRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:17:25 -0400
Date: Thu, 25 Sep 2014 12:16:28 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH resend 1/2] tty: omap-serial: fix division by zero
Message-ID: <20140925101628.GB16810@kroah.com>
References: <20140924080852.GA28215@kroah.com>
 <1411636791-24116-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411636791-24116-1-git-send-email-frans.klaver@xsens.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 11:19:51AM +0200, Frans Klaver wrote:
> If the chosen baud rate is large enough (e.g. 3.5 megabaud), the
> calculated n values in serial_omap_is_baud_mode16() may become 0. This
> causes a division by zero when calculating the difference between
> calculated and desired baud rates. To prevent this, cap the n13 and n16
> values on 1.
> 
> Division by zero in kernel.
> [<c00132e0>] (unwind_backtrace) from [<c00112ec>] (show_stack+0x10/0x14)
> [<c00112ec>] (show_stack) from [<c01ed7bc>] (Ldiv0+0x8/0x10)
> [<c01ed7bc>] (Ldiv0) from [<c023805c>] (serial_omap_baud_is_mode16+0x4c/0x68)
> [<c023805c>] (serial_omap_baud_is_mode16) from [<c02396b4>] (serial_omap_set_termios+0x90/0x8d8)
> [<c02396b4>] (serial_omap_set_termios) from [<c0230a0c>] (uart_change_speed+0xa4/0xa8)
> [<c0230a0c>] (uart_change_speed) from [<c0231798>] (uart_set_termios+0xa0/0x1fc)
> [<c0231798>] (uart_set_termios) from [<c022bb44>] (tty_set_termios+0x248/0x2c0)
> [<c022bb44>] (tty_set_termios) from [<c022c17c>] (set_termios+0x248/0x29c)
> [<c022c17c>] (set_termios) from [<c022c3e4>] (tty_mode_ioctl+0x1c8/0x4e8)
> [<c022c3e4>] (tty_mode_ioctl) from [<c0227e70>] (tty_ioctl+0xa94/0xb18)
> [<c0227e70>] (tty_ioctl) from [<c00cf45c>] (do_vfs_ioctl+0x4a0/0x560)
> [<c00cf45c>] (do_vfs_ioctl) from [<c00cf568>] (SyS_ioctl+0x4c/0x74)
> [<c00cf568>] (SyS_ioctl) from [<c000e480>] (ret_fast_syscall+0x0/0x30)
> 
> Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
> ---
> Resend to add stable@vger.kernel.org to CC. As far as I know, this applies to
> v3.9 and up.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>

I'll take care of this, but go read that file for your next time...

greg k-h
