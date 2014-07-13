Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaGMTME (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 15:12:04 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35261 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaGMTLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 15:11:55 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V2 1/4] staging: vt6556: Cleanup coding style issues
Date: Sun, 13 Jul 2014 21:11:18 +0200
Message-Id: <1405278681-3348-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleanup coding style issues reported by checkpatch.

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Cahnges from V1:
 - Sent all patches in a series

Made against latest staging-next.

 drivers/staging/vt6656/baseband.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index c1675d5..040b232 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -26,9 +26,10 @@
  * Date: Jun. 5, 2002
  *
  * Functions:
- *      vnt_get_frame_time        - Calculate data frame transmitting time
- *      vnt_get_phy_field   - Calculate PhyLength, PhyService and Phy Signal parameter for baseband Tx
- *      BBbVT3184Init          - VIA VT3184 baseband chip init code
+ *	vnt_get_frame_time	- Calculate data frame transmitting time
+ *	vnt_get_phy_field	- Calculate PhyLength, PhyService and Phy
+ *				  Signal parameter for baseband Tx
+ *	BBbVT3184Init		- VIA VT3184 baseband chip init code
  *
  * Revision History:
  *
@@ -86,7 +87,7 @@ static u8 vnt_vt3184_al2230[] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  /* 0xff */
 };
 
-//{{RobertYu:20060515, new BB setting for VT3226D0
+/* {{RobertYu:20060515, new BB setting for VT3226D0 */
 static u8 vnt_vt3184_vt3226d0[] = {
 	0x31, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00,
 	0x70, 0x45, 0x2a, 0x76, 0x00, 0x00, 0x80, 0x00, /* 0x0f */
@@ -122,8 +123,9 @@ static u8 vnt_vt3184_vt3226d0[] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  /* 0xff */
 };
 
-static const u16 awcFrameTime[MAX_RATE] =
-{10, 20, 55, 110, 24, 36, 48, 72, 96, 144, 192, 216};
+static const u16 awcFrameTime[MAX_RATE] = {
+	10, 20, 55, 110, 24, 36, 48, 72, 96, 144, 192, 216
+};
 
 /*
  * Description: Calculate data frame transmitting time
@@ -191,9 +193,9 @@ unsigned int vnt_get_frame_time(u8 preamble_type, u8 pkt_type,
  *      tx_rate           - Tx Rate
  *  Out:
  *	struct vnt_phy_field *phy
- * 			- pointer to Phy Length field
- *			- pointer to Phy Service field
- * 			- pointer to Phy Signal field
+ *		- pointer to Phy Length field
+ *		- pointer to Phy Service field
+ *		- pointer to Phy Signal field
  *
  * Return Value: none
  *
@@ -450,8 +452,9 @@ int BBbVT3184Init(struct vnt_private *priv)
 		priv->ldBmThreshold[2] = 0;
 		priv->ldBmThreshold[3] = 0;
 		/* Fix VT3226 DFC system timing issue */
-		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL2, SOFTPWRCTL_RFLEOPT);
-	} else if ((priv->byRFType == RF_VT3342A0)) {
+		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL2,
+				    SOFTPWRCTL_RFLEOPT);
+	} else if (priv->byRFType == RF_VT3342A0) {
 		priv->byBBRxConf = vnt_vt3184_vt3226d0[10];
 		length = sizeof(vnt_vt3184_vt3226d0);
 		addr = vnt_vt3184_vt3226d0;
@@ -467,7 +470,8 @@ int BBbVT3184Init(struct vnt_private *priv)
 		priv->ldBmThreshold[2] = 0;
 		priv->ldBmThreshold[3] = 0;
 		/* Fix VT3226 DFC system timing issue */
-		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL2, SOFTPWRCTL_RFLEOPT);
+		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL2,
+				    SOFTPWRCTL_RFLEOPT);
 	} else {
 		return true;
 	}
-- 
1.9.3

