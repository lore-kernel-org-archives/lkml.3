Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935244AbaGRN0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:26:53 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:28248
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935042AbaGRN0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:26:49 -0400
X-WSS-ID: 0N8WTCG-07-2XI-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <marc.zyngier@arm.com>, <mark.rutland@arm.com>, <jason@lakedaemon.net>
CC: <pawel.moll@arm.com>, <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>,
        <tglx@linutronix.de>, <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "Marc Zyngier" <Marc.Zyngier@arm.com>
Subject: [PATCH] irqchip: gicv2m: Clean up logic for detecting MSI support
Date: Fri, 18 Jul 2014 08:26:36 -0500
Message-ID: <1405689996-3601-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(46102001)(83322001)(19580405001)(86362001)(93916002)(19580395003)(77982001)(86152002)(97736001)(79102001)(4396001)(87936001)(87286001)(229853001)(107046002)(74502001)(74662001)(84676001)(101416001)(99396002)(31966008)(92726001)(92566001)(2201001)(102836001)(50986999)(104166001)(88136002)(53416004)(85852003)(21056001)(50226001)(83072002)(76482001)(62966002)(89996001)(50466002)(80022001)(64706001)(85306003)(77096002)(77156001)(105586002)(106466001)(44976005)(20776003)(47776003)(95666004)(48376002)(36756003)(33646002)(81342001)(81542001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB039;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02760F0D1C
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

It's not quite clear that msi-controller is already checked
by of_msi_chip_add. So, this patch add a note to clarify.

Also, clean up redundant logic and unnecessary pr_info.

Cc: Mark Rutland <Mark.Rutland@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>
Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---

Note: This patch is created against irqchip/gic branch.

 drivers/irqchip/irq-gic-v2m.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
index e54ca1d..94ed8d6 100644
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -235,15 +235,15 @@ gicv2m_of_init(struct device_node *node, struct device_node *parent)
 	gic->msi_chip.teardown_irq = gicv2m_teardown_msi_irq;
 	ret = of_pci_msi_chip_add(&gic->msi_chip);
 	if (ret) {
-		/* MSI is optional and not supported here */
-		pr_info("GICv2m: MSI is not supported.\n");
+		/*
+		* Note: msi-controller is checked in of_pci_msi_chip_add().
+		* MSI support is optional, and enabled only if msi-controller
+		* is specified. Hence, return 0.
+		*/
 		return 0;
 	}
 
-	ret = gicv2m_msi_init(node, &gic->v2m_data);
-	if (ret)
-		return ret;
-	return ret;
+	return gicv2m_msi_init(node, &gic->v2m_data);
 }
 
 IRQCHIP_DECLARE(arm_gic_400_v2m, "arm,gic-400-v2m", gicv2m_of_init);
-- 
1.9.0

