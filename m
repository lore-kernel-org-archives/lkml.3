Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbaGITVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:21:53 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34778 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751766AbaGITVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:21:51 -0400
X-Sasl-enc: Kj9Lo/WYarFBJ8pMrh3Ww5dm1kmDW82cO0dPhQPEjMDZ 1404933705
From: Michalis Pappas <mpappas@fastmail.fm>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, benchan@chromium.org
Subject: [PATCH v4] staging: gdm72xx: move T_CAPABILITY definitions to hci.h
Date: Wed,  9 Jul 2014 20:21:21 +0100
Message-Id: <1404933681-2840-1-git-send-email-mpappas@fastmail.fm>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <20140709185739.GA26312@kroah.com>
References: <20140709185739.GA26312@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/gdm72xx/gdm_wimax.c | 11 +++--------
 drivers/staging/gdm72xx/hci.h       |  6 ++++++
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 0f71d41..1693cc0 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -591,11 +591,6 @@ static void gdm_wimax_prepare_device(struct net_device *dev)
 	u32 val = 0;
 	__be32 val_be32;
 
-	#define BIT_MULTI_CS	0
-	#define BIT_WIMAX		1
-	#define BIT_QOS			2
-	#define BIT_AGGREGATION	3
-
 	/* GetInformation mac address */
 	len = 0;
 	hci->cmd_evt = cpu_to_be16(WIMAX_GET_INFO);
@@ -603,12 +598,12 @@ static void gdm_wimax_prepare_device(struct net_device *dev)
 	hci->length = cpu_to_be16(len);
 	gdm_wimax_send(nic, hci, HCI_HEADER_SIZE+len);
 
-	val = (1<<BIT_WIMAX) | (1<<BIT_MULTI_CS);
+	val = T_CAPABILITY_WIMAX | T_CAPABILITY_MULTI_CS;
 	#if defined(CONFIG_WIMAX_GDM72XX_QOS)
-	val |= (1<<BIT_QOS);
+	val |= T_CAPABILITY_QOS;
 	#endif
 	#if defined(CONFIG_WIMAX_GDM72XX_WIMAX2)
-	val |= (1<<BIT_AGGREGATION);
+	val |= T_CAPABILITY_AGGREGATION;
 	#endif
 
 	/* Set capability */
diff --git a/drivers/staging/gdm72xx/hci.h b/drivers/staging/gdm72xx/hci.h
index dd2931d..10a6bfa 100644
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
 	__be16	cmd_evt;
 	__be16	length;
-- 
1.8.4

