Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3JRLeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:34:03 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50305 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab3JRLd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:33:57 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52611C9A.8080707@roeck-us.net>
Date: Fri, 18 Oct 2013 04:33:46 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>
CC: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        khilman@linaro.org
Subject: Re: linux-next: Tree for Oct 17
References: <20131018003847.GH2443@sirena.org.uk> <20131018074526.GA30578@quad.lixom.net>
In-Reply-To: <20131018074526.GA30578@quad.lixom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 12:45 AM, Olof Johansson wrote:
> On Fri, Oct 18, 2013 at 01:38:47AM +0100, Mark Brown wrote:
>> Hi all,
>>
>> I've uploaded today's linux-next tree to the master branch of the
>> repository below:
>>
>>          git://gitorious.org/thierryreding/linux-next.git >
>> A next-20131017 tag is also provided for convenience.
>>
>> One new conflict today but otherwise uneventful.  x86_64 allmodconfigs
>> build after each merge but no other build tests were done.
>
> Hi,
>
> I'm seeing a fairly large fallout on boot testing. See
> http://lists.linaro.org/pipermail/kernel-build-reports/2013-October/000719.html
> for full list (I need to start providing longer backlogs for failures, the top
> of the oopses is lost in the email).
>
> For example, on dove (SolidRun Cubox) I see:
>
> [    0.707248] Unable to handle kernel NULL pointer dereference at virtual address 00000054
> [    0.715297] pgd = c0004000
> [    0.717984] [00000054] *pgd=00000000
> [    0.721548] Internal error: Oops: 5 [#1] ARM
> [    0.725794] Modules linked in:
> [    0.728841] CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-rc5-next-20131017 #1
> [    0.736114] task: ef035c00 ti: ef036000 task.ti: ef036000
> [    0.741497] PC is at kfree+0x54/0xc4
> [    0.745063] LR is at ata_host_register+0x3c/0x290
> [    0.749741] pc : [<c008ad28>]    lr : [<c023e168>]    psr: 40000193
> [    0.749741] sp : ef037da8  ip : 00000034  fp : 00000000
> [    0.761159] r10: 00000000  r9 : ef061810  r8 : c0519fc8
> [    0.766353] r7 : c0519fc8  r6 : a0000113  r5 : ffffffff  r4 : ef1c9dd0
> [    0.772850] r3 : c0fc8fe0  r2 : c07c9000  r1 : 40000000  r0 : 00000000
> [    0.779349] Flags: nZcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [    0.786708] Control: 10c5387d  Table: 00004019  DAC: 00000015
> [    0.792428] Process swapper (pid: 1, stack limit = 0xef036248)
> [    0.798234] Stack: (0xef037da8 to 0xef038000)
> [    0.957218] [<c008ad28>] (kfree+0x54/0xc4) from [<c023e168>] (ata_host_register+0x3c/0x290)
> [    0.965542] [<c023e168>] (ata_host_register+0x3c/0x290) from [<c023e498>] (ata_host_activate+0xdc/0x118)
> [    0.974992] [<c023e498>] (ata_host_activate+0xdc/0x118) from [<c0251130>] (mv_platform_probe+0x2dc/0x36c)
> [    0.984527] [<c0251130>] (mv_platform_probe+0x2dc/0x36c) from [<c021b6c4>] (platform_drv_probe+0x18/0x48)
> [    0.994051] [<c021b6c4>] (platform_drv_probe+0x18/0x48) from [<c0219e88>] (really_probe+0x74/0x1fc)
> [    1.003062] [<c0219e88>] (really_probe+0x74/0x1fc) from [<c021a0fc>] (__driver_attach+0x98/0x9c)
> [    1.011804] [<c021a0fc>] (__driver_attach+0x98/0x9c) from [<c02186cc>] (bus_for_each_dev+0x60/0x94)
> [    1.020808] [<c02186cc>] (bus_for_each_dev+0x60/0x94) from [<c0219728>] (bus_add_driver+0x148/0x1f0)
> [    1.029898] [<c0219728>] (bus_add_driver+0x148/0x1f0) from [<c021a700>] (driver_register+0x78/0xf8)
> [    1.038911] [<c021a700>] (driver_register+0x78/0xf8) from [<c04e2ed0>] (mv_init+0x30/0x50)
> [    1.047144] [<c04e2ed0>] (mv_init+0x30/0x50) from [<c000877c>] (do_one_initcall+0x100/0x14c)
> [    1.055557] [<c000877c>] (do_one_initcall+0x100/0x14c) from [<c04cead4>] (kernel_init_freeable+0x120/0x1c0)
> [    1.065259] [<c04cead4>] (kernel_init_freeable+0x120/0x1c0) from [<c038fe30>] (kernel_init+0x8/0x158)
> [    1.074441] [<c038fe30>] (kernel_init+0x8/0x158) from [<c000e0b8>] (ret_from_fork+0x14/0x3c)
> [    1.082841] Code: e0823283 e3110902 1593301c e593001c (e5904054)
>

My 'sh' qemu run fails with:

BUG: unable to handle kernel paging request at 00006e81
PC: [<8c1f10ce>] ata_finalize_port_ops+0x4e/0xc0
pgd = 8c401150
[00006e81] *pgd=00000000
Oops: 0000 [#1]
Modules linked in:

CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-rc5-next-20131017-06210-gdaa01b0 #1
task: 8fc27be0 ti: 8fc28000 task.ti: 8fc28000
PC is at ata_finalize_port_ops+0x4e/0xc0
PR is at ata_host_start+0x48/0x1c0
PC  : 8c1f10ce SP  : 8fc29e0c SR  : 40008001 TEA : 00006e81
R0  : 00000000 R1  : 8fc83018 R2  : 00006e81 R3  : 00000000
R4  : 8fc83000 R5  : 000000bc R6  : 00006e69 R7  : 8fc830f0
R8  : 8fd47cac R9  : 8fd47cac R10 : 00000000 R11 : 8c207d80
R12 : 8c1f1080 R13 : 00000000 R14 : 00000064
MACH: 00000000 MACL: 00000001 GBR : 00000000 PR  : 8c1f21e8

Call trace:
  [<8c1f807e>] ata_host_activate+0x1e/0x120
  [<8c207d80>] ata_sff_interrupt+0x0/0x240
  [<8c209ed6>] pata_platform_probe+0x76/0x120
  [<8c209ed6>] pata_platform_probe+0x76/0x120
  [<8c1cf440>] platform_get_resource+0x0/0x60
  [<8c1cfeda>] platform_drv_probe+0x1a/0x60
  [<8c012800>] arch_local_save_flags+0x0/0x20
  [<8c1ce1ee>] driver_probe_device+0x6e/0x260
  [<8c012820>] arch_local_irq_restore+0x0/0x40
  [<8c1cc4c0>] klist_devices_put+0x0/0x20
  [<8c1ce466>] __driver_attach+0x86/0xa0
  [<8c2fa800>] mutex_lock+0x0/0x60
  [<8c1cc8c8>] bus_for_each_dev+0x48/0x80
  [<8c1cc620>] next_device+0x0/0x20
  [<8c1ce3e0>] __driver_attach+0x0/0xa0
  [<8c1cd862>] bus_add_driver+0xc2/0x220
  [<8c1ce90c>] driver_register+0x4c/0x120
  [<8c3eeccc>] pata_platform_driver_init+0x0/0x14
  [<8c011244>] do_one_initcall+0x1c4/0x280
  [<8c3eeccc>] pata_platform_driver_init+0x0/0x14
  [<8c059160>] register_irq_proc+0x0/0xa0
  [<8c10b6f0>] proc_create_data+0x50/0xe0
  [<8c03f2b8>] parse_args+0x218/0x3a0
  [<8c03f000>] parameq+0x0/0xa0
  [<8c012820>] arch_local_irq_restore+0x0/0x40
  [<8c3e0a06>] kernel_init_freeable+0xce/0x1c8
  [<8c011080>] do_one_initcall+0x0/0x280
  [<8c3e0158>] repair_env_string+0x0/0x80
  [<8c2f492c>] kernel_init+0xc/0xe0
  [<8c012820>] arch_local_irq_restore+0x0/0x40
  [<8c04a580>] schedule_tail+0x0/0x60
  [<8c0181e8>] ret_from_kernel_thread+0xc/0x14
  [<8c04a580>] schedule_tail+0x0/0x60
  [<8c2f4920>] kernel_init+0x0/0xe0

Code:
   8c1f10c8:  mov.l     @r1, r3
   8c1f10ca:  tst       r3, r3
   8c1f10cc:  bf        8c1f10c0
->8c1f10ce:  mov.l     @r2, r3
   8c1f10d0:  mov.l     r3, @r1
   8c1f10d2:  add       #4, r1
   8c1f10d4:  cmp/hi    r1, r7
   8c1f10d6:  bt.s      8c1f10c8
   8c1f10d8:  add       #4, r2

I can try to bisect later today if needed, but it looks similar.

Also, the parisc:a500_defconfig is a new build failure.

Guenter

