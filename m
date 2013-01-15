Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab3AOF0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 00:26:09 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:41925 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3AOF0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 00:26:07 -0500
MIME-Version: 1.0
In-Reply-To: <20130115051005.GA14198@localhost>
References: <20130115051005.GA14198@localhost>
Date: Tue, 15 Jan 2013 00:26:05 -0500
Message-ID: <CAHdPZaNjw5S597L9p35JeZihiD4bOCV91ZSYrzDP2g3r_wXfAw@mail.gmail.com>
Subject: Re: [dgrp_register_proc] BUG: unable to handle kernel NULL pointer
 dereference at 0000000000000040
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 12:10 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> 7b6d45c211a401a9bdeebfa96f8a4c811bd3eeaf is the first bad commit
>
> commit 7b6d45c211a401a9bdeebfa96f8a4c811bd3eeaf
> Author: Bill Pemberton <wfp5p@virginia.edu>
> Date:   Thu Sep 20 16:55:28 2012 -0400
>
>     staging: dgrp: add dgrp to the build
>
>     Kconfig and Makefile changes to add dgrp to the build system.
>
>     Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> [    7.904899] i2c-core: driver [isl29018] registered
> [    7.906424] i2c-core: driver [tsl2583] registered
> [    7.908289] BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
> [    7.909055] IP: [<ffffffff814f5147>] register_proc_table+0xe0/0x26f
> [    7.909055] PGD 0
> [    7.909055] Oops: 0000 [#1] SMP
> [    7.909055] CPU 0
> [    7.909055] Pid: 1, comm: swapper/0 Not tainted 3.8.0-rc3-00051-gc83dcb9 #16
> [    7.909055] RIP: 0010:[<ffffffff814f5147>]  [<ffffffff814f5147>] register_proc_table+0xe0/0x26f
> [    7.909055] RSP: 0000:ffff88000d0c1e78  EFLAGS: 00010246
> [    7.909055] RAX: 0000000000000003 RBX: 0000000000000000 RCX: 0000000000000003
> [    7.909055] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffffffff81989648
> [    7.909055] RBP: ffff88000d0c1eb8 R08: 0000000000000000 R09: 0000000000000000
> [    7.909055] R10: ffff88000f4fed68 R11: ffff88000f4fecb8 R12: ffffffff81a9f008
> [    7.909055] R13: 0000000000000000 R14: ffffffff82b3a710 R15: ffffffff81989644
> [    7.909055] FS:  0000000000000000(0000) GS:ffff88000da00000(0000) knlGS:0000000000000000
> [    7.909055] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    7.909055] CR2: 0000000000000040 CR3: 00000000019a4000 CR4: 00000000000006f0
> [    7.909055] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    7.927424] tsc: Refined TSC clocksource calibration: 2666.662 MHz
>
> Thanks,
> Fengguang


Hello Fengguang,

Will you try the patch below please...

diff --git a/drivers/staging/dgrp/dgrp_specproc.c
b/drivers/staging/dgrp/dgrp_specproc.c
index c214078..f5845a7 100644
--- a/drivers/staging/dgrp/dgrp_specproc.c
+++ b/drivers/staging/dgrp/dgrp_specproc.c
@@ -231,6 +231,8 @@ static void register_proc_table(struct
dgrp_proc_entry *table,

        if (table == NULL)
                return;
+       if (root == NULL)
+               return;

        for (; table->id; table++) {
                /* Can't do anything without a proc name. */

Applies on current linus's head at 406089d01562f1e2bf9f089fd7637009ebaad589.

I am thinking of the case where you dont have any proc entry.

thanks,
