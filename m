Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934349Ab3CMWgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 18:36:16 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:56885 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933246Ab3CMWgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 18:36:14 -0400
Message-ID: <5140FF55.7040708@gmail.com>
Date: Thu, 14 Mar 2013 02:36:05 +0400
From: Sergey Yanovich <ynvich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: gcc/binutils bug suspected -- recommended actions?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.2 ARM kernel panics on boot. BUG() log:

------------[ cut here ]------------
Kernel BUG at c0226bf4 [verbose debug info unavailable]
Internal error: Oops - BUG: 0 [#1] PREEMPT ARM
Modules linked in:
CPU: 0    Not tainted  (3.8.2+ #2)
PC is at pxa2xx_flash_probe+0x150/0x1a8
LR is at __arm_ioremap_pfn_caller+0x244/0x280
pc : [<c0226bf4>]    lr : [<c000fed0>]    psr: 40000013
sp : c782ddf0  ip : 00000000  fp : c782de14
r10: c04b4010  r9 : 00000000  r8 : 00000065
r7 : c04d4c28  r6 : c04d4fd0  r5 : c04d4f88  r4 : c79fec20
r3 : 00000000  r2 : 00000001  r1 : fffe8000  r0 : ce000000
Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0000397f  Table: a0004000  DAC: 00000017
Process swapper (pid: 1, stack limit = 0xc782c1c0)
Stack: (0xc782ddf0 to 0xc782e000)
dde0:                                     c00d92a8 c00d906c c04d4c38 c04d4c6c
de00: c04e24a4 c01fdd0c c782de24 c782de18 c01fed10 c0226ab0 c782de44 c782de28
de20: c01fdbc0 c01fed00 00000000 c04d4c38 c04d4c6c c04e24a4 c782de64 c782de48
de40: c01fdd7c c01fdb24 00000000 00000000 c782de68 c04e24a4 c782de8c c782de68
de60: c01fc218 c01fdd18 c78223cc c784fd50 c04e24a4 c7b05cc0 c04e13e8 00000000
de80: c782de9c c782de90 c01fd72c c01fc1c8 c782decc c782dea0 c01fd2f0 c01fd718
dea0: c0454004 c04c4bc4 c782decc c04e24a4 c04bdfa0 c04c4bc4 c04eb700 00000065
dec0: c782def4 c782ded0 c01fe0b4 c01fd228 00000006 c04bdfa0 c04c4bc4 c04eb700
dee0: 00000065 c04b4010 c782df04 c782def8 c01fef58 c01fe01c c782df14 c782df08
df00: c04b4024 c01fef18 c782df54 c782df18 c00085f4 c04b401c 00000006 00000006
df20: 00000065 c04a185c c782df54 00000006 c04bdfa0 c04c4bc4 c04eb700 00000065
df40: 00000000 c04bdfac c782df94 c782df58 c04a38e4 c0008564 00000006 00000006
df60: c04a31a8 2d861c1d e3030f2f 2c3f5f87 00000000 c0344258 00000000 00000000
df80: 00000000 00000000 c782dfac c782df98 c0344268 c04a37fc 00000000 00000000
dfa0: 00000000 c782dfb0 c00091b0 c0344264 00000000 00000000 00000000 00000000
dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
dfe0: 00000000 00000000 00000000 00000000 00000013 00000000 cf930707 172e4f0d
Backtrace:
[<c0226aa4>] (pxa2xx_flash_probe+0x0/0x1a8) from [<c01fed10>] (platform_drv_probe+0x1c/0x20)
  r7:c01fdd0c r6:c04e24a4 r5:c04d4c6c r4:c04d4c38
[<c01fecf4>] (platform_drv_probe+0x0/0x20) from [<c01fdbc0>] (driver_probe_device+0xa8/0x1f4)
[<c01fdb18>] (driver_probe_device+0x0/0x1f4) from [<c01fdd7c>] (__driver_attach+0x70/0x94)
  r6:c04e24a4 r5:c04d4c6c r4:c04d4c38 r3:00000000
[<c01fdd0c>] (__driver_attach+0x0/0x94) from [<c01fc218>] (bus_for_each_dev+0x5c/0x98)
  r6:c04e24a4 r5:c782de68 r4:00000000 r3:00000000
[<c01fc1bc>] (bus_for_each_dev+0x0/0x98) from [<c01fd72c>] (driver_attach+0x20/0x28)
  r7:00000000 r6:c04e13e8 r5:c7b05cc0 r4:c04e24a4
[<c01fd70c>] (driver_attach+0x0/0x28) from [<c01fd2f0>] (bus_add_driver+0xd4/0x22c)
[<c01fd21c>] (bus_add_driver+0x0/0x22c) from [<c01fe0b4>] (driver_register+0xa4/0x134)
  r8:00000065 r7:c04eb700 r6:c04c4bc4 r5:c04bdfa0 r4:c04e24a4
[<c01fe010>] (driver_register+0x0/0x134) from [<c01fef58>] (platform_driver_register+0x4c/0x60)
[<c01fef0c>] (platform_driver_register+0x0/0x60) from [<c04b4024>] (pxa2xx_flash_driver_init+0x14/0x1c)
[<c04b4010>] (pxa2xx_flash_driver_init+0x0/0x1c) from [<c00085f4>] (do_one_initcall+0x9c/0x174)
[<c0008558>] (do_one_initcall+0x0/0x174) from [<c04a38e4>] (kernel_init_freeable+0xf4/0x1b4)
[<c04a37f0>] (kernel_init_freeable+0x0/0x1b4) from [<c0344268>] (kernel_init+0x10/0xec)
[<c0344258>] (kernel_init+0x0/0xec) from [<c00091b0>] (ret_from_fork+0x14/0x24)
  r4:00000000 r3:00000000
Code: e3e0000b ea00000e e3e00004 ea00000c (e7f001f2)
---[ end trace d485c4bc3d1e9fb9 ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

The complier is debian gcc-4.7-arm-linux-gnueabi (4.7.2-5). objdump of the failing
function contains a strange instruction at the failure address:

----------------
c0226b5c:       eb0479d6        bl      c03452bc <printk>
c0226b60:       e59f30d8        ldr     r3, [pc, #216]  ; c0226c40 <pxa2xx_flash_probe+0x19c>
c0226b64:       e5843020        str     r3, [r4, #32]
c0226b68:       e594301c        ldr     r3, [r4, #28]
c0226b6c:       e3530004        cmp     r3, #4
c0226b70:       8a00001f        bhi     c0226bf4 <pxa2xx_flash_probe+0x150>
c0226b74:       e3a02001        mov     r2, #1
c0226b78:       e1a02312        lsl     r2, r2, r3
c0226b7c:       e3120016        tst     r2, #22
c0226b80:       1a00001c        bne     c0226bf8 <pxa2xx_flash_probe+0x154>
c0226b84:       ea00001a        b       c0226bf4 <pxa2xx_flash_probe+0x150>
c0226b88:       e5940010        ldr     r0, [r4, #16]
c0226b8c:       ebf7a396        bl      c000f9ec <__arm_iounmap>
c0226b90:       e5940014        ldr     r0, [r4, #20]
c0226b94:       e3500000        cmp     r0, #0
c0226b98:       0a000013        beq     c0226bec <pxa2xx_flash_probe+0x148>
c0226b9c:       ebf7a392        bl      c000f9ec <__arm_iounmap>
c0226ba0:       ea000011        b       c0226bec <pxa2xx_flash_probe+0x148>
c0226ba4:       e3a06000        mov     r6, #0
c0226ba8:       e58060e0        str     r6, [r0, #224]  ; 0xe0
c0226bac:       e5953020        ldr     r3, [r5, #32]
c0226bb0:       e59f108c        ldr     r1, [pc, #140]  ; c0226c44 <pxa2xx_flash_probe+0x1a0>
c0226bb4:       e1a02006        mov     r2, r6
c0226bb8:       e58d3000        str     r3, [sp]
c0226bbc:       e595301c        ldr     r3, [r5, #28]
c0226bc0:       e5940000        ldr     r0, [r4]
c0226bc4:       ebffc792        bl      c0218a14 <mtd_device_parse_register>
c0226bc8:       e2870010        add     r0, r7, #16
c0226bcc:       e1a01004        mov     r1, r4
c0226bd0:       ebff5a75        bl      c01fd5ac <dev_set_drvdata>
c0226bd4:       e1a00006        mov     r0, r6
c0226bd8:       ea000012        b       c0226c28 <pxa2xx_flash_probe+0x184>
c0226bdc:       e3e00012        mvn     r0, #18
c0226be0:       ea000010        b       c0226c28 <pxa2xx_flash_probe+0x184>
c0226be4:       e3e0000b        mvn     r0, #11
c0226be8:       ea00000e        b       c0226c28 <pxa2xx_flash_probe+0x184>
c0226bec:       e3e00004        mvn     r0, #4
c0226bf0:       ea00000c        b       c0226c28 <pxa2xx_flash_probe+0x184>
c0226bf4:       e7f001f2        .word   0xe7f001f2
---------------------

Where should I look?

Thanks.
