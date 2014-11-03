Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbaKCT6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:58:05 -0500
Received: from mail-bn1on0133.outbound.protection.outlook.com ([157.56.110.133]:3234
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753642AbaKCT5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:57:54 -0500
X-WSS-ID: 0NEHBGA-07-PHN-02
X-M-MSG: 
Message-ID: <5457DE30.3010200@amd.com>
Date: Mon, 3 Nov 2014 13:57:36 -0600
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Catalin Marinas" <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        "Harish.Kasiviswanathan@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [V9 PATCH 2/2] irqchip: gicv2m: Add supports for ARM GICv2m MSI(-X)
References: <1414743990-28421-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1414743990-28421-3-git-send-email-suravee.suthikulpanit@amd.com>
 <54574FF7.706@arm.com>
In-Reply-To: <54574FF7.706@arm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(479174003)(377454003)(189002)(24454002)(199003)(51704005)(44976005)(84676001)(65956001)(87266999)(21056001)(54356999)(36756003)(20776003)(65806001)(64706001)(50986999)(92566001)(92726001)(31966008)(99396003)(87936001)(65816999)(47776003)(76176999)(86362001)(95666004)(105586002)(23746002)(106466001)(97736003)(4396001)(110136001)(33656002)(101416001)(80316001)(68736004)(64126003)(120916001)(50466002)(46102003)(83506001)(102836001)(107046002)(77156002)(62966003);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0384275935
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/3/2014 3:50 AM, Marc Zyngier wrote:
>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>> >index a99c211..4069eb3 100644
>> >--- a/drivers/irqchip/irq-gic.c
>> >+++ b/drivers/irqchip/irq-gic.c
>> >@@ -46,6 +46,7 @@
>> >  #include <asm/smp_plat.h>
>> >
>> >  #include "irq-gic-common.h"
>> >+#include "irq-gic-v2m.h"
>> >  #include "irqchip.h"
>> >
>> >  union gic_base {
>> >@@ -68,6 +69,9 @@ struct gic_chip_data {
>> >  #ifdef CONFIG_GIC_NON_BANKED
>> >         void __iomem *(*get_base)(union gic_base *);
>> >  #endif
>> >+#ifdef CONFIG_ARM_GIC_V2M
>> >+       struct list_head v2m_list;
>> >+#endif
> Can't that be something private to the v2m widget driver? I don't think
> it brings anything to the main GIC driver.
>

Looking at this again, now that we use the hierarchy irqdomain, GIC no 
longer needs to be handling with children v2m. I'll remove this altogether.

Suravee

