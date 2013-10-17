Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab3JQOZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:25:05 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:62549 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab3JQOZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:25:01 -0400
Date: Thu, 17 Oct 2013 17:24:56 +0300
From: Aliaksei Katovich <aliaksei.katovich@gmail.com>
To: Tarek Dakhran <t.dakhran@samsung.com>
Cc: Kevin Hilman <khilman@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-samsung-soc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Naour Romain <romain.naour@openwide.fr>,
        linux-arm-kernel@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v2 0/4] Exynos 5410 Dual cluster support
Message-ID: <20131017142456.GH3061@cat.local>
References: <1381763305-7085-1-git-send-email-v.tyrtov@samsung.com>
 <87k3hc3lso.fsf@linaro.org>
 <20131017130435.GG3061@cat.local>
 <525FEB7A.6030609@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <525FEB7A.6030609@samsung.com>
X-Operating-System: GNU/Linux
X-Kernel: Linux 3.12.0-rc1+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Tarek;

<skip>

> > 	However there seem to be some issues with virq allocations, like this:
> >
> > <snippet>
> > Starting kernel ...
> >                     
> > [    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
> > [    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
> > [    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
> > [    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
> > [    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
> > [    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
> > )
> > [    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
> > [    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
> > [    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
> > [    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
> > [    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
> > [    0.000000] ---[ end trace 1b75b31a2719edcd ]---
> > [    0.000000] ------------[ cut here ]------------
> > [    0.000000] WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:278 irq_domain_associate+0x128/0x1a8()
> > [    0.000000] error: virq337 is not allocated
> > [    0.000000] Modules linked in:
> > [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-00004-g1cb405f #1
> > [    0.000000] [<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
> > [    0.000000] [<c00117d0>] (show_stack+0x10/0x14) from [<c0363488>] (dump_stack+0x6c/0xac)
> > [    0.000000] [<c0363488>] (dump_stack+0x6c/0xac) from [<c001e330>] (warn_slowpath_common+0x64/0x88)
> > [    0.000000] [<c001e330>] (warn_slowpath_common+0x64/0x88) from [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40)
> > [    0.000000] [<c001e3e8>] (warn_slowpath_fmt+0x30/0x40) from [<c005a1b4>] (irq_domain_associate+0x128/0x1a8)
> > [    0.000000] [<c005a1b4>] (irq_domain_associate+0x128/0x1a8) from [<c005a508>] (irq_domain_associate_many+0x30/0x3c
> > )
> > [    0.000000] [<c005a508>] (irq_domain_associate_many+0x30/0x3c) from [<c005a768>] (irq_domain_add_simple+0x78/0x90)
> > [    0.000000] [<c005a768>] (irq_domain_add_simple+0x78/0x90) from [<c04b044c>] (combiner_of_init+0xb4/0x198)
> > [    0.000000] [<c04b044c>] (combiner_of_init+0xb4/0x198) from [<c04b6938>] (of_irq_init+0x278/0x2a0)
> > [    0.000000] [<c04b6938>] (of_irq_init+0x278/0x2a0) from [<c049b8fc>] (start_kernel+0x18c/0x384)
> > [    0.000000] [<c049b8fc>] (start_kernel+0x18c/0x384) from [<40008074>] (0x40008074)
> > [    0.000000] ---[ end trace 1b75b31a2719edce ]---
> > [    0.000000] ------------[ cut here ]------------
> > </snippet>
> This will be fixed in 3.13.
> 
> Now you can just change  "irq_base = 160" to  "irq_base = 256"
> in "static int __init combiner_of_init(struct device_node *np, struct 
> device_node *parent)" function
> in "drivers/irqchip/exynos-combiner.c"

	Thanks, this works for me!

--
Aliaksei

> 
> Best regards,
>      Tarek Dakhran
> 
