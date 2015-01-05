Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbbAEHzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 02:55:38 -0500
Received: from mail-bn1on0114.outbound.protection.outlook.com ([157.56.110.114]:44608
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751087AbbAEHzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 02:55:36 -0500
X-WSS-ID: 0NHP20H-08-L4B-02
X-M-MSG: 
From: "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Olof Johansson" <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
CC: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Charles.Garcia-Tobin@arm.com" <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Timur Tabi <timur@codeaurora.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v6 14/17] ARM64 / ACPI: Parse GTDT to initialize arch
 timer
Thread-Topic: [PATCH v6 14/17] ARM64 / ACPI: Parse GTDT to initialize arch
 timer
Thread-Index: AQHQKA0xYxhebyGctk2vnXL1SlXTO5yxGRGA
Date: Mon, 5 Jan 2015 07:55:30 +0000
Message-ID: <D0CF9C94.CD69%suravee.suthikulpanit@amd.com>
In-Reply-To: <1420368918-5086-15-git-send-email-hanjun.guo@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.0.121105
x-originating-ip: [10.177.96.13]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <49B6EEC1D45AFD488824FE419745F1DC@amd.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(164054003)(479174004)(24454002)(189002)(199003)(69234005)(51704005)(2950100001)(36756003)(77156002)(62966003)(2900100001)(46102003)(99396003)(54356999)(50986999)(19580405001)(19580395003)(84676001)(64706001)(23726002)(102836002)(46406003)(47776003)(20776003)(120916001)(53416004)(50466002)(15975445007)(107046002)(83506001)(68736005)(101416001)(4396001)(97756001)(105586002)(31966008)(106466001)(2656002)(106116001)(92566001)(97736003)(575784001)(86362001)(87936001)(21056001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN1PR02MB197;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB197;
X-Forefront-PRVS: 0447DB1C71
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2015 07:55:32.5165
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB197
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/4/15, 04:55, "Hanjun Guo" <hanjun.guo@linaro.org> wrote:

>Using the information presented by GTDT to initialize the arch
>timer (not memory-mapped).
>
>Originally-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>Tested-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>---
> arch/arm64/kernel/time.c             |   7 ++
> drivers/clocksource/arm_arch_timer.c | 132
>++++++++++++++++++++++++++++-------
> include/linux/clocksource.h          |   6 ++
> 3 files changed, 118 insertions(+), 27 deletions(-)
>
>diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
>index 1a7125c..42f9195 100644
>--- a/arch/arm64/kernel/time.c
>+++ b/arch/arm64/kernel/time.c
>@@ -35,6 +35,7 @@
> #include <linux/delay.h>
> #include <linux/clocksource.h>
> #include <linux/clk-provider.h>
>+#include <linux/acpi.h>
> 
> #include <clocksource/arm_arch_timer.h>
> 
>@@ -72,6 +73,12 @@ void __init time_init(void)
> 
> 	tick_setup_hrtimer_broadcast();
> 
>+	/*
>+	 * Since ACPI or FDT will only one be available in the system,
>+	 * we can use acpi_generic_timer_init() here safely
>+	 */
>+	acpi_generic_timer_init();
>+
> 	arch_timer_rate = arch_timer_get_rate();
> 	if (!arch_timer_rate)
> 		panic("Unable to initialise architected timer.\n");
>diff --git a/drivers/clocksource/arm_arch_timer.c
>b/drivers/clocksource/arm_arch_timer.c
>index 6a79fc4..612f2a0 100644
>--- a/drivers/clocksource/arm_arch_timer.c
>+++ b/drivers/clocksource/arm_arch_timer.c
>@@ -21,6 +21,7 @@
> #include <linux/io.h>
> #include <linux/slab.h>
> #include <linux/sched_clock.h>
>+#include <linux/acpi.h>
> 
> #include <asm/arch_timer.h>
> #include <asm/virt.h>
>@@ -370,8 +371,12 @@ arch_timer_detect_rate(void __iomem *cntbase, struct
>device_node *np)
> 	if (arch_timer_rate)
> 		return;
> 
>-	/* Try to determine the frequency from the device tree or CNTFRQ */
>-	if (of_property_read_u32(np, "clock-frequency", &arch_timer_rate)) {
>+	/*
>+	 * Try to determine the frequency from the device tree or CNTFRQ,
>+	 * if ACPI is enabled, get the frequency from CNTFRQ ONLY.
>+	 */
>+	if (!acpi_disabled ||
>+	    of_property_read_u32(np, "clock-frequency", &arch_timer_rate)) {
> 		if (cntbase)
> 			arch_timer_rate = readl_relaxed(cntbase + CNTFRQ);
> 		else
>@@ -690,28 +695,8 @@ static void __init arch_timer_common_init(void)
> 	arch_timer_arch_init();
> }
> 
>-static void __init arch_timer_init(struct device_node *np)
>+static void __init arch_timer_init(void)
> {
>-	int i;
>-
>-	if (arch_timers_present & ARCH_CP15_TIMER) {
>-		pr_warn("arch_timer: multiple nodes in dt, skipping\n");
>-		return;
>-	}
>-
>-	arch_timers_present |= ARCH_CP15_TIMER;
>-	for (i = PHYS_SECURE_PPI; i < MAX_TIMER_PPI; i++)
>-		arch_timer_ppi[i] = irq_of_parse_and_map(np, i);
>-	arch_timer_detect_rate(NULL, np);
>-
>-	/*
>-	 * If we cannot rely on firmware initializing the timer registers then
>-	 * we should use the physical timers instead.
>-	 */
>-	if (IS_ENABLED(CONFIG_ARM) &&
>-	    of_property_read_bool(np, "arm,cpu-registers-not-fw-configured"))
>-			arch_timer_use_virtual = false;
>-
> 	/*
> 	 * If HYP mode is available, we know that the physical timer
> 	 * has been configured to be accessible from PL1. Use it, so
>@@ -730,13 +715,39 @@ static void __init arch_timer_init(struct
>device_node *np)
> 		}
> 	}
> 
>-	arch_timer_c3stop = !of_property_read_bool(np, "always-on");
>-
> 	arch_timer_register();
> 	arch_timer_common_init();
> }
>-CLOCKSOURCE_OF_DECLARE(armv7_arch_timer, "arm,armv7-timer",
>arch_timer_init);
>-CLOCKSOURCE_OF_DECLARE(armv8_arch_timer, "arm,armv8-timer",
>arch_timer_init);
>+
>+static void __init arch_timer_of_init(struct device_node *np)
>+{
>+	int i;
>+
>+	if (arch_timers_present & ARCH_CP15_TIMER) {
>+		pr_warn("arch_timer: multiple nodes in dt, skipping\n");
>+		return;
>+	}
>+
>+	arch_timers_present |= ARCH_CP15_TIMER;
>+	for (i = PHYS_SECURE_PPI; i < MAX_TIMER_PPI; i++)
>+		arch_timer_ppi[i] = irq_of_parse_and_map(np, i);
>+
>+	arch_timer_detect_rate(NULL, np);
>+
>+	arch_timer_c3stop = !of_property_read_bool(np, "always-on");
>+
>+	/*
>+	 * If we cannot rely on firmware initializing the timer registers then
>+	 * we should use the physical timers instead.
>+	 */
>+	if (IS_ENABLED(CONFIG_ARM) &&
>+	    of_property_read_bool(np, "arm,cpu-registers-not-fw-configured"))
>+			arch_timer_use_virtual = false;
>+
>+	arch_timer_init();
>+}
>+CLOCKSOURCE_OF_DECLARE(armv7_arch_timer, "arm,armv7-timer",
>arch_timer_of_init);
>+CLOCKSOURCE_OF_DECLARE(armv8_arch_timer, "arm,armv8-timer",
>arch_timer_of_init);

Hanjun,

FYI, it seems that the tree that you have rebased the patch series has an
issue determining clocksource in ARM64 introduced by this commit.

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=0
b46b8a718c6e90910a1b1b0fe797be3c167e186

Here is the fix from Catalin that already went upstream:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drive
rs/clocksource/arm_arch_timer.c?id=d6ad36913083d683aad4e02e53580c995f1a6ede

Thanks,

Suravee


