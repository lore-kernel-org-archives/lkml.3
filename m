Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbaGVUJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:09:43 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:56996 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810AbaGVUJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:09:02 -0400
X-Originating-IP: 78.210.48.61
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 5/5] staging: vt6655: Fix unused function warning
Date: Tue, 22 Jul 2014 22:08:30 +0200
Message-Id: <1406059710-30903-6-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406059710-30903-1-git-send-email-gclement@baobob.org>
References: <1406059710-30903-1-git-send-email-gclement@baobob.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse reports that MimeThread is not used. Actually, it can be used
if THREAD is defined. By enclosing the MimeThread function into the
same #ifdef as the caller of MimeThread, this fixes the sparse
warnings.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/device_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 5576c30..fe9e13c 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -98,7 +98,9 @@ MODULE_AUTHOR("VIA Networking Technologies, Inc., <lyndonchen@vntek.com.tw>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("VIA Networking Solomon-A/B/G Wireless LAN Adapter Driver");
 
+#ifdef	THREAD
 static int mlme_kill;
+#endif
 
 #define DEVICE_PARAM(N, D)
 
@@ -1596,7 +1598,8 @@ void	InitRxManagementQueue(PSDevice  pDevice)
 //PLICE_DEBUG<-
 
 //PLICE_DEBUG ->
-int MlmeThread(
+#ifdef	THREAD
+static int MlmeThread(
 	void *Context)
 {
 	PSDevice	pDevice =  (PSDevice) Context;
@@ -1619,6 +1622,7 @@ int MlmeThread(
 
 	return 0;
 }
+#endif
 
 static int  device_open(struct net_device *dev) {
 	PSDevice pDevice = (PSDevice)netdev_priv(dev);
-- 
1.8.5.5

