Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbaGNQAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:00:39 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:44025
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756163AbaGNQAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:00:32 -0400
X-WSS-ID: 0N8PLSM-08-UCM-02
X-M-MSG: 
Message-ID: <53C3FE7D.3090805@amd.com>
Date: Mon, 14 Jul 2014 10:59:57 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: <marc.zyngier@arm.com>, <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>, <tglx@linutronix.de>,
        <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 0/4 V3] irqchip: gic: Introduce ARM GICv2m MSI(-X) support
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20140713231431.GM13108@titan.lakedaemon.net>
In-Reply-To: <20140713231431.GM13108@titan.lakedaemon.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(164054003)(189002)(479174003)(377454003)(24454002)(57704003)(51704005)(36756003)(64706001)(4396001)(102836001)(33656002)(31966008)(110136001)(86362001)(50466002)(59896001)(84676001)(101416001)(54356999)(76482001)(64126003)(83072002)(85852003)(19580395003)(77982001)(87266999)(21056001)(85306003)(74502001)(92726001)(99396002)(97736001)(74662001)(65816999)(87936001)(76176999)(106466001)(105586002)(23756003)(81542001)(50986999)(46102001)(107046002)(80022001)(15975445006)(47776003)(20776003)(80316001)(95666004)(83322001)(79102001)(92566001)(19580405001)(65956001)(81342001)(83506001)(44976005)(68736004);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB044;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02723F29C4
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/13/2014 6:14 PM, Jason Cooper wrote:
> Suravee,
>
> On Wed, Jul 09, 2014 at 06:05:00PM -0500, suravee.suthikulpanit@amd.com wrote:
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>
>> This patch set introduces support for MSI(-X) in GICv2m specification,
>> which is implemented in some variation of GIC400.
>>
>> This depends on and has been tested with the V7 of"Add support for PCI in AArch64"
>> (https://lkml.org/lkml/2014/3/14/320).
>
> Grrr.  I mis-spoke against your v1 of this series.  There are more
> changes to irq-gic.c than I originally thought in this series.

I am not quite sure what your are referring to.

> Additionally, we have a lot of other significant changes to that driver
> as well this cycle.  It would be really helpful if I could take patches
> 1-3 through irqchip/gic.  I can Ack #4 with the Subject change, and the
> branch it lands in can depend on irqchip/gic, no problem there.

Patch 1-3 should be able to go through the irqchip/gic along with the 
gicv3 from Marc, which I have rebased this patch against.

Patch 4 is arch64 architectural changes.  Therefore, it might need to be 
going through a different branch. Marc/Mark/Will/Catalin, do you have 
any suggestions on which branch this should go to?

> My main concern is your statement above and your answer to my inquiry
> against v1.
>
> Right now, I'm only concerned about breaking the build.  Can I take 1-3?
> Or, do we need to wait until aarch64 PCI lands in mainline?

1 and 2 should be trivial since there is no change functionally.

3 mostly adding new files which should not get built if ARCH64 PCI is 
not supported based on the arch/arm64/Kconfig below.

+++ b/arch/arm64/Kconfig
@@ -9,6 +9,7 @@ config ARM64
  	select ARM_AMBA
  	select ARM_ARCH_TIMER
  	select ARM_GIC
+	select ARM_GIC_V2M if (PCI && PCI_MSI)
  	select ARM_GIC_V3
  	select BUILDTIME_EXTABLE_SORT
  	select CLONE_BACKWARDS

The only thing is the change related to MSI in the irq-gic.c which 
should not affect with the non-PCI system.

Thanks,

Suravee

