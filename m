Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbaEDCcz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 22:32:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbaEDCcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 22:32:54 -0400
Date: Sat, 3 May 2014 22:32:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Rohit Seth <rohitseth@google.com>
Subject: Re: [PATCH] sysctl: Fix division by zero in percpu_pagelist_fraction
 handler
Message-ID: <20140504023248.GA30871@kroah.com>
References: <1399166883-514-1-git-send-email-green@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399166883-514-1-git-send-email-green@linuxhacker.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2014 at 09:28:03PM -0400, Oleg Drokin wrote:
> percpu_pagelist_fraction_sysctl_handler calls proc_dointvec_minmax
> and blindly assumes that return value of 0 means success.
> In fact the other valid case is when it got a zero length input.
> 
> After that it proceeds to a division by percpu_pagelist_fraction
> value which is conveniently set to a default of zero, resulting in
> division by zero.
> 
> Other than checking the bytecount to be more than zero, perhaps
> a better default value for percpu_pagelist_fraction would help too.
> 
> [  661.985469] divide error: 0000 [#1] SMP DEBUG_PAGEALLOC
> [  661.985868] Modules linked in: binfmt_misc cfg80211 rfkill rpcsec_gss_krb5 ttm drm_kms_helper drm i2c_piix4 microcode i2c_core joydev serio_raw pcspkr virtio_blk nfsd
> [  661.986008] CPU: 1 PID: 9142 Comm: badarea_io Not tainted 3.15.0-rc2-vm-nfs+ #19
> [  661.986008] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [  661.986008] task: ffff8800d5aeb6e0 ti: ffff8800d87a2000 task.ti: ffff8800d87a2000
> [  661.986008] RIP: 0010:[<ffffffff81152664>]  [<ffffffff81152664>] percpu_pagelist_fraction_sysctl_handler+0x84/0x120
> [  661.988031] RSP: 0018:ffff8800d87a3e78  EFLAGS: 00010246
> [  661.988031] RAX: 0000000000000f89 RBX: ffff88011f7fd000 RCX: 0000000000000000
> [  661.988031] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000010
> [  661.988031] RBP: ffff8800d87a3e98 R08: ffffffff81d002c8 R09: ffff8800d87a3f50
> [  661.988031] R10: 000000000000000b R11: 0000000000000246 R12: 0000000000000060
> [  661.988031] R13: ffffffff81c3c3e0 R14: ffffffff81cfddf8 R15: ffff8801193b0800
> [  661.988031] FS:  00007f614f1e9740(0000) GS:ffff88011f440000(0000) knlGS:0000000000000000
> [  661.988031] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  661.988031] CR2: 00007f614f1fa000 CR3: 00000000d9291000 CR4: 00000000000006e0
> [  661.988031] Stack:
> [  661.988031]  0000000000000001 ffffffffffffffea ffffffff81c3c3e0 0000000000000000
> [  661.988031]  ffff8800d87a3ee8 ffffffff8122b163 ffff8800d87a3f50 00007fff1564969c
> [  661.988031]  0000000000000000 ffff8800d8098f00 00007fff1564969c ffff8800d87a3f50
> [  661.988031] Call Trace:
> [  661.988031]  [<ffffffff8122b163>] proc_sys_call_handler+0xb3/0xc0
> [  661.988031]  [<ffffffff8122b184>] proc_sys_write+0x14/0x20
> [  661.988031]  [<ffffffff811ba93a>] vfs_write+0xba/0x1e0
> [  661.988031]  [<ffffffff811bb486>] SyS_write+0x46/0xb0
> [  661.988031]  [<ffffffff816db7ff>] tracesys+0xe1/0xe6
> [  661.988031] Code: 1f 84 00 00 00 00 00 48 83 bb b0 06 00 00 00 0f 84 7c 00 00 00 48 63 0d 93 6a e1 00 48 8b 83 b8 06 00 00 31 d2 41 bc 60 00 00 00 <48> f7 f1 ba 01 00 00 00 49 89 c5 48 c1 e8 02 48 85 c0 48 0f 44
> 
> Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
> CC: Rohit Seth <rohitseth@google.com>

Why are you sending this to me?  Please use scripts/get_maintainer.pl to
find the people, and mailing lists, that this patch should be sent to.

thanks,

greg k-h
