Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3ASAWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 19:22:15 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:54214 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab3ASAWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 19:22:13 -0500
Date: Fri, 18 Jan 2013 16:22:09 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Millenbach <jmillenbach@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jirislaby@gmail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, Jamey Sharp <jamey@minilop.net>
Subject: Re: [PATCHv4] tty: Added a CONFIG_TTY option to allow removal of TTY
Message-ID: <20130119002209.GA30107@kroah.com>
References: <1358491462-16562-1-git-send-email-jmillenbach@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358491462-16562-1-git-send-email-jmillenbach@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 10:44:22PM -0800, Joe Millenbach wrote:
> The option allows you to remove TTY and compile without errors. This
> saves space on systems that won't support TTY interfaces anyway.
> bloat-o-meter output is below.
> 
> The bulk of this patch consists of Kconfig changes adding "depends on
> TTY" to various serial devices and similar drivers that require the TTY
> layer.  Ideally, these dependencies would occur on a common intermediate
> symbol such as SERIO, but most drivers "select SERIO" rather than
> "depends on SERIO", and "select" does not respect dependencies.
> 
> bloat-o-meter output comparing our previous minimal to new minimal by
> removing TTY.  The list is filtered to not show removed entries with awk
> '$3 != "-"' as the list was very long.
> 
> add/remove: 0/226 grow/shrink: 2/14 up/down: 6/-35356 (-35350)
> function                                     old     new   delta
> chr_dev_init                                 166     170      +4
> allow_signal                                  80      82      +2
> static.__warned                              143     142      -1
> disallow_signal                               63      62      -1
> __set_special_pids                            95      94      -1
> unregister_console                           126     121      -5
> start_kernel                                 546     541      -5
> register_console                             593     588      -5
> copy_from_user                                45      40      -5
> sys_setsid                                   128     120      -8
> sys_vhangup                                   32      19     -13
> do_exit                                     1543    1526     -17
> bitmap_zero                                   60      40     -20
> arch_local_irq_save                          137     117     -20
> release_task                                 674     652     -22
> static.spin_unlock_irqrestore                308     260     -48
> 
> Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
> Reviewed-by: Jamey Sharp <jamey@minilop.net>

Very nice, I've applied this to my tree now, thanks for doing this.

greg k-h
