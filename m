Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaG1H62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 03:58:28 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:40760 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaG1H61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 03:58:27 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: bjorn@mork.no, silvio.fricke@gmail.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH 1/1] drivers: staging: vt6655: ioctl.c - missing __user annotation
Date: Mon, 28 Jul 2014 13:28:12 +0530
Message-Id: <1406534292-22601-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- private_ioctl() the internally calls copy_{to,from}_user() and does
  not use '__user' while refrencing user space pointers.
- this patch passes __user annotation as a cast, when the pointer is
 being refernced.
- this patch fixes the following sparse errors:
drivers/staging/vt6655/ioctl.c:44:12: warning: symbol 'wpa_Result' was not declared. Should it be static?
drivers/staging/vt6655/ioctl.c:78:51: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/vt6655/ioctl.c:78:51:    expected void const [noderef] <asn:1>*from
drivers/staging/vt6655/ioctl.c:78:51:    got void *data
drivers/staging/vt6655/ioctl.c:117:55: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/vt6655/ioctl.c:117:55:    expected void const [noderef] <asn:1>*from
drivers/staging/vt6655/ioctl.c:117:55:    got void *data
drivers/staging/vt6655/ioctl.c:149:46: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/vt6655/ioctl.c:149:46:    expected void [noderef] <asn:1>*to
drivers/staging/vt6655/ioctl.c:149:46:    got void *data
drivers/staging/vt6655/ioctl.c:166:51: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/vt6655/ioctl.c:166:51:    expected void const [noderef] <asn:1>*from
drivers/staging/vt6655/ioctl.c:166:51:    got void *data
drivers/staging/vt6655/ioctl.c:212:50: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/vt6655/ioctl.c:212:50:    expected void const [noderef] <asn:1>*from
drivers/staging/vt6655/ioctl.c:212:50:    got void *data
drivers/staging/vt6655/ioctl.c:276:38: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/vt6655/ioctl.c:276:38:    expected void [noderef] <asn:1>*to
drivers/staging/vt6655/ioctl.c:276:38:    got void *data
drivers/staging/vt6655/ioctl.c:292:38: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/vt6655/ioctl.c:292:38:    expected void [noderef] <asn:1>*to
drivers/staging/vt6655/ioctl.c:292:38:    got void *data
drivers/staging/vt6655/ioctl.c:300:48: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/vt6655/ioctl.c:300:48:    expected void const [noderef] <asn:1>*from
drivers/staging/vt6655/ioctl.c:300:48:    got void *data
drivers/staging/vt6655/ioctl.c:344:38: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/vt6655/ioctl.c:344:38:    expected void [noderef] <asn:1>*to
drivers/staging/vt6655/ioctl.c:344:38:    got void *data
drivers/staging/vt6655/ioctl.c:353:38: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/vt6655/ioctl.c:353:38:    expected void [noderef] <asn:1>*to
drivers/staging/vt6655/ioctl.c:353:38:    got void *data
drivers/staging/vt6655/ioctl.c:360:38: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/vt6655/ioctl.c:360:38:    expected void [noderef] <asn:1>*to
drivers/staging/vt6655/ioctl.c:360:38:    got void *data
drivers/staging/vt6655/ioctl.c:401:49: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/vt6655/ioctl.c:401:49:    expected void const [noderef] <asn:1>*from
drivers/staging/vt6655/ioctl.c:401:49:    got void *data
drivers/staging/vt6655/ioctl.c:424:49: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/vt6655/ioctl.c:424:49:    expected void const [noderef] <asn:1>*from
drivers/staging/vt6655/ioctl.c:424:49:    got void *data
drivers/staging/vt6655/ioctl.c:440:49: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/vt6655/ioctl.c:440:49:    expected void const [noderef] <asn:1>*from
drivers/staging/vt6655/ioctl.c:440:49:    got void *data
drivers/staging/vt6655/ioctl.c:457:49: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/vt6655/ioctl.c:457:49:    expected void const [noderef] <asn:1>*from
drivers/staging/vt6655/ioctl.c:457:49:    got void *data
drivers/staging/vt6655/ioctl.c:479:54: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/vt6655/ioctl.c:479:54:    expected void const [noderef] <asn:1>*from
drivers/staging/vt6655/ioctl.c:479:54:    got void *data
drivers/staging/vt6655/ioctl.c:563:38: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/vt6655/ioctl.c:563:38:    expected void [noderef] <asn:1>*to
drivers/staging/vt6655/ioctl.c:563:38:    got void *data
drivers/staging/vt6655/ioctl.c:571:52: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/vt6655/ioctl.c:571:52:    expected void const [noderef] <asn:1>*from
drivers/staging/vt6655/ioctl.c:571:52:    got void *data
drivers/staging/vt6655/ioctl.c:615:38: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/vt6655/ioctl.c:615:38:    expected void [noderef] <asn:1>*to
drivers/staging/vt6655/ioctl.c:615:38:    got void *data
drivers/staging/vt6655/ioctl.c:631:53: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/vt6655/ioctl.c:631:53:    expected void const [noderef] <asn:1>*from

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/vt6655/ioctl.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/vt6655/ioctl.c b/drivers/staging/vt6655/ioctl.c
index 18d11d1..86c45c7 100644
--- a/drivers/staging/vt6655/ioctl.c
+++ b/drivers/staging/vt6655/ioctl.c
@@ -75,7 +75,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 	switch (pReq->wCmdCode) {
 	case WLAN_CMD_BSS_SCAN:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_BSS_SCAN..begin\n");
-		if (copy_from_user(&sScanCmd, pReq->data, sizeof(SCmdScan))) {
+		if (copy_from_user(&sScanCmd, (void __user *) pReq->data, sizeof(SCmdScan))) {
 			result = -EFAULT;
 			break;
 		}
@@ -114,7 +114,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 		result = -EOPNOTSUPP;
 		break;
 
-		if (copy_from_user(&sZoneTypeCmd, pReq->data, sizeof(SCmdZoneTypeSet))) {
+		if (copy_from_user(&sZoneTypeCmd, (void __user *) pReq->data, sizeof(SCmdZoneTypeSet))) {
 			result = -EFAULT;
 			break;
 		}
@@ -146,7 +146,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 				result = -EFAULT;
 				break;
 			}
-			if (copy_to_user(pReq->data, &sZoneTypeCmd, sizeof(SCmdZoneTypeSet))) {
+			if (copy_to_user((void __user *) pReq->data, &sZoneTypeCmd, sizeof(SCmdZoneTypeSet))) {
 				result = -EFAULT;
 				break;
 			}
@@ -163,7 +163,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			pDevice->bMACSuspend = false;
 		}
 
-		if (copy_from_user(&sJoinCmd, pReq->data, sizeof(SCmdBSSJoin))) {
+		if (copy_from_user(&sJoinCmd, (void __user *) pReq->data, sizeof(SCmdBSSJoin))) {
 			result = -EFAULT;
 			break;
 		}
@@ -209,7 +209,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 	case WLAN_CMD_SET_WEP:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_SET_WEP Key.\n");
 		memset(&sWEPCmd, 0, sizeof(SCmdSetWEP));
-		if (copy_from_user(&sWEPCmd, pReq->data, sizeof(SCmdSetWEP))) {
+		if (copy_from_user(&sWEPCmd, (void __user *) pReq->data, sizeof(SCmdSetWEP))) {
 			result = -EFAULT;
 			break;
 		}
@@ -273,7 +273,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			sLinkStatus.bLink = false;
 			sLinkStatus.uLinkRate = 0;
 		}
-		if (copy_to_user(pReq->data, &sLinkStatus, sizeof(SCmdLinkStatus))) {
+		if (copy_to_user((void __user *) pReq->data, &sLinkStatus, sizeof(SCmdLinkStatus))) {
 			result = -EFAULT;
 			break;
 		}
@@ -289,7 +289,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			cbListCount++;
 		}
 		sList.uItem = cbListCount;
-		if (copy_to_user(pReq->data, &sList, sizeof(SBSSIDList))) {
+		if (copy_to_user((void __user *) pReq->data, &sList, sizeof(SBSSIDList))) {
 			result = -EFAULT;
 			break;
 		}
@@ -297,7 +297,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 		break;
 
 	case WLAN_CMD_GET_LIST:
-		if (copy_from_user(&sList, pReq->data, sizeof(SBSSIDList))) {
+		if (copy_from_user(&sList, (void __user *) pReq->data, sizeof(SBSSIDList))) {
 			result = -EFAULT;
 			break;
 		}
@@ -341,7 +341,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			}
 		}
 
-		if (copy_to_user(pReq->data, pList, sizeof(SBSSIDList) + (sList.uItem * sizeof(SBSSIDItem)))) {
+		if (copy_to_user((void __user *) pReq->data, pList, sizeof(SBSSIDList) + (sList.uItem * sizeof(SBSSIDItem)))) {
 			result = -EFAULT;
 			break;
 		}
@@ -350,14 +350,14 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 		break;
 
 	case WLAN_CMD_GET_MIB:
-		if (copy_to_user(pReq->data, &(pDevice->s802_11Counter), sizeof(SDot11MIBCount))) {
+		if (copy_to_user((void __user *) pReq->data, &(pDevice->s802_11Counter), sizeof(SDot11MIBCount))) {
 			result = -EFAULT;
 			break;
 		}
 		break;
 
 	case WLAN_CMD_GET_STAT:
-		if (copy_to_user(pReq->data, &(pDevice->scStatistic), sizeof(SStatCounter))) {
+		if (copy_to_user((void __user *) pReq->data, &(pDevice->scStatistic), sizeof(SStatCounter))) {
 			result = -EFAULT;
 			break;
 		}
@@ -398,7 +398,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 	case WLAN_CMD_SET_HOSTAPD:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_SET_HOSTAPD\n");
 
-		if (copy_from_user(&sValue, pReq->data, sizeof(SCmdValue))) {
+		if (copy_from_user(&sValue, (void __user *) pReq->data, sizeof(SCmdValue))) {
 			result = -EFAULT;
 			break;
 		}
@@ -421,7 +421,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 
 	case WLAN_CMD_SET_802_1X:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_SET_802_1X\n");
-		if (copy_from_user(&sValue, pReq->data, sizeof(SCmdValue))) {
+		if (copy_from_user(&sValue, (void __user *) pReq->data, sizeof(SCmdValue))) {
 			result = -EFAULT;
 			break;
 		}
@@ -437,7 +437,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 
 	case WLAN_CMD_SET_HOST_WEP:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_SET_HOST_WEP\n");
-		if (copy_from_user(&sValue, pReq->data, sizeof(SCmdValue))) {
+		if (copy_from_user(&sValue, (void __user *) pReq->data, sizeof(SCmdValue))) {
 			result = -EFAULT;
 			break;
 		}
@@ -454,7 +454,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 	case WLAN_CMD_SET_WPA:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_SET_WPA\n");
 
-		if (copy_from_user(&sValue, pReq->data, sizeof(SCmdValue))) {
+		if (copy_from_user(&sValue, (void __user *) pReq->data, sizeof(SCmdValue))) {
 			result = -EFAULT;
 			break;
 		}
@@ -476,7 +476,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			MACvIntEnable(pDevice->PortOffset, IMR_MASK_VALUE);
 			add_timer(&pMgmt->sTimerSecondCallback);
 		}
-		if (copy_from_user(&sStartAPCmd, pReq->data, sizeof(SCmdStartAP))) {
+		if (copy_from_user(&sStartAPCmd, (void __user *) pReq->data, sizeof(SCmdStartAP))) {
 			result = -EFAULT;
 			break;
 		}
@@ -560,7 +560,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 		}
 
 		sNodeList.uItem = cbListCount;
-		if (copy_to_user(pReq->data, &sNodeList, sizeof(SNodeList))) {
+		if (copy_to_user((void __user *) pReq->data, &sNodeList, sizeof(SNodeList))) {
 			result = -EFAULT;
 			break;
 		}
@@ -568,7 +568,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 		break;
 
 	case WLAN_CMD_GET_NODE_LIST:
-		if (copy_from_user(&sNodeList, pReq->data, sizeof(SNodeList))) {
+		if (copy_from_user(&sNodeList, (void __user *) pReq->data, sizeof(SNodeList))) {
 			result = -EFAULT;
 			break;
 		}
@@ -612,7 +612,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 					break;
 			}
 		}
-		if (copy_to_user(pReq->data, pNodeList, sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)))) {
+		if (copy_to_user((void __user *) pReq->data, pNodeList, sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)))) {
 			result = -EFAULT;
 			break;
 		}
@@ -628,7 +628,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 		wpa_Result.eap_type = 0;
 		wpa_Result.authenticated = false;
 		pDevice->fWPA_Authened = false;
-		if (copy_from_user(&wpa_Result, pReq->data, sizeof(wpa_Result))) {
+		if (copy_from_user(&wpa_Result, (void __user *) pReq->data, sizeof(wpa_Result))) {
 			result = -EFAULT;
 			break;
 		}
-- 
1.9.1

