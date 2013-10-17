Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab3JQMYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:24:23 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:41300 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab3JQMYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:24:20 -0400
Date: Thu, 17 Oct 2013 15:24:11 +0300
From: Aliaksei Katovich <aliaksei.katovich@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-samsung-soc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Naour Romain <romain.naour@openwide.fr>,
        linux-arm-kernel@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v2 0/4] Exynos 5410 Dual cluster support
Message-ID: <20131017122411.GF3061@cat.local>
References: <1381763305-7085-1-git-send-email-v.tyrtov@samsung.com>
 <87k3hc3lso.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <87k3hc3lso.fsf@linaro.org>
X-Operating-System: GNU/Linux
X-Kernel: Linux 3.12.0-rc1+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

hi Kevin;

> Vyacheslav Tyrtov <v.tyrtov@samsung.com> writes:
> 
> > The series of patches represent support of Exynos 5410 SoC
> >     
> > The Exynos 5410 is the first Samsung SoC based on bigLITTLE architecture.
> > Patches allow all 8 CPU cores (4 x A7 and 4 x A15) to run at the same time
> >     
> > Patches add new platform description, support of clock controller,
> > dual cluster support and device tree for Exynos 5410 
> >    
> > Has been build on v3.12-rc5.
> > Has been tested on Exynos 5410 reference board (exynos_defconfig).
> 
> Has anyone tried this on the exynos5410 based odroid-xu yet?  
> 
> I tried booting this on my recently arrived odroid-xu, but am not
> getting it to boot.

	I am able to boot my odroid-xu+e to busybox with these patches applied
	against 3.12-rc5: exynos_defconfig and exynos5410-smdk5410.dtb were
	used.

	However there seem to be some issues with virq allocations, check log
	in attachment.

--
Aliaksei

> 
> I'm not yet terribly familiar with this SoC, what are the settings 
> needed for DEBUG_LL on this board?
> 
> Thanks,
> 
> Kevin
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="odroid-xu.log"

Starting kernel ...
                   
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edcd ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq337 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edce ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq338 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edcf ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq339 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edd0 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq340 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edd1 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq341 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edd2 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq342 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edd3 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq343 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edd4 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq344 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edd5 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq345 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edd6 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq346 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edd7 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq347 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edd8 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq348 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edd9 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq349 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edda ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq350 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719eddb ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq351 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719eddc ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq352 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719eddd ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq353 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edde ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq354 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719eddf ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq355 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ede0 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq356 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ede1 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq357 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ede2 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq358 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ede3 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq359 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ede4 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq360 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ede5 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq361 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ede6 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq362 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ede7 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq363 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ede8 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq364 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ede9 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq365 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edea ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq366 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edeb ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq367 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edec ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq368 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719eded ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq369 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edee ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq370 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edef ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq371 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edf0 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq372 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edf1 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq373 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edf2 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq374 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edf3 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq375 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edf4 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq376 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edf5 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq377 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edf6 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq378 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edf7 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq379 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edf8 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq380 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edf9 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq381 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edfa ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq382 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edfb ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq383 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edfc ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq384 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edfd ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq385 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edfe ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq386 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719edff ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq387 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee00 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq388 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee01 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq389 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee02 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq390 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee03 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq391 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee04 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq392 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee05 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq393 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee06 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq394 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee07 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq395 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee08 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq396 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee09 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq397 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee0a ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq398 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee0b ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq399 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee0c ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq400 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee0d ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq401 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee0e ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq402 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee0f ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq403 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee10 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq404 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee11 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq405 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee12 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq406 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee13 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq407 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee14 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq408 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee15 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq409 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee16 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq410 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee17 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq411 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee18 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq412 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee19 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq413 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee1a ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq414 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee1b ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
[    0.000000] error: virq415 is not allocated
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
[    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
[    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
[    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
[    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
)
[    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
[    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
[    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
[    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
[    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
[    0.000000] ---[ end trace 1b75b31a2719ee1c ]---
[    0.000000] sched_clock: 32 bits at 200 Hz, resolution 5000000ns, wraps every 4294967291ms
[    0.000000] Console: colour dummy device 80x30
[    0.000000] console [tty1] enabled
[    0.015000] Calibrating delay loop... 1785.85 BogoMIPS (lpj=4464640)
[    0.035000] pid_max: default: 32768 minimum: 301
[    0.035000] Mount-cache hash table entries: 512
[    0.035000] CPU: Testing write buffer coherency: ok
[    0.035000] CPU0: update cpu_power 1024
[    0.035000] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.035000] Setting up static identity map for 0xc03687b0 - 0xc0368808
[    0.035000] ARM CCI driver probed
[    0.035000] EDCS power management initialized
[    0.035000] CPU1: Booted secondary processor
[    0.065000] CPU1: update cpu_power 1024
[    0.065000] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.065000] Brought up 2 CPUs
[    0.065000] SMP: Total of 2 processors activated.
[    0.065000] CPU: All CPU(s) started in SVC mode.
[    0.065000] devtmpfs: initialized
[    0.075000] VFP support v0.3: implementor 41 architecture 4 part 30 variant f rev 0
[    0.075000] pinctrl core: initialized pinctrl subsystem
[    0.075000] regulator-dummy: no parameters
[    0.075000] NET: Registered protocol family 16
[    0.075000] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.080000] S3C Power Management, Copyright 2004 Simtec Electronics
[    0.080000] EXYNOS: PMU not supported
[    0.080000] EXYNOS: Initializing architecture
[    0.090000] bio: create slab <bio-0> at 0
[    0.095000] SCSI subsystem initialized
[    0.095000] usbcore: registered new interface driver usbfs
[    0.095000] usbcore: registered new interface driver hub
[    0.095000] usbcore: registered new device driver usb
[    0.095000] Switched to clocksource mct-frc
[    0.110000] NET: Registered protocol family 2
[    0.110000] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.110000] TCP bind hash table entries: 8192 (order: 5, 163840 bytes)
[    0.110000] TCP: Hash tables configured (established 8192 bind 8192)
[    0.110000] TCP: reno registered
[    0.110000] UDP hash table entries: 512 (order: 2, 24576 bytes)
[    0.110000] UDP-Lite hash table entries: 512 (order: 2, 24576 bytes)
[    0.110000] NET: Registered protocol family 1
[    0.110000] Trying to unpack rootfs image as initramfs...
[    0.180000] Freeing initrd memory: 1496K (c2001000 - c2177000)
[    0.185000] bounce pool size: 64 pages
[    0.195000] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.195000] msgmni has been set to 1475
[    0.195000] io scheduler noop registered
[    0.195000] io scheduler deadline registered
[    0.195000] io scheduler cfq registered (default)
[    0.300000] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.300000] 12c00000.serial: ttySAC0 at MMIO 0x12c00000 (irq = 83, base_baud = 0) is a S3C6400/10
[    0.300000] 12c10000.serial: ttySAC1 at MMIO 0x12c10000 (irq = 84, base_baud = 0) is a S3C6400/10
[    0.300000] 12c20000.serial: ttySAC2 at MMIO 0x12c20000 (irq = 85, base_baud = 0) is a S3C6400/10
[   11.275000] console [ttySAC2] enabled
[   11.280000] 12c30000.serial: ttySAC3 at MMIO 0x12c30000 (irq = 86, base_baud = 0) is a S3C6400/10
[   11.295000] brd: module loaded
[   11.300000] loop: module loaded
[   11.305000] usbcore: registered new interface driver asix
[   11.310000] usbcore: registered new interface driver ax88179_178a
[   11.315000] usbcore: registered new interface driver cdc_ether
[   11.320000] usbcore: registered new interface driver r815x
[   11.325000] usbcore: registered new interface driver smsc75xx
[   11.330000] usbcore: registered new interface driver smsc95xx
[   11.335000] usbcore: registered new interface driver net1080
[   11.345000] usbcore: registered new interface driver cdc_subset
[   11.350000] usbcore: registered new interface driver zaurus
[   11.355000] usbcore: registered new interface driver cdc_ncm
[   11.360000] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   11.365000] ehci-s5p: EHCI s5p driver
[   11.370000] usbcore: registered new interface driver usb-storage
[   11.375000] mousedev: PS/2 mouse device common for all mice
[   11.385000] device-mapper: ioctl: 4.26.0-ioctl (2013-08-15) initialised: dm-devel@redhat.com
[   11.390000] sdhci: Secure Digital Host Controller Interface driver
[   11.395000] sdhci: Copyright(c) Pierre Ossman
[   11.400000] Synopsys Designware Multimedia Card Interface Driver
[   11.405000] dwmmc_exynos dwmmc0.0: invalid resource
[   11.410000] dwmmc_exynos: probe of dwmmc0.0 failed with error -22
[   11.415000] dwmmc_exynos dwmmc1.1: invalid resource
[   11.420000] dwmmc_exynos: probe of dwmmc1.1 failed with error -22
[   11.430000] dwmmc_exynos dwmmc2.2: invalid resource
[   11.435000] dwmmc_exynos: probe of dwmmc2.2 failed with error -22
[   11.440000] dwmmc_exynos 12200000.mmc: no vmmc regulator found: -19
[   11.445000] dwmmc_exynos 12200000.mmc: Using internal DMA controller.
[   11.450000] dwmmc_exynos 12200000.mmc: Version ID is 241a
[   11.455000] dwmmc_exynos 12200000.mmc: DW MMC controller at irq 107, 64 bit host data width, 128 deep fifo
[   11.480000] mmc_host mmc0: Bus speed (slot 0) = 100000000Hz (slot req 400000Hz, actual 400000HZ div = 125)
[   11.500000] dwmmc_exynos 12200000.mmc: 1 slots initialized
[   11.500000] dwmmc_exynos 12220000.mmc: no vmmc regulator found: -19
[   11.510000] dwmmc_exynos 12220000.mmc: Using internal DMA controller.
[   11.515000] dwmmc_exynos 12220000.mmc: Version ID is 241a
[   11.520000] dwmmc_exynos 12220000.mmc: DW MMC controller at irq 109, 64 bit host data width, 128 deep fifo
[   11.545000] mmc_host mmc0: Bus speed (slot 0) = 100000000Hz (slot req 300000Hz, actual 299401HZ div = 167)
[   11.550000] mmc_host mmc1: Bus speed (slot 0) = 100000000Hz (slot req 400000Hz, actual 400000HZ div = 125)
[   11.575000] dwmmc_exynos 12220000.mmc: 1 slots initialized
[   11.580000] usbcore: registered new interface driver usbhid
[   11.585000] mmc_host mmc0: Bus speed (slot 0) = 100000000Hz (slot req 200000Hz, actual 200000HZ div = 250)
[   11.590000] usbhid: USB HID core driver
[   11.595000] TCP: cubic registered
[   11.600000] NET: Registered protocol family 17
[   11.605000] NET: Registered protocol family 15
[   11.610000] Registering SWP/SWPB emulation handler
[   11.615000] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   11.620000] Freeing unused kernel memory: 216K (c049b000 - c04d1000)
[   11.625000] mmc_host mmc0: Bus speed (slot 0) = 100000000Hz (slot req 196079Hz, actual 196078HZ div = 255)
[   11.635000] Unhandled fault: imprecise external abort (0x1406) at 0x00000000
Bus error
+++ root: /dev/mmcblk0p5, init: , dev: mmcblk0p5 +++
+++ waiting for mmcblk0p5 to appear +++
[   11.680000] mmc_host mmc1: Bus speed (slot 0) = 100000000Hz (slot req 50000000Hz, actual 50000000HZ div = 1)
[   11.690000] mmc1: new high speed SDHC card at address b368
[   11.695000] mmcblk0: mmc1:b368 USD   14.9 GiB 
[   11.705000]  mmcblk0: p1 p2 p3 < p5 p6 p7 >
[   11.720000] mmc_host mmc0: Bus speed (slot 0) = 100000000Hz (slot req 400000Hz, actual 400000HZ div = 125)
[   11.760000] mmc_host mmc0: Bus speed (slot 0) = 100000000Hz (slot req 300000Hz, actual 299401HZ div = 167)
[   11.800000] mmc_host mmc0: Bus speed (slot 0) = 100000000Hz (slot req 200000Hz, actual 200000HZ div = 250)
[   11.845000] mmc_host mmc0: Bus speed (slot 0) = 100000000Hz (slot req 196079Hz, actual 196078HZ div = 255)
 179        5    2560000 mmcblk[   12.660000] EXT3-fs (mmcblk0p5): error: couldn't mount because of unsupported optio
nal features (240)
[   12.670000] EXT2-fs (mmcblk0p5): error: couldn't mount because of unsupported optional features (244)
0p5
+++ newroot is at /dev/mmcblk0p5 +++
[   12.690000] EXT4-fs (mmcblk0p5): recovery complete
[   12.695000] EXT4-fs (mmcblk0p5): mounted filesystem with ordered data mode. Opts: (null)
+++ validate /newroot/ +++


+++ init not found, entering shell +++


mount: mounting debugfs on /sys/kernel/debug failed: No such file or directory
sh: can't access tty; job control turned off
/ # 
/ # uname -a
Linux (none) 3.12.0-rc5-00004-g1cb405f #1 SMP PREEMPT Thu Oct 17 15:05:58 EEST 2013 armv7l GNU/Linux
/ # 


--0OAP2g/MAC+5xKAE--
