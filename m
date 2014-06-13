Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaFMOWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:22:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34043 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751017AbaFMOWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:22:12 -0400
Date: Fri, 13 Jun 2014 10:22:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mina86@mina86.com>
cc: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Yang Wei <Wei.Yang@windriver.com>
Subject: Re: [PATCHv4 6/6] usb: gadget: f_mass_storage: Fix a warning while
 loading g_mass_storage
In-Reply-To: <1402666689-4971-7-git-send-email-mina86@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1406131020410.1059-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Michal Nazarewicz wrote:

> While loading g_mass_storage module, the following warning can
> trigger:
> 
> WARNING: at drivers/usb/gadget/composite.c:
> usb_composite_setup_continue: Unexpected call
> Modules linked in: fat vfat minix nls_cp437 nls_iso8859_1 g_mass_storage
> [<800179cc>] (unwind_backtrace+0x0/0x104) from [<80619608>] (dump_stack+0x20/0x24)
> [<80619608>] (dump_stack+0x20/0x24) from [<80025100>] (warn_slowpath_common+0x64/0x74)
> [<80025100>] (warn_slowpath_common+0x64/0x74) from [<800251cc>] (warn_slowpath_fmt+0x40/0x48)
> [<800251cc>] (warn_slowpath_fmt+0x40/0x48) from [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage])
> [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage]) from [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage])
> [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage]) from [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage])
> [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage]) from [<8004bc90>] (kthread+0x98/0x9c)
> [<8004bc90>] (kthread+0x98/0x9c) from [<8000faec>] (kernel_thread_exit+0x0/0x8)
> 
> The root cause is that the existing code fails to take into account
> the possibility that common->new_fsg can change while
> do_set_interface() is running, because the spinlock does not protect
> it.
> 
> Change the code so that the common->new_fsg field is protected by the
> common->lock spin lock.

NAK.  common->new_fsg does not need to be protected.  Wei's patch is 
much simpler and will work well.

Alan Stern

