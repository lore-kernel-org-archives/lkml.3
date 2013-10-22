Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3JVHnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 03:43:25 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:24545
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753508Ab3JVHnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 03:43:24 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Peter Chen <peter.chen@freescale.com>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <b29396@freescale.com>, <shawn.guo@linaro.org>, <peter.chen@freescale.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 1/1] mfd: syscon: return -ENXIO if CONFIG_MFD_SYSCON is not enabled
Date: Tue, 22 Oct 2013 15:27:37 +0800
Message-ID: <1382426857-31975-1-git-send-email-peter.chen@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms may not define CONFIG_MFD_SYSCON (or haven't syscon),
it can fix build error for those platforms.

Signed-off-by: Peter Chen <peter.chen@freescale.com>
---
 include/linux/mfd/syscon.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
index b473577..60bf0fb 100644
--- a/include/linux/mfd/syscon.h
+++ b/include/linux/mfd/syscon.h
@@ -17,10 +17,34 @@
 
 struct device_node;
 
+#if IS_ENABLED(CONFIG_MFD_SYSCON)
 extern struct regmap *syscon_node_to_regmap(struct device_node *np);
 extern struct regmap *syscon_regmap_lookup_by_compatible(const char *s);
 extern struct regmap *syscon_regmap_lookup_by_pdevname(const char *s);
 extern struct regmap *syscon_regmap_lookup_by_phandle(
 					struct device_node *np,
 					const char *property);
+#else
+static inline struct regmap *syscon_node_to_regmap(struct device_node *np)
+{
+	return ERR_PTR(-ENXIO);
+}
+
+static inline struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
+{
+	return ERR_PTR(-ENXIO);
+}
+
+static inline struct regmap *syscon_regmap_lookup_by_pdevname(const char *s)
+{
+	return ERR_PTR(-ENXIO);
+}
+static inline struct regmap *syscon_regmap_lookup_by_phandle(
+					struct device_node *np,
+					const char *property)
+{
+	return ERR_PTR(-ENXIO);
+}
+#endif
+
 #endif /* __LINUX_MFD_SYSCON_H__ */
-- 
1.7.1


