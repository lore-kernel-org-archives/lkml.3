Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaHURUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:20:36 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:18823
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753288AbaHURUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:20:32 -0400
Date: Thu, 21 Aug 2014 10:20:17 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 1/9] ARM: zynq: PM: Enable A9 internal clock gating
 feature
References: <1408567315-28479-1-git-send-email-soren.brinkmann@xilinx.com>
 <1408567315-28479-2-git-send-email-soren.brinkmann@xilinx.com>
 <26994133-6c3c-45c0-af09-3cb55ad35b13@BY2FFO11FD028.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <26994133-6c3c-45c0-af09-3cb55ad35b13@BY2FFO11FD028.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <7df25bc3-d1ea-405c-a880-b22b53225ec6@BN1BFFO11FD018.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(479174003)(377454003)(189002)(199003)(51704005)(24454002)(377424004)(85202003)(44976005)(87936001)(92566001)(85306004)(76176999)(575784001)(33646002)(95666004)(4396001)(104016003)(54356999)(92726001)(6806004)(23676002)(50986999)(85182001)(31966008)(107046002)(19580405001)(86362001)(47776003)(99396002)(102836001)(77982001)(80022001)(64706001)(79102001)(31696002)(53416004)(19580395003)(110136001)(85852003)(81542001)(83506001)(74316001)(20776003)(46102001)(106466001)(70736001)(1496007)(83322001)(83072002)(74662001)(77096002)(74502001)(21056001)(50466002)(76482001)(81342001)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB052;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0310C78181
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-21 at 02:19PM +0200, Michal Simek wrote:
> On 08/20/2014 10:41 PM, Soren Brinkmann wrote:
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> >  arch/arm/mach-zynq/common.c  |  6 ++++++
> >  arch/arm/mach-zynq/common.h  | 11 +++++++++++
> >  arch/arm/mach-zynq/platsmp.c |  9 +++++++++
> >  3 files changed, 26 insertions(+)
> > 
> > diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
> > index 31a6fa40ba37..3cb7c198615a 100644
> > --- a/arch/arm/mach-zynq/common.c
> > +++ b/arch/arm/mach-zynq/common.c
> > @@ -98,6 +98,11 @@ static int __init zynq_get_revision(void)
> >  	return revision;
> >  }
> >  
> > +static void __init zynq_init_late(void)
> > +{
> > +	zynq_core_pm_init();
> > +}
> > +
> >  /**
> >   * zynq_init_machine - System specific initialization, intended to be
> >   *		       called from board specific initialization.
> > @@ -204,6 +209,7 @@ DT_MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
> >  	.map_io		= zynq_map_io,
> >  	.init_irq	= zynq_irq_init,
> >  	.init_machine	= zynq_init_machine,
> > +	.init_late	= zynq_init_late,
> >  	.init_time	= zynq_timer_init,
> >  	.dt_compat	= zynq_dt_match,
> >  	.reserve	= zynq_memory_init,
> > diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
> > index f652f0a884a6..596ef0b5067c 100644
> > --- a/arch/arm/mach-zynq/common.h
> > +++ b/arch/arm/mach-zynq/common.h
> > @@ -40,4 +40,15 @@ extern void __iomem *zynq_scu_base;
> >  /* Hotplug */
> >  extern void zynq_platform_cpu_die(unsigned int cpu);
> >  
> > +static inline void zynq_core_pm_init(void)
> > +{
> > +	/* A9 clock gating */
> > +	asm volatile ("mrc  p15, 0, r12, c15, c0, 0\n"
> > +		      "orr  r12, r12, #1\n"
> > +		      "mcr  p15, 0, r12, c15, c0, 0\n"
> > +		      : /* no outputs */
> > +		      : /* no inputs */
> > +		      : "r12");
> > +}
> > +
> >  #endif
> > diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
> > index abc82ef085c1..616b99e07c60 100644
> > --- a/arch/arm/mach-zynq/platsmp.c
> > +++ b/arch/arm/mach-zynq/platsmp.c
> > @@ -112,6 +112,14 @@ static void __init zynq_smp_prepare_cpus(unsigned int max_cpus)
> >  	scu_enable(zynq_scu_base);
> >  }
> >  
> > +/*
> > + * This function is in the hotplug path. Don't move it into the init section!!
> > + */
> 
> Worth to use kernel-doc format here.

The secondary init function is kind of documented in
arch/arm/include/asm/smp.h as part of the smp_operations struct. Do you
want more documentation here?
	
	Sören

