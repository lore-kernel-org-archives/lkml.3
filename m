Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaIJJVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 05:21:38 -0400
Received: from mail-by2on0102.outbound.protection.outlook.com ([207.46.100.102]:9344
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751220AbaIJJVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 05:21:36 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <tglx@linutronix.de>, <daniel.lezcano@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] clocksource: Add BE/LE APIs support for clocksource counter reading.
Date: Wed, 10 Sep 2014 17:20:19 +0800
Message-ID: <1410340819-35110-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(6009001)(189002)(199003)(50466002)(36756003)(26826002)(81542001)(83072002)(62966002)(99396002)(88136002)(21056001)(74662001)(86362001)(81156004)(87936001)(106466001)(90102001)(47776003)(81342001)(4396001)(97736003)(80022001)(79102001)(105606002)(104166001)(46102001)(77982001)(85852003)(229853001)(19580405001)(68736004)(74502001)(92726001)(44976005)(50226001)(84676001)(77156001)(93916002)(95666004)(85306004)(89996001)(69596002)(20776003)(31966008)(87286001)(107046002)(64706001)(92566001)(76482001)(50986999)(102836001)(19580395003)(83322001)(6806004)(48376002)(104016003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0611;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033054F29A
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/clocksource/mmio.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/clocksource/mmio.c b/drivers/clocksource/mmio.c
index 1593ade..ddc5214 100644
--- a/drivers/clocksource/mmio.c
+++ b/drivers/clocksource/mmio.c
@@ -20,21 +20,65 @@ static inline struct clocksource_mmio *to_mmio_clksrc(struct clocksource *c)
 	return container_of(c, struct clocksource_mmio, clksrc);
 }
 
+cycle_t clocksource_mmio_readl_up_be(struct clocksource *c)
+{
+	return (cycle_t)be32_to_cpu(readl_relaxed(to_mmio_clksrc(c)->reg));
+}
+
+cycle_t clocksource_mmio_readl_up_le(struct clocksource *c)
+{
+	return (cycle_t)le32_to_cpu(readl_relaxed(to_mmio_clksrc(c)->reg));
+}
+
 cycle_t clocksource_mmio_readl_up(struct clocksource *c)
 {
 	return (cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
 }
 
+cycle_t clocksource_mmio_readl_down_be(struct clocksource *c)
+{
+	return ~(cycle_t)be32_to_cpu(readl_relaxed(to_mmio_clksrc(c)->reg))
+		& c->mask;
+}
+
+cycle_t clocksource_mmio_readl_down_le(struct clocksource *c)
+{
+	return ~(cycle_t)le32_to_cpu(readl_relaxed(to_mmio_clksrc(c)->reg))
+		& c->mask;
+}
+
 cycle_t clocksource_mmio_readl_down(struct clocksource *c)
 {
 	return ~(cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg) & c->mask;
 }
 
+cycle_t clocksource_mmio_readw_up_be(struct clocksource *c)
+{
+	return (cycle_t)be16_to_cpu(readw_relaxed(to_mmio_clksrc(c)->reg));
+}
+
+cycle_t clocksource_mmio_readw_up_le(struct clocksource *c)
+{
+	return (cycle_t)le16_to_cpu(readw_relaxed(to_mmio_clksrc(c)->reg));
+}
+
 cycle_t clocksource_mmio_readw_up(struct clocksource *c)
 {
 	return (cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg);
 }
 
+cycle_t clocksource_mmio_readw_down_be(struct clocksource *c)
+{
+	return ~(cycle_t)be16_to_cpu(readw_relaxed(to_mmio_clksrc(c)->reg))
+		& c->mask;
+}
+
+cycle_t clocksource_mmio_readw_down_le(struct clocksource *c)
+{
+	return ~(cycle_t)le16_to_cpu(readw_relaxed(to_mmio_clksrc(c)->reg))
+		& c->mask;
+}
+
 cycle_t clocksource_mmio_readw_down(struct clocksource *c)
 {
 	return ~(cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg) & c->mask;
-- 
2.1.0.27.g96db324

