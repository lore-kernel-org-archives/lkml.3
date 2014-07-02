Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaGBKSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:18:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54593 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119AbaGBKSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:18:21 -0400
X-Sasl-enc: u9W0CL2UAUJ7cTwKJqThFOCq6d3Fv+OYbyYEBBqUPLvJ 1404296299
From: Michalis Pappas <mpappas@fastmail.fm>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2] staging: gdm72xx: move T_CAPABILITY definitions to hci.h
Date: Wed,  2 Jul 2014 11:18:07 +0100
Message-Id: <1404296287-3970-1-git-send-email-mpappas@fastmail.fm>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1404219616-1788-3-git-send-email-mpappas@fastmail.fm>
References: <1404219616-1788-3-git-send-email-mpappas@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/gdm72xx/gdm_wimax.c | 11 ++++-------
 drivers/staging/gdm72xx/hci.h       |  6 ++++++
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 4148013..50b7bf0 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -609,10 +609,7 @@ static void gdm_wimax_prepare_device(struct net_device *dev)
 	u16 len = 0;
 	u32 val = 0;
 
-	#define BIT_MULTI_CS	0
-	#define BIT_WIMAX		1
-	#define BIT_QOS			2
-	#define BIT_AGGREGATION	3
+
 
 	/* GetInformation mac address */
 	len = 0;
@@ -621,12 +618,12 @@ static void gdm_wimax_prepare_device(struct net_device *dev)
 	hci->length = H2B(len);
 	gdm_wimax_send(nic, hci, HCI_HEADER_SIZE+len);
 
-	val = (1<<BIT_WIMAX) | (1<<BIT_MULTI_CS);
+	val = (1 << T_CAPABILITY_WIMAX) | (1 << T_CAPABILITY_MULTI_CS);
 	#if defined(CONFIG_WIMAX_GDM72XX_QOS)
-	val |= (1<<BIT_QOS);
+	val |= (1 << T_CAPABILITY_QOS);
 	#endif
 	#if defined(CONFIG_WIMAX_GDM72XX_WIMAX2)
-	val |= (1<<BIT_AGGREGATION);
+	val |= (1 << T_CAPABILITY_AGGREGATION);
 	#endif
 
 	/* Set capability */
diff --git a/drivers/staging/gdm72xx/hci.h b/drivers/staging/gdm72xx/hci.h
index 059ba00..4dd253d 100644
--- a/drivers/staging/gdm72xx/hci.h
+++ b/drivers/staging/gdm72xx/hci.h
@@ -198,6 +198,12 @@
 #define T_FFTSIZE			(0xda	| (4 << 16))
 #define T_DUPLEX_MODE			(0xdb	| (4 << 16))
 
+/* T_CAPABILITY */
+#define T_CAPABILITY_MULTI_CS		(1 << 0)
+#define T_CAPABILITY_WIMAX		(1 << 1)
+#define T_CAPABILITY_QOS		(1 << 2)
+#define T_CAPABILITY_AGGREGATION	(1 << 3)
+
 struct hci_s {
 	unsigned short cmd_evt;
 	unsigned short length;
-- 
1.8.4

