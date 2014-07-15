Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbaGOVX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:23:57 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:60853 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbaGOVXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:23:53 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V5 3/4] staging: vt6556: Cleanup coding style: lines over 80 chars
Date: Tue, 15 Jul 2014 23:23:26 +0200
Message-Id: <1405459407-9311-3-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405459407-9311-1-git-send-email-peter.senna@gmail.com>
References: <1405459407-9311-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleanup the follwoing coding style issues:
 - line over 80 chars
 - spaces on the beginning of a line
 - put { and } on the correct places

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Changes from V4:
 - Splitted [PATCH V4 1/6] in 4 smaller patches

 drivers/staging/vt6656/baseband.c | 8 +++++---
 drivers/staging/vt6656/card.c     | 9 +++++----
 drivers/staging/vt6656/main_usb.c | 5 +++--
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 7adc8db..8678b41 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -123,8 +123,9 @@ static u8 vnt_vt3184_vt3226d0[] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  /* 0xff */
 };
 
-static const u16 awcFrameTime[MAX_RATE] =
-{10, 20, 55, 110, 24, 36, 48, 72, 96, 144, 192, 216};
+static const u16 awcFrameTime[MAX_RATE] = {
+	10, 20, 55, 110, 24, 36, 48, 72, 96, 144, 192, 216
+};
 
 /*
  * Description: Calculate data frame transmitting time
@@ -468,7 +469,8 @@ int BBbVT3184Init(struct vnt_private *priv)
 		priv->ldBmThreshold[2] = 0;
 		priv->ldBmThreshold[3] = 0;
 		/* Fix VT3226 DFC system timing issue */
-		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL2, SOFTPWRCTL_RFLEOPT);
+		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL2,
+				    SOFTPWRCTL_RFLEOPT);
 	} else {
 		return true;
 	}
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 6a6e614..37cd96b 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -58,8 +58,9 @@
 /* const u16 cwRXBCNTSFOff[MAX_RATE] =
    {17, 34, 96, 192, 34, 23, 17, 11, 8, 5, 4, 3}; */
 
-static const u16 cwRXBCNTSFOff[MAX_RATE] =
-{192, 96, 34, 17, 34, 23, 17, 11, 8, 5, 4, 3};
+static const u16 cwRXBCNTSFOff[MAX_RATE] = {
+	192, 96, 34, 17, 34, 23, 17, 11, 8, 5, 4, 3
+};
 
 /*
  * Description: Set NIC media channel
@@ -477,7 +478,7 @@ void vnt_update_top_rates(struct vnt_private *priv)
 	}
 
 	priv->byTopCCKBasicRate = top_cck;
- }
+}
 
 int vnt_ofdm_min_rate(struct vnt_private *priv)
 {
@@ -710,7 +711,7 @@ void vnt_update_next_tbtt(struct vnt_private *priv, u64 tsf,
 	data[7] = (u8)(tsf >> 56);
 
 	vnt_control_out(priv, MESSAGE_TYPE_SET_TSFTBTT,
-		MESSAGE_REQUEST_TBTT, 0, 8, data);
+			MESSAGE_REQUEST_TBTT, 0, 8, data);
 
 	dev_dbg(&priv->usb->dev, "%s TBTT: %8llx\n", __func__, tsf);
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 95a87ef..d103df1 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -526,8 +526,9 @@ static void device_free_rx_bufs(struct vnt_private *priv)
 
 static void usb_device_reset(struct vnt_private *pDevice)
 {
- int status;
- status = usb_reset_device(pDevice->usb);
+	int status;
+
+	status = usb_reset_device(pDevice->usb);
 	if (status)
             printk("usb_device_reset fail status=%d\n",status);
 	return ;
-- 
1.9.3

