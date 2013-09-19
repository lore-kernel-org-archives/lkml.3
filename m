Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab3ISMVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:21:22 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:45139 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab3ISMVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:21:21 -0400
MIME-Version: 1.0
In-Reply-To: <45987104.t6r4hvPgQn@vostro.rjw.lan>
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com>
	<45987104.t6r4hvPgQn@vostro.rjw.lan>
Date: Thu, 19 Sep 2013 14:21:20 +0200
Message-ID: <CACRpkdYA8nyq1j=2zuPvA074KNfp1bxkRZutPwp0j1pSXo09kQ@mail.gmail.com>
Subject: Re: Regression on cpufreq in v3.12-rc1
From: Linus Walleij <linus.walleij@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 12:41 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Wednesday, September 18, 2013 11:21:45 PM Linus Walleij wrote:
>> Hi Rafael, Viresh,
>>
>> I'm seeing this problem and maybe you can help me out fixing it
>> properly:
>>
>> On some machines like the StrongARM SA1100 it seems that
>> cpufreq_get() can be called before the cpufreq driver and thus the
>> policy is set, resulting in a crash like this:
>
> Did you try the current linux-next branch from my tree?

Tested it now and the problem remains. :-(

Not that I can see that any of the fixes there would solve this
problem ... I mean it crashes as soon as you take the semaphore.

Switched to clocksource oscr
------------[ cut here ]------------
kernel BUG at /home/linus/linux-pm/drivers/cpufreq/cpufreq.c:79!
Internal error: Oops - BUG: 0 [#1] ARM
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-rc1-07601-g701ac96 #1
task: c1830000 ti: c1832000 task.ti: c1832000
PC is at lock_policy_rwsem_read+0x2c/0x3c
LR is at cpufreq_get+0x34/0x68
pc : [<c01df42c>]    lr : [<c01e0ae8>]    psr: 60000053
sp : c1833d00  ip : c1833d10  fp : c1833d0c
r10: c182d274  r9 : c182d290  r8 : c182d258
r7 : c182d2e4  r6 : c182d23c  r5 : 00000000  r4 : 00000000
r3 : c05d279c  r2 : 00000000  r1 : 60000053  r0 : 00000000
Flags: nZCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
Control: c000717f  Table: c000717f  DAC: 00000017
Process swapper (pid: 1, stack limit = 0xc18321b0)
Stack: (0xc1833d00 to 0xc1834000)
3d00: c1833d24 c1833d10 c01e0ae8 c01df40c c182d008 00000000 c1833d38 c1833d28
3d20: c01d7050 c01e0ac0 c182d008 c1833d64 c1833d3c c01d6ba8 c01d7044 00000200
3d40: 2c000000 20000000 2fffffff 2bffffff 00000000 00000000 c1833d88 c1833d68
3d60: c01d70ec c01d6ab4 c182d008 00000000 c182d000 c182d000 00000002 c1833dbc
3d80: c1833d8c c01d71a0 c01d706c c05d2350 c05c56bc c05c56bc c05c56bc c05d2310
3da0: c05e4a94 00000000 00000000 00000000 c1833dcc c1833dc0 c01d7540 c01d7110
3dc0: c1833ddc c1833dd0 c01d732c c01d7530 c1833dec c1833de0 c01a2f14 c01d7324
3de0: c1833e10 c1833df0 c01a1970 c01a2f00 c05c56bc c05c56f0 c05d2310 c01a1ca8
3e00: 00000000 c1833e20 c1833e14 c01a1a5c c01a1874 c1833e3c c1833e24 c01a1d30
3e20: c01a1a38 00000000 c1833e40 c05d2310 c1833e64 c1833e40 c01a0104 c01a1cb4
3e40: c1829e8c c184e8d0 c18c1900 c05d2310 c05d0d1c 00000000 c1833e74 c1833e68
3e60: c01a1748 c01a009c c1833e98 c1833e78 c01a0f44 c01a1734 c031b9ac c05d2310
3e80: 00000000 00000006 c0374794 c1833eb0 c1833e9c c01a2288 c01a0e70 c1832000
3ea0: 00000000 c1833ec0 c1833eb4 c01a3208 c01a2234 c1833ed0 c1833ec4 c03747ac
3ec0: c01a31c4 c1833f34 c1833ed4 c00085a4 c03747a0 00000005 00000000 00000005
3ee0: c1833f34 c1833ef0 c0034ea8 c0034994 00000060 00000005 00000005 c035e6c0
3f00: c035bec4 c0002148 c0002140 00000005 00000005 00000006 c037bf28 00000005
3f20: 00000006 c0378d54 c1833f60 c1833f38 c035e590 c0008514 00000005 00000005
3f40: c035e6c0 00000006 c029dcd8 00000000 00000000 c1833f74 c1833f64 c035e5e4
3f60: c035e51c 00000000 c1833f84 c1833f78 c035e6bc c035e5cc c1833f98 c1833f88
3f80: c035ea98 c035e6a0 00000000 c1833fac c1833f9c c029dce8 c035ea58 00000000
3fa0: 00000000 c1833fb0 c000f9b0 c029dce4 00000000 00000000 00000000 00000000
3fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
3fe0: 00000000 00000000 00000000 00000000 00000013 00000000 7fc33b8e cc8610cc
Backtrace:
[<c01df400>] (lock_policy_rwsem_read+0x0/0x3c) from [<c01e0ae8>]
(cpufreq_get+0x34/0x68)
[<c01e0ab4>] (cpufreq_get+0x0/0x68) from [<c01d7050>]
(sa1100_pcmcia_set_timing+0x18/0x28)
 r5:00000000 r4:c182d008
[<c01d7038>] (sa1100_pcmcia_set_timing+0x0/0x28) from [<c01d6ba8>]
(soc_pcmcia_add_one+0x100/0x220)
 r4:c182d008
[<c01d6aa8>] (soc_pcmcia_add_one+0x0/0x220) from [<c01d70ec>]
(sa11xx_drv_pcmcia_add_one+0x8c/0xa4)
[<c01d7060>] (sa11xx_drv_pcmcia_add_one+0x0/0xa4) from [<c01d71a0>]
(sa11xx_drv_pcmcia_probe+0x9c/0xf8)
 r8:00000002 r7:c182d000 r6:c182d000 r5:00000000 r4:c182d008
[<c01d7104>] (sa11xx_drv_pcmcia_probe+0x0/0xf8) from [<c01d7540>]
(pcmcia_h3600_init+0x1c/0x24)
[<c01d7524>] (pcmcia_h3600_init+0x0/0x24) from [<c01d732c>]
(sa11x0_drv_pcmcia_probe+0x14/0x18)
[<c01d7318>] (sa11x0_drv_pcmcia_probe+0x0/0x18) from [<c01a2f14>]
(platform_drv_probe+0x20/0x24)
[<c01a2ef4>] (platform_drv_probe+0x0/0x24) from [<c01a1970>]
(really_probe+0x108/0x1c4)
[<c01a1868>] (really_probe+0x0/0x1c4) from [<c01a1a5c>]
(driver_probe_device+0x30/0x34)
 r8:00000000 r7:c01a1ca8 r6:c05d2310 r5:c05c56f0 r4:c05c56bc
[<c01a1a2c>] (driver_probe_device+0x0/0x34) from [<c01a1d30>]
(__driver_attach+0x88/0x8c)
[<c01a1ca8>] (__driver_attach+0x0/0x8c) from [<c01a0104>]
(bus_for_each_dev+0x74/0x98)
 r6:c05d2310 r5:c1833e40 r4:00000000
[<c01a0090>] (bus_for_each_dev+0x0/0x98) from [<c01a1748>]
(driver_attach+0x20/0x28)
 r7:00000000 r6:c05d0d1c r5:c05d2310 r4:c18c1900
[<c01a1728>] (driver_attach+0x0/0x28) from [<c01a0f44>]
(bus_add_driver+0xe0/0x1c8)
[<c01a0e64>] (bus_add_driver+0x0/0x1c8) from [<c01a2288>]
(driver_register+0x60/0x104)
 r7:c0374794 r6:00000006 r5:00000000 r4:c05d2310
[<c01a2228>] (driver_register+0x0/0x104) from [<c01a3208>]
(__platform_driver_register+0x50/0x64)
 r5:00000000 r4:c1832000
[<c01a31b8>] (__platform_driver_register+0x0/0x64) from [<c03747ac>]
(sa11x0_pcmcia_init+0x18/0x20)
[<c0374794>] (sa11x0_pcmcia_init+0x0/0x20) from [<c00085a4>]
(do_one_initcall+0x9c/0xfc)
[<c0008508>] (do_one_initcall+0x0/0xfc) from [<c035e590>]
(do_initcall_level+0x80/0xb0)
 r7:c0378d54 r6:00000006 r5:00000005 r4:c037bf28
[<c035e510>] (do_initcall_level+0x0/0xb0) from [<c035e5e4>]
(do_initcalls+0x24/0x30)
 r7:00000000 r6:00000000 r5:c029dcd8 r4:00000006
[<c035e5c0>] (do_initcalls+0x0/0x30) from [<c035e6bc>]
(do_basic_setup+0x28/0x2c)
 r4:00000000
[<c035e694>] (do_basic_setup+0x0/0x2c) from [<c035ea98>]
(kernel_init_freeable+0x4c/0xdc)
[<c035ea4c>] (kernel_init_freeable+0x0/0xdc) from [<c029dce8>]
(kernel_init+0x10/0xf0)
 r4:00000000
[<c029dcd8>] (kernel_init+0x0/0xf0) from [<c000f9b0>] (ret_from_fork+0x14/0x24)
 r4:00000000
Code: e59f0014 eb030036 e3a00000 e89da800 (e7f001f2)
---[ end trace a421e7362f5e31a5 ]---


Yours,
Linus Walleij
