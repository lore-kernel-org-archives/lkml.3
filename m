Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab3GVJbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 05:31:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57968 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756928Ab3GVJbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 05:31:07 -0400
Message-ID: <51ECFBAC.7090900@ti.com>
Date: Mon, 22 Jul 2013 12:30:20 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <catalin.marinas@arm.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>, "tony@atomide.com" <tony@atomide.com>,
        "Mesfin, Yebio" <ymesfin@ti.com>
Subject: linux-3.11-rc1: Internal error: Oops - undefined instruction: 0 [#1]
 SMP ARM on OMAP3/AM335x
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I observe the following problem on booting v3.11-rc1 on OMAP3 beagle board.

[    5.888946] Internal error: Oops - undefined instruction: 0 [#1] SMP ARM
[    5.896057] Modules linked in:
[    5.899322] CPU: 0 PID: 9 Comm: rcu_sched Not tainted 3.11.0-rc2-00001-g1ea701a #876
[    5.907501] task: ce0720c0 ti: ce07a000 task.ti: ce07a000
[    5.913208] PC is at check_and_switch_context+0x130/0x4dc
[    5.918914] LR is at check_and_switch_context+0xd8/0x4dc
[    5.924530] pc : [<c0023d1c>]    lr : [<c0023cc4>]    psr: 40000193
[    5.924530] sp : ce07bd70  ip : 00000000  fp : c078d7b0
[    5.936645] r10: ce5084c0  r9 : 00000000  r8 : 00000201
[    5.942169] r7 : 00000000  r6 : 00000000  r5 : 00000000  r4 : c081de04
[    5.949066] r3 : 00000000  r2 : d0091010  r1 : 00000000  r0 : 00000001
[    5.955963] Flags: nZcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[    5.963775] Control: 10c5387d  Table: 80004019  DAC: 00000017
[    5.969848] Process rcu_sched (pid: 9, stack limit = 0xce07a240)
[    5.976165] Stack: (0xce07bd70 to 0xce07c000)
[    5.980773] bd60:                                     c078c990 961b12b4 00000000 ce508658
[    5.989440] bd80: c0780510 20000193 00000200 00000000 c078c944 c0780510 c0780518 ce5084c0
[    5.998077] bda0: c0f90fc0 ce425440 ce5084c0 c078fd08 ce0720c0 ce184a40 ce07a000 c0f90fc0
[    6.006713] bdc0: ce07be74 c05065bc c081fe24 ce0720c0 ce072558 00000000 5efa46d6 00000001
[    6.015350] bde0: 00000000 c050331c c0782fc0 c0782fc0 c0782fc0 c0782fc0 0007735a 00000000
[    6.023986] be00: c0782fc0 c0782fc0 00000000 00000000 60000193 00000498 00000000 c08304c0
[    6.032623] be20: a0000113 c00531b8 ce07be78 ce07a000 ce0720c0 c05080dc 00000001 c07860c0
[    6.041259] be40: ce07bf00 ce07a000 00000064 c0097bfc a0000113 ce07be7c c08304c0 ffff8d19
[    6.049926] be60: c08304c0 c07860c0 ce07bf00 ce07a000 00000064 c050331c a0000113 c08305b8
[    6.058563] be80: c08305b8 ffff8d19 c08304c0 c005329c ce0720c0 ffffffff ffffffff 00000000
[    6.067199] bea0: 00000000 00000000 00000000 00000000 c083150c 00000000 00000000 c0663d9c
[    6.075836] bec0: c078d1e0 ce07a000 c07e4c50 c078d1e0 00000001 00000002 c07e4b40 c00aed80
[    6.084472] bee0: 00000000 ce07bf00 c07e4cb8 c07e4c00 00000001 00000000 ce0720c0 c006749c
[    6.093109] bf00: c07e4c70 c07e4c70 60000153 ce04be8c 00000000 c07e4b40 c00aeacc 00000000
[    6.101745] bf20: 00000000 00000000 00000000 c0066b74 00000001 00000000 00000000 c07e4b40
[    6.110382] bf40: 00000000 00000000 dead4ead ffffffff ffffffff c08323fc 00000000 00000000
[    6.119049] bf60: c0662544 ce07bf64 ce07bf64 00000000 00000000 dead4ead ffffffff ffffffff
[    6.127685] bf80: c08323fc 00000000 00000000 c0662544 ce07bf90 ce07bf90 ce072a80 ce04be8c
[    6.136322] bfa0: c0066ad0 00000000 00000000 c0013ea8 00000000 00000000 00000000 00000000
[    6.144958] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    6.153594] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 01ffdf08 20ffde24
[    6.162261] [<c0023d1c>] (check_and_switch_context+0x130/0x4dc) from [<c05065bc>] (__schedule+0x334/0x7f4)
[    6.172454] [<c05065bc>] (__schedule+0x334/0x7f4) from [<c050331c>] (schedule_timeout+0x124/0x214)
[    6.181945] [<c050331c>] (schedule_timeout+0x124/0x214) from [<c00aed80>] (rcu_gp_kthread+0x2b4/0x52c)
[    6.191772] [<c00aed80>] (rcu_gp_kthread+0x2b4/0x52c) from [<c0066b74>] (kthread+0xa4/0xb0)
[    6.200622] [<c0066b74>] (kthread+0xa4/0xb0) from [<c0013ea8>] (ret_from_fork+0x14/0x2c)
[    6.209167] Code: e3120602 1e083f13 ee073f9a ee073f95 (ee083f33) 
[    6.215606] ---[ end trace bad27cd834df5662 ]---

I'm suspecting the issue to be caused by the below commit

commit 93dc68876b608da041fe40ed39424b0fcd5aa2fb
Author: Catalin Marinas <catalin.marinas@arm.com>
Date:   Tue Mar 26 23:35:04 2013 +0100

    ARM: 7684/1: errata: Workaround for Cortex-A15 erratum 798181 (TLBI/DSB operations)

It seems that in check_and_switch_context(), we call dummy_flush_tlb_a15_erratum() which an A15 instruction
without A15 revision check.

cheers,
-roger
