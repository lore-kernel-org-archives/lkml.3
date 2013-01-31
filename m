Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab3AaFPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 00:15:36 -0500
Received: from mail.kernel.org ([198.145.19.201]:50342 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab3AaFPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 00:15:33 -0500
Date: Thu, 31 Jan 2013 06:17:28 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Millenbach <jmillenbach@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alan Cox <alan@linux.intel.com>, Jiri Slaby <jirislaby@gmail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, Jamey Sharp <jamey@minilop.net>
Subject: Re: [PATCHv5] tty: Added a CONFIG_TTY option to allow removal of TTY
Message-ID: <20130131051728.GA2961@kroah.com>
References: <1359594919-2819-1-git-send-email-jmillenbach@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359594919-2819-1-git-send-email-jmillenbach@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 05:15:19PM -0800, Joe Millenbach wrote:
> The option allows you to remove TTY and compile without errors. This
> saves space on systems that won't support TTY interfaces anyway.
> bloat-o-meter output is below.
> 
> The bulk of this patch consists of Kconfig changes adding "depends on
> TTY" to various serial devices and similar drivers that require the TTY
> layer.  Ideally, these dependencies would occur on a common intermediate
> symbol, but many drivers select rather than depend on features, and
> "select" does not respect dependencies.
> 
> bloat-o-meter output filtered to not show removed entries to save space
> 
> $ scripts/bloat-o-meter min min-no-tty | awk '$3 != "-"'
> add/remove: 0/225 grow/shrink: 2/12 up/down: 8/-29628 (-29620)
> function                                     old     new   delta
> chr_dev_init                                 138     145      +7
> linux_banner                                 123     124      +1
> static.__warned                              132     131      -1
> unregister_console                           106     101      -5
> start_kernel                                 467     462      -5
> register_console                             545     540      -5
> copy_from_user                                40      35      -5
> sys_setsid                                   105      98      -7
> sys_vhangup                                   27      15     -12
> do_exit                                     1363    1346     -17
> arch_local_irq_save                          136     116     -20
> bitmap_zero                                   44      22     -22
> release_task                                 587     562     -25
> static.spin_unlock_irqrestore                223     187     -36
> 
> Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> Reviewed-by: Jamey Sharp <jamey@minilop.net>
> ---
> v5: Rebasing to 3.8 rc5 and minimized driver/input changes based on input
>     from Dmitry Torokhov.

This isn't going to work because I've already applied this to my tree.
Can you just make a tiny patch against the tty-next git tree to fix up
the differences here for the Input drivers and I can apply that?

thanks,

greg k-h
