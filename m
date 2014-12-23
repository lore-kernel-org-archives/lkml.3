Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbaLWDnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 22:43:23 -0500
Received: from mail-bn1bon0131.outbound.protection.outlook.com ([157.56.111.131]:40224
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754711AbaLWDnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 22:43:20 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v3 10/18] drm/dsi: Add a helper to get bits per pixel of MIPI DSI pixel format
Date: Tue, 23 Dec 2014 11:46:31 +0800
Message-ID: <1419306399-9387-11-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419306399-9387-1-git-send-email-Ying.Liu@freescale.com>
References: <1419306399-9387-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(339900001)(189002)(199003)(85426001)(47776003)(20776003)(19580405001)(6806004)(19580395003)(64706001)(105606002)(50466002)(48376002)(86362001)(92566001)(89996001)(575784001)(87936001)(110136001)(4396001)(50226001)(99396003)(229853001)(2351001)(107046002)(77096005)(68736005)(36756003)(50986999)(31966008)(97736003)(62966003)(76176999)(106466001)(84676001)(120916001)(77156002)(21056001)(46102003)(104016003)(2950100001)(217873001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0636;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0636;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB0636;
X-Forefront-PRVS: 04347F8039
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0636;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2014 03:43:16.4736
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB0636
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
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

