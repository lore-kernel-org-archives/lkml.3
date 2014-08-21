Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbaHUXih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 19:38:37 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:46080
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753344AbaHUXif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 19:38:35 -0400
Date: Thu, 21 Aug 2014 16:38:26 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 8/9] ARM: zynq: Remove hotplug.c
References: <1408567315-28479-1-git-send-email-soren.brinkmann@xilinx.com>
 <1408567315-28479-9-git-send-email-soren.brinkmann@xilinx.com>
 <53F54C26.5010000@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F54C26.5010000@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <347fcf72-b3a5-4212-87b9-0cc92d1a962c@BN1AFFO11FD035.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(479174003)(377454003)(199003)(24454002)(377424004)(189002)(51704005)(51444003)(164054003)(70736001)(83322001)(44976005)(106466001)(76482001)(53416004)(19580405001)(107046002)(47776003)(81542001)(77096002)(79102001)(81342001)(50466002)(80022001)(74316001)(19580395003)(46102001)(90102001)(74662001)(23676002)(92566001)(76176999)(54356999)(85306004)(74502001)(31966008)(33646002)(64706001)(110136001)(85202003)(85182001)(86362001)(85852003)(87936001)(21056001)(77982001)(50986999)(102836001)(1496007)(83506001)(95666004)(4396001)(6806004)(99396002)(31696002)(83072002)(104016003)(92726001)(20776003)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB024;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0310C78181
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-21 at 03:32AM +0200, Daniel Lezcano wrote:
> On 08/20/2014 10:41 PM, Soren Brinkmann wrote:
> >The hotplug code contains only a single function, which is an SMP
> >function. Move that to platsmp.c where all other SMP runctions reside.
> >That allows removing hotplug.c and declaring the cpu_die function
> >static.
> >
> >Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> >---
> >  arch/arm/mach-zynq/Makefile  |  1 -
> >  arch/arm/mach-zynq/common.h  |  3 +--
> >  arch/arm/mach-zynq/hotplug.c | 17 -----------------
> >  arch/arm/mach-zynq/platsmp.c | 18 ++++++++++++++++++
> >  4 files changed, 19 insertions(+), 20 deletions(-)
> >
> >diff --git a/arch/arm/mach-zynq/Makefile b/arch/arm/mach-zynq/Makefile
> >index 820dff6e1eba..c85fb3f7d5cd 100644
> >--- a/arch/arm/mach-zynq/Makefile
> >+++ b/arch/arm/mach-zynq/Makefile
> >@@ -6,5 +6,4 @@
> >  obj-y				:= common.o slcr.o pm.o
> >  CFLAGS_REMOVE_hotplug.o		=-march=armv6k
> >  CFLAGS_hotplug.o 		=-Wa,-march=armv7-a -mcpu=cortex-a9
> >-obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
> >  obj-$(CONFIG_SMP)		+= headsmp.o platsmp.o
> >diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
> >index c0773e87e83c..e6bb12c50a23 100644
> >--- a/arch/arm/mach-zynq/common.h
> >+++ b/arch/arm/mach-zynq/common.h
> >@@ -39,8 +39,7 @@ extern struct smp_operations zynq_smp_ops __initdata;
> >
> >  extern void __iomem *zynq_scu_base;
> >
> >-/* Hotplug */
> >-extern void zynq_platform_cpu_die(unsigned int cpu);
> >+int zynq_pm_late_init(void);
> >
> >  int zynq_pm_late_init(void);
> >
> >diff --git a/arch/arm/mach-zynq/hotplug.c b/arch/arm/mach-zynq/hotplug.c
> >index fe44a05677e2..b685c89f11e4 100644
> >--- a/arch/arm/mach-zynq/hotplug.c
> >+++ b/arch/arm/mach-zynq/hotplug.c
> >@@ -12,20 +12,3 @@
> >   */
> >  #include <asm/proc-fns.h>
> >
> >-/*
> >- * platform-specific code to shutdown a CPU
> >- *
> >- * Called with IRQs disabled
> >- */
> >-void zynq_platform_cpu_die(unsigned int cpu)
> >-{
> >-	zynq_slcr_cpu_state_write(cpu, true);
> >-
> >-	/*
> >-	 * there is no power-control hardware on this platform, so all
> >-	 * we can do is put the core into WFI; this is safe as the calling
> >-	 * code will have already disabled interrupts
> >-	 */
> >-	for (;;)
> >-		cpu_do_idle();
> >-}
> >diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
> >index f77f7ca4c45b..04e578718aa2 100644
> >--- a/arch/arm/mach-zynq/platsmp.c
> >+++ b/arch/arm/mach-zynq/platsmp.c
> >@@ -132,6 +132,24 @@ static int zynq_cpu_kill(unsigned cpu)
> >  	zynq_slcr_cpu_stop(cpu);
> >  	return 1;
> >  }
> >+
> >+/*
> >+ * platform-specific code to shutdown a CPU
> >+ *
> >+ * Called with IRQs disabled
> >+ */
> >+static void zynq_platform_cpu_die(unsigned int cpu)
> >+{
> >+	zynq_slcr_cpu_state_write(cpu, true);
> >+
> >+	/*
> >+	 * there is no power-control hardware on this platform, so all
> >+	 * we can do is put the core into WFI; this is safe as the calling
> >+	 * code will have already disabled interrupts
> >+	 */
> >+	for (;;)
> >+		cpu_do_idle();
> 
> IIUC, the cpu_do_idle() will flush the L1 cache and then call the
> WFI. It makes sense if we are about to power down the core. So I am
> wondering if we can just call wfi() instead.

I'm not sure - it's not that trivial to trace that through the sources.
But I think cpu_do_idle ends up in cpu_v7_do_idle which is just:
	ENTRY(cpu_v7_do_idle)                                                            
	        dsb                                     @ WFI may enter a low-power mode 
	        wfi                                                                      
	        ret     lr                                                               
	ENDPROC(cpu_v7_do_idle)

I think that is what we want here.

	Thanks,
	Sören

