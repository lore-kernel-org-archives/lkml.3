Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbaGANAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:00:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59958 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756373AbaGANAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:00:23 -0400
X-Sasl-enc: HdPMp1eGD0/UAOQwC7iE7MqVRFrE5KWaYYTYcDS+8m+x 1404219623
From: Michalis Pappas <mpappas@fastmail.fm>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: gdm72xx: move T_CAPABILITY bit definitions to hci.h
Date: Tue,  1 Jul 2014 14:00:16 +0100
Message-Id: <1404219616-1788-3-git-send-email-mpappas@fastmail.fm>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1404219616-1788-1-git-send-email-mpappas@fastmail.fm>
References: <1404219616-1788-1-git-send-email-mpappas@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/gdm72xx/gdm_wimax.c | 10 +++-------
 drivers/staging/gdm72xx/hci.h       |  6 ++++++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 63a760b..1fc64a9 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -600,10 +600,6 @@ static void gdm_wimax_prepare_device(struct net_device *dev)
 	u16 len = 0;
 	u32 val = 0;
 
-	#define BIT_MULTI_CS	0
-	#define BIT_WIMAX		1
-	#define BIT_QOS			2
-	#define BIT_AGGREGATION	3
 
 	/* GetInformation mac address */
 	len = 0;
@@ -612,12 +608,12 @@ static void gdm_wimax_prepare_device(struct net_device *dev)
 	hci->length = H2B(len);
 	gdm_wimax_send(nic, hci, HCI_HEADER_SIZE+len);
 
-	val = (1<<BIT_WIMAX) | (1<<BIT_MULTI_CS);
+	val = (1 << T_CAPABILITY_BIT_WIMAX) | (1 << T_CAPABILITY_BIT_MULTI_CS);
 	#if defined(CONFIG_WIMAX_GDM72XX_QOS)
-	val |= (1<<BIT_QOS);
+	val |= (1 << T_CAPABILITY_BIT_QOS);
 	#endif
 	#if defined(CONFIG_WIMAX_GDM72XX_WIMAX2)
-	val |= (1<<BIT_AGGREGATION);
+	val |= (1 << T_CAPABILITY_BIT_AGGREGATION);
 	#endif
 
 	/* Set capability */
diff --git a/drivers/staging/gdm72xx/hci.h b/drivers/staging/gdm72xx/hci.h
index 059ba00..0cdd1fc 100644
--- a/drivers/staging/gdm72xx/hci.h
+++ b/drivers/staging/gdm72xx/hci.h
@@ -198,6 +198,12 @@
 #define T_FFTSIZE			(0xda	| (4 << 16))
 #define T_DUPLEX_MODE			(0xdb	| (4 << 16))
 
+/* T_CAPABILITY */
+#define T_CAPABILITY_BIT_MULTI_CS	0
+#define T_CAPABILITY_BIT_WIMAX		1
+#define T_CAPABILITY_BIT_QOS		2
+#define T_CAPABILITY_BIT_AGGREGATION	3
+
 struct hci_s {
 	unsigned short cmd_evt;
 	unsigned short length;
-- 
1.8.4

