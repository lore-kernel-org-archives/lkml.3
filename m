Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbaGIXFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:05:20 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:48284
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756571AbaGIXFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:05:15 -0400
X-WSS-ID: 0N8GW4J-08-QYV-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <marc.zyngier@arm.com>, <mark.rutland@arm.com>, <jason@lakedaemon.net>
CC: <pawel.moll@arm.com>, <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>,
        <tglx@linutronix.de>, <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 1/4 V3] irqchip: gic: Add binding probe for ARM GIC400
Date: Wed, 9 Jul 2014 18:05:01 -0500
Message-ID: <1404947104-21345-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(428002)(199002)(189002)(83322001)(104166001)(20776003)(89996001)(62966002)(31966008)(87936001)(79102001)(87286001)(102836001)(81342001)(74662001)(50226001)(81542001)(92566001)(77156001)(88136002)(97736001)(33646001)(107046002)(36756003)(19580405001)(47776003)(21056001)(74502001)(44976005)(68736004)(106466001)(229853001)(19580395003)(85852003)(92726001)(86362001)(2201001)(64706001)(46102001)(77096002)(95666004)(93916002)(4396001)(86152002)(99396002)(101416001)(80022001)(53416004)(83072002)(77982001)(84676001)(76482001)(50986999)(105586002)(48376002)(50466002)(76176999)(85306003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB042;H:atltwp02.amd.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0267E514F9
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
index 508b815..ac8f7ea 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -1020,6 +1020,8 @@ gic_of_init(struct device_node *node, struct device_node *parent)
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

