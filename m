Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab3K3JyW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 04:54:22 -0500
Received: from smtp43.i.mail.ru ([94.100.177.103]:49421 "EHLO smtp43.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab3K3JyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 04:54:20 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH RESEND] mfd: mc13xxx: Fix null pointer dereference in mc13xxx_common_init
Date: Sat, 30 Nov 2013 13:53:08 +0400
Message-Id: <1385805188-5597-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If this driver being loaded from devicetree, the pdata is NULL.
This cause kernel Oops when "fsl,mc13xxx-uses-codec" and/or
"fsl,mc13xxx-uses-touch" properties is specified.

mc13xxx spi0.0: mc13783: rev: 3.3, fin: 0, fab: 0, icid: 2/0
Unable to handle kernel NULL pointer dereference at virtual address 00000018
pgd = c0004000
[00000018] *pgd=00000000
Internal error: Oops: 5 [#1] PREEMPT ARM
CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-next-20131105-00004-g201dd34-dirty #5
task: c7833bc0 ti: c7834000 task.ti: c7834000
PC is at mc13xxx_common_init+0x1fc/0x280
LR is at mfd_add_device+0x2a8/0x308
pc : [<c024875c>]    lr : [<c0248d74>]    psr: 20000013
sp : c7835d38  ip : 00000002  fp : c786a160
r10: 00000000  r9 : c786a170  r8 : 00000000
r7 : c06eab74  r6 : 00000000  r5 : 00000000  r4 : c79ffa10
r3 : 00000008  r2 : 20000013  r1 : c05079c8  r0 : c79ffa10
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0005317f  Table: a0004000  DAC: 00000017
Process swapper (pid: 1, stack limit = 0xc78341c0)
Stack: (0xc7835d38 to 0xc7836000)
5d20:                                                       c0507958 c79ffa10
5d40: c791ab80 0000009b 00000000 c791ab80 c05de138 c023a998 c05a9854 c0293cf8
5d60: c0293ce0 c023a774 c023a998 00000000 c791ab80 c023a998 c79ffc00 c02393ac
5d80: c785a25c c7940e54 c791ab80 c791abb4 c791ab80 c023a4cc c791ab80 c05b2704
5da0: c791ab80 c02395e8 c791ab80 00000000 c791ab88 c0237938 00000000 c01d5ed8
5dc0: 60000013 c791ab80 c791ab80 c791ab80 00000000 c786a170 00000000 c06eaa04
5de0: c786a170 c0294d08 00000001 c79ffc00 c06eab74 c791ab80 00000000 c02953a8
5e00: c79f56a0 00000000 00000063 01312d00 00000000 c79ffc00 c79ffd78 c79ffc00
5e20: c06eaa04 00000000 c79ffd70 c0296cbc c780a840 c02978c0 00000000 c051054c
5e40: c79ffd70 c787c1f0 00000000 c0462b1c 00000000 00000002 c787c1f0 c786a170
5e60: c05b2864 c786a1a4 c05b2864 00000000 c05c5800 c0579430 00000000 c023b614
5e80: c023b5fc c786a170 c05de138 c023a774 00000000 c786a170 c05b2864 c786a1a4
5ea0: 00000000 c023a994 00000000 c05b2864 c023a908 c0239034 c7825d6c c785e610
5ec0: c05b2864 c7a0bae0 c05a9138 c02397dc c051054c c01bd2f8 c05b2864 c05b2864
5ee0: c0585094 579da752 00000000 c023ad38 00000000 00000006 c0585094 c0564a24
5f00: 0000047a 00000000 579da752 00000000 00000000 a0000053 c059b070 00000001
5f20: c06eefc9 c044c6a0 000000a7 c002cd48 c7835f5c c0036f44 c051aae4 c053d7f4
5f40: 00000006 00000006 c059b064 00000006 00000006 c0585094 c058db68 c0564480
5f60: c05850a0 c05c5800 000000a7 c0564c18 00000006 00000006 c0564480 c7833bc0
5f80: c7835f9c c0036da4 00000000 c043013c 00000000 00000000 00000000 00000000
5fa0: 00000000 c0430144 00000000 c0009490 00000000 00000000 00000000 00000000
5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
5fe0: 00000000 00000000 00000000 00000000 00000013 00000000 df7f9b78 3b477df6
[<c024875c>] (mc13xxx_common_init+0x1fc/0x280) from [<c0293cf8>] (spi_drv_probe+0x18/0x1c)
[<c0293cf8>] (spi_drv_probe+0x18/0x1c) from [<c023a774>] (driver_probe_device+0x78/0x20c)
[<c023a774>] (driver_probe_device+0x78/0x20c) from [<c02393ac>] (bus_for_each_drv+0x48/0x90)
[<c02393ac>] (bus_for_each_drv+0x48/0x90) from [<c023a4cc>] (device_attach+0x74/0x80)
[<c023a4cc>] (device_attach+0x74/0x80) from [<c02395e8>] (bus_probe_device+0x88/0xb0)
[<c02395e8>] (bus_probe_device+0x88/0xb0) from [<c0237938>] (device_add+0x31c/0x4c4)
[<c0237938>] (device_add+0x31c/0x4c4) from [<c0294d08>] (spi_add_device+0xa4/0x118)
[<c0294d08>] (spi_add_device+0xa4/0x118) from [<c02953a8>] (spi_register_master+0x53c/0x6a0)
[<c02953a8>] (spi_register_master+0x53c/0x6a0) from [<c0296cbc>] (spi_bitbang_start+0x88/0x100)
[<c0296cbc>] (spi_bitbang_start+0x88/0x100) from [<c02978c0>] (spi_imx_probe+0x3a8/0x478)
[<c02978c0>] (spi_imx_probe+0x3a8/0x478) from [<c023b614>] (platform_drv_probe+0x18/0x48)
[<c023b614>] (platform_drv_probe+0x18/0x48) from [<c023a774>] (driver_probe_device+0x78/0x20c)
[<c023a774>] (driver_probe_device+0x78/0x20c) from [<c023a994>] (__driver_attach+0x8c/0x90)
[<c023a994>] (__driver_attach+0x8c/0x90) from [<c0239034>] (bus_for_each_dev+0x5c/0x8c)
[<c0239034>] (bus_for_each_dev+0x5c/0x8c) from [<c02397dc>] (bus_add_driver+0xd4/0x1c8)
[<c02397dc>] (bus_add_driver+0xd4/0x1c8) from [<c023ad38>] (driver_register+0x78/0xf4)
[<c023ad38>] (driver_register+0x78/0xf4) from [<c0564a24>] (do_one_initcall+0x5c/0x168)
[<c0564a24>] (do_one_initcall+0x5c/0x168) from [<c0564c18>] (kernel_init_freeable+0xe8/0x1a8)
[<c0564c18>] (kernel_init_freeable+0xe8/0x1a8) from [<c0430144>] (kernel_init+0x8/0x110)
[<c0430144>] (kernel_init+0x8/0x110) from [<c0009490>] (ret_from_fork+0x14/0x24)
Code: eaffffdb e3a03008 e1a00004 e59f107c (e5962018)
---[ end trace 71265dd116f3967e ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/mfd/mc13xxx-core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index dbbf8ee..625633a 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -682,14 +682,14 @@ err_revision:
 	if (mc13xxx->flags & MC13XXX_USE_ADC)
 		mc13xxx_add_subdevice(mc13xxx, "%s-adc");
 
-	if (mc13xxx->flags & MC13XXX_USE_CODEC)
+	if ((mc13xxx->flags & MC13XXX_USE_CODEC) && pdata)
 		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-codec",
 					pdata->codec, sizeof(*pdata->codec));
 
 	if (mc13xxx->flags & MC13XXX_USE_RTC)
 		mc13xxx_add_subdevice(mc13xxx, "%s-rtc");
 
-	if (mc13xxx->flags & MC13XXX_USE_TOUCHSCREEN)
+	if ((mc13xxx->flags & MC13XXX_USE_TOUCHSCREEN) && pdata)
 		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-ts",
 				&pdata->touch, sizeof(pdata->touch));
 
@@ -701,6 +701,10 @@ err_revision:
 		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-pwrbutton",
 				pdata->buttons, sizeof(*pdata->buttons));
 	} else {
+		if (mc13xxx->flags & MC13XXX_USE_CODEC)
+			mc13xxx_add_subdevice(mc13xxx, "%s-codec");
+		if (mc13xxx->flags & MC13XXX_USE_TOUCHSCREEN)
+			mc13xxx_add_subdevice(mc13xxx, "%s-ts");
 		mc13xxx_add_subdevice(mc13xxx, "%s-regulator");
 		mc13xxx_add_subdevice(mc13xxx, "%s-led");
 		mc13xxx_add_subdevice(mc13xxx, "%s-pwrbutton");
-- 
1.8.3.2

