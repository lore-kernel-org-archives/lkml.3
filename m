Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935172AbaGXXJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:09:59 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:59405 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759807AbaGXXHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:07:07 -0400
X-Originating-IP: 109.10.215.15
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 08/14] staging: vt6655: break single line if statements
Date: Fri, 25 Jul 2014 01:06:22 +0200
Message-Id: <1406243188-13413-9-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406243188-13413-1-git-send-email-gclement@baobob.org>
References: <1406243188-13413-1-git-send-email-gclement@baobob.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the "trailing statements should be on next line" checkpatch
warning.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/card.c        | 6 ++++--
 drivers/staging/vt6655/device_main.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 58d707f..4ae8d93 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -934,8 +934,10 @@ bool CARDbRadioPowerOn(void *pDeviceHandler)
 
 	pr_debug("chester power on\n");
 	if (pDevice->bRadioControlOff == true) {
-		if (pDevice->bHWRadioOff == true) pr_debug("chester bHWRadioOff\n");
-		if (pDevice->bRadioControlOff == true) pr_debug("chester bRadioControlOff\n");
+		if (pDevice->bHWRadioOff == true)
+			pr_debug("chester bHWRadioOff\n");
+		if (pDevice->bRadioControlOff == true)
+			pr_debug("chester bRadioControlOff\n");
 		return false; }
 
 	if (pDevice->bRadioOff == false) {
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index c3cae50..7bd728c 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -388,7 +388,8 @@ device_set_options(PSDevice pDevice) {
 	pDevice->b11hEnable = (pDevice->sOpts.flags & DEVICE_FLAGS_80211h_MODE) ? 1 : 0;
 	pDevice->bDiversityRegCtlON = (pDevice->sOpts.flags & DEVICE_FLAGS_DiversityANT) ? 1 : 0;
 	pDevice->uConnectionRate = pDevice->sOpts.data_rate;
-	if (pDevice->uConnectionRate < RATE_AUTO) pDevice->bFixRate = true;
+	if (pDevice->uConnectionRate < RATE_AUTO)
+		pDevice->bFixRate = true;
 	pDevice->byBBType = pDevice->sOpts.bbp_type;
 	pDevice->byPacketType = pDevice->byBBType;
 
@@ -2889,7 +2890,8 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 			char abyKey[WLAN_WEP232_KEYLEN];
 
 			rc = iwctl_giwencode(dev, NULL, &(wrq->u.encoding), abyKey);
-			if (rc != 0) break;
+			if (rc != 0)
+				break;
 			if (wrq->u.encoding.pointer) {
 				if (copy_to_user(wrq->u.encoding.pointer,
 						 abyKey,
-- 
1.8.5.5

