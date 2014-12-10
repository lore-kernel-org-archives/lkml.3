Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbaLJIuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:50:54 -0500
Received: from mail-bl2on0142.outbound.protection.outlook.com ([65.55.169.142]:60828
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752441AbaLJItk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:49:40 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <p.zabel@pengutronix.de>,
        <thierry.reding@gmail.com>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <mturquette@linaro.org>, <airlied@linux.ie>
Subject: [PATCH RFC 13/15] ARM: imx_v6_v7_defconfig: Cleanup for imx drm being moved out of staging
Date: Wed, 10 Dec 2014 16:37:26 +0800
Message-ID: <1418200648-32656-14-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
References: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(64706001)(47776003)(20776003)(48376002)(46102003)(110136001)(84676001)(21056001)(77096005)(6806004)(68736005)(104016003)(4396001)(50226001)(89996001)(87936001)(2351001)(107046002)(229853001)(120916001)(97736003)(105606002)(106466001)(31966008)(76176999)(50986999)(77156002)(62966003)(99396003)(19580395003)(19580405001)(92566001)(50466002)(575784001)(86362001)(36756003)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0625;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0625;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:BN1PR0301MB0625;
X-Forefront-PRVS: 0421BF7135
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0625;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new imx_v6_v7_defconfig is generated in this way:
* make ARCH=arm imx_v6_v7_defconfig
* make ARCH=arm savedefconfig
* cp defconfig arch/arm/configs/imx_v6_v7_defconfig

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 arch/arm/configs/imx_v6_v7_defconfig | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index 6790f1b..0dbd0c3 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -192,7 +192,13 @@ CONFIG_SOC_CAMERA_OV2640=y
 CONFIG_IMX_IPUV3_CORE=y
 CONFIG_DRM=y
 CONFIG_DRM_PANEL_SIMPLE=y
-CONFIG_BACKLIGHT_LCD_SUPPORT=y
+CONFIG_DRM_IMX=y
+CONFIG_DRM_IMX_FB_HELPER=y
+CONFIG_DRM_IMX_PARALLEL_DISPLAY=y
+CONFIG_DRM_IMX_TVE=y
+CONFIG_DRM_IMX_LDB=y
+CONFIG_DRM_IMX_IPUV3=y
+CONFIG_DRM_IMX_HDMI=y
 CONFIG_LCD_CLASS_DEVICE=y
 CONFIG_LCD_L4F00242T03=y
 CONFIG_LCD_PLATFORM=y
@@ -249,13 +255,6 @@ CONFIG_IMX_SDMA=y
 CONFIG_MXS_DMA=y
 CONFIG_FSL_EDMA=y
 CONFIG_STAGING=y
-CONFIG_DRM_IMX=y
-CONFIG_DRM_IMX_FB_HELPER=y
-CONFIG_DRM_IMX_PARALLEL_DISPLAY=y
-CONFIG_DRM_IMX_TVE=y
-CONFIG_DRM_IMX_LDB=y
-CONFIG_DRM_IMX_IPUV3=y
-CONFIG_DRM_IMX_HDMI=y
 # CONFIG_IOMMU_SUPPORT is not set
 CONFIG_PWM=y
 CONFIG_PWM_IMX=y
-- 
2.1.0

