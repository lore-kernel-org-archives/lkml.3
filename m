Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935411Ab3DOIkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 04:40:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42008 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935175Ab3DOIkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 04:40:14 -0400
From: Paolo Pisati <paolo.pisati@canonical.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Paolo Pisati <paolo.pisati@canonical.com>
Subject: [PATCH] dma: of-dma: check OF pointer property before dereferencing
Date: Mon, 15 Apr 2013 10:39:52 +0200
Message-Id: <1366015193-6627-1-git-send-email-paolo.pisati@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 5 [#1] SMP ARM
CPU: 0    Tainted: G        W     (3.9.0-rc739rc7fix1-dirty #10)
PC is at of_dma_controller_register+0xb8/0x11c
LR is at of_find_property+0x44/0x4c
pc : [<c01adf8c>]    lr : [<c0281754>]    psr: 60000113
sp : ef043e40  ip : 00000000  fp : c01af774
r10: ef015550  r9 : c01af5c0  r8 : 00000000
r7 : c01afb40  r6 : ef120400  r5 : c48613dc  r4 : ef02e900
r3 : 00000000  r2 : 00000023  r1 : a0000113  r0 : 00000000
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c5387d  Table: 0000404a  DAC: 00000015
Process swapper/0 (pid: 1, stack limit = 0xef042238)
Stack: (0xef043e40 to 0xef044000)
3e40: ef015550 ef01558c ef120400 c01affe4 00000000 c01af5c0 ef015584 c01b1170
3e60: 00000000 ef015550 c033ca54 c48613dc c033ca54 0000007c 00041308 ef103d80
3e80: a0000113 00000000 ef012440 c03bc7d4 ef120400 00000000 c03bc780 c03bc780
3ea0: c038c000 00000000 00000000 c01ac1f4 c01ac16c ef120400 c03fa67c c03fa684
3ec0: 00000000 c01d9570 ef120400 c03bc780 ef120434 00000000 0000008b c01d9718
3ee0: 00000000 c03bc780 c01d968c c01d7ce4 ef0c2558 ef0eefb4 ef02b100 c03bc780
3f00: c03bc64c c01d8450 c033cfa8 c03bc1e0 c03bc780 c0398e48 c03a0784 c03cab40
3f20: 0000008b c01d9ce8 00000000 00000006 c0398e48 c03a0784 c03cab40 0000008b
3f40: 00000000 c0377878 00000006 00000006 c03b25a4 00000006 00000006 c0398e48
3f60: c03a0784 c03cab40 0000008b c0398e54 c037727c c0377a44 00000006 00000006
3f80: c037727c 00000000 00000000 c02bb874 00000000 00000000 00000000 00000000
3fa0: 00000000 c02bb87c 00000000 c000dfd8 00000000 00000000 00000000 00000000
3fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
3fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[<c01adf8c>] (of_dma_controller_register+0xb8/0x11c) from [<c01b1170>] (pl330_probe+0x740/0xa9c)
[<c01b1170>] (pl330_probe+0x740/0xa9c) from [<c01ac1f4>] (amba_probe+0x88/0xa0)
[<c01ac1f4>] (amba_probe+0x88/0xa0) from [<c01d9570>] (driver_probe_device+0xf8/0x214)
[<c01d9570>] (driver_probe_device+0xf8/0x214) from [<c01d9718>] (__driver_attach+0x8c/0x90)
[<c01d9718>] (__driver_attach+0x8c/0x90) from [<c01d7ce4>] (bus_for_each_dev+0x54/0x88)
[<c01d7ce4>] (bus_for_each_dev+0x54/0x88) from [<c01d8450>] (bus_add_driver+0xdc/0x230)
[<c01d8450>] (bus_add_driver+0xdc/0x230) from [<c01d9ce8>] (driver_register+0x78/0x14c)
[<c01d9ce8>] (driver_register+0x78/0x14c) from [<c0377878>] (do_one_initcall+0x90/0x160)
[<c0377878>] (do_one_initcall+0x90/0x160) from [<c0377a44>] (kernel_init_freeable+0xfc/0x1c4)
[<c0377a44>] (kernel_init_freeable+0xfc/0x1c4) from [<c02bb87c>] (kernel_init+0x8/0xe4)
[<c02bb87c>] (kernel_init+0x8/0xe4) from [<c000dfd8>] (ret_from_fork+0x14/0x3c)
Code: e1a00008 e8bd87f0 e3a04010 eaffffe0 (e5909000)
---[ end trace 1b75b31a2719ed1e ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Paolo Pisati (1):
  dma: of-dma: check OF pointer property before dereferencing it

 drivers/dma/of-dma.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
1.7.10.4

