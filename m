Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbaFXAdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 20:33:43 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:50402
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753523AbaFXAdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 20:33:15 -0400
X-WSS-ID: 0N7NDJ7-08-AXV-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <marc.zyngier@arm.com>, <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 1/2] arm/gic: Add binding probe for GIC400
Date: Mon, 23 Jun 2014 19:32:59 -0500
Message-ID: <1403569980-12913-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403569980-12913-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1403569980-12913-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(97736001)(44976005)(87936001)(77982001)(76176999)(62966002)(102836001)(74662001)(99396002)(81542001)(105586002)(83322001)(85306003)(64706001)(31966008)(79102001)(50466002)(92566001)(93916002)(76482001)(74502001)(19580395003)(47776003)(46102001)(101416001)(85852003)(92726001)(88136002)(48376002)(86152002)(19580405001)(36756003)(95666004)(50226001)(81342001)(50986999)(4396001)(104166001)(20776003)(77156001)(77096002)(106466001)(83072002)(89996001)(84676001)(68736004)(87286001)(80022001)(2201001)(33646001)(21056001)(86362001)(53416004);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0201MB0921;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02524402D6
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Add new Irqchip declaration for GIC400. This was mentioned in
gic binding documentation, but there is not code to support it.

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 drivers/irqchip/irq-gic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 7e11c9d..adc86de 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -1071,6 +1071,8 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 	gic_cnt++;
 	return 0;
 }
+
+IRQCHIP_DECLARE(arm_gic_400, "arm,gic-400", gic_of_init);
 IRQCHIP_DECLARE(cortex_a15_gic, "arm,cortex-a15-gic", gic_of_init);
 IRQCHIP_DECLARE(cortex_a9_gic, "arm,cortex-a9-gic", gic_of_init);
 IRQCHIP_DECLARE(msm_8660_qgic, "qcom,msm-8660-qgic", gic_of_init);
-- 
1.9.0

