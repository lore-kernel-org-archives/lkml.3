Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaLXIgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 03:36:36 -0500
Received: from mail-bn1bbn0101.outbound.protection.outlook.com ([157.56.111.101]:28715
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751921AbaLXIgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 03:36:33 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>, <a.hajda@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v5 10/21] drm/dsi: Add a helper to get bits per pixel of MIPI DSI pixel format
Date: Wed, 24 Dec 2014 16:39:32 +0800
Message-ID: <1419410383-6359-11-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419410383-6359-1-git-send-email-Ying.Liu@freescale.com>
References: <1419410383-6359-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(77096005)(87936001)(76176999)(50986999)(92566001)(2950100001)(47776003)(20776003)(64706001)(77156002)(68736005)(97736003)(31966008)(50226001)(36756003)(4396001)(62966003)(48376002)(19580405001)(19580395003)(104016003)(46102003)(84676001)(110136001)(85426001)(105606002)(99396003)(21056001)(86362001)(6806004)(575784001)(89996001)(50466002)(107046002)(106466001)(2351001)(229853001)(120916001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0629;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0629;
X-Forefront-PRVS: 04359FAD81
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2014 08:36:27.6735
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0629
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v4->v5:
 * None.

v3->v4:
 * None.

v2->v3:
 * None.

v1->v2:
 * Thierry Reding suggested that the mipi_dsi_pixel_format_to_bpp() function
   could be placed at the common DRM MIPI DSI driver.
   This patch is newly added.

 include/drm/drm_mipi_dsi.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/drm/drm_mipi_dsi.h b/include/drm/drm_mipi_dsi.h
index f1d8d0d..0f5210c 100644
--- a/include/drm/drm_mipi_dsi.h
+++ b/include/drm/drm_mipi_dsi.h
@@ -163,6 +163,20 @@ static inline struct mipi_dsi_device *to_mipi_dsi_device(struct device *dev)
 	return container_of(dev, struct mipi_dsi_device, dev);
 }
 
+static inline int mipi_dsi_pixel_format_to_bpp(enum mipi_dsi_pixel_format format)
+{
+	switch (format) {
+	case MIPI_DSI_FMT_RGB888:
+	case MIPI_DSI_FMT_RGB666:
+		return 24;
+	case MIPI_DSI_FMT_RGB666_PACKED:
+		return 18;
+	case MIPI_DSI_FMT_RGB565:
+		return 16;
+	}
+	return -EINVAL;
+}
+
 struct mipi_dsi_device *of_find_mipi_dsi_device_by_node(struct device_node *np);
 int mipi_dsi_attach(struct mipi_dsi_device *dsi);
 int mipi_dsi_detach(struct mipi_dsi_device *dsi);
-- 
2.1.0

