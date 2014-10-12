Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaJLQyO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 12:54:14 -0400
Received: from forward15.mail.yandex.net ([95.108.130.119]:43760 "EHLO
	forward15.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaJLQyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 12:54:11 -0400
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Oct 2014 12:54:10 EDT
X-Yandex-Uniq: e2d7a6b5-cbcc-483d-801c-4a401f229aad
Authentication-Results: smtp13.mail.yandex.net; dkim=pass header.i=@yandex.com
From: Erich Cordoba Malibran <erich.cordoba@yandex.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Erich Cordoba <erich.cordoba@yandex.com>
Subject: [PATCH] Staging: wlan-ng: prism2 simple style modifications
Date: Sun, 12 Oct 2014 11:44:07 -0500
Message-Id: <1413132247-3667-1-git-send-email-erich.cordoba@yandex.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erich Cordoba <erich.cordoba@yandex.com>

prism2fw.c
prism2sta.c
	Fixed style warning reported by checkpatch.pl
prism2mib.c
	Renamed function prism2mib_framenthreshold to
	meet style guidelines.

Signed-off-by: Erich Cordoba Malibran <erich.cordoba@yandex.com>
---
 drivers/staging/wlan-ng/prism2fw.c  | 10 +++++++---
 drivers/staging/wlan-ng/prism2mib.c | 26 +++++++++++++-------------
 drivers/staging/wlan-ng/prism2sta.c | 18 ++++++++++++------
 3 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index 6c38f79..8641f97 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -238,7 +238,8 @@ static int prism2_fwtry(struct usb_device *udev, wlandevice_t *wlandev)
 *	0	- success
 *	~0	- failure
 ----------------------------------------------------------------*/
-static int prism2_fwapply(const struct ihex_binrec *rfptr, wlandevice_t *wlandev)
+static int prism2_fwapply(const struct ihex_binrec *rfptr,
+			  wlandevice_t *wlandev)
 {
 	signed int result = 0;
 	struct p80211msg_dot11req_mibget getmsg;
@@ -707,7 +708,9 @@ static int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
 			continue;
 		}
 
-		/* Validate plug address against chunk data and identify chunk */
+		/* Validate plug address against
+		 * chunk data and identify chunk
+		 */
 		for (c = 0; c < nfchunks; c++) {
 			cstart = fchunk[c].addr;
 			cend = fchunk[c].addr + fchunk[c].len;
@@ -922,7 +925,8 @@ static int read_fwfile(const struct ihex_binrec *record)
 				      rcnt,
 				      s3info[ns3info].len,
 				      s3info[ns3info].type);
-			if (((s3info[ns3info].len - 1) * sizeof(u16)) > sizeof(s3info[ns3info].info)) {
+			if (((s3info[ns3info].len - 1) * sizeof(u16)) >
+				sizeof(s3info[ns3info].info)) {
 				pr_err("S3 inforec length too long - aborting\n");
 				return 1;
 			}
diff --git a/drivers/staging/wlan-ng/prism2mib.c b/drivers/staging/wlan-ng/prism2mib.c
index 0163e06..30d224f 100644
--- a/drivers/staging/wlan-ng/prism2mib.c
+++ b/drivers/staging/wlan-ng/prism2mib.c
@@ -132,12 +132,12 @@ static int prism2mib_excludeunencrypted(struct mibrec *mib,
 					struct p80211msg_dot11req_mibset *msg,
 					void *data);
 
-static int prism2mib_fragmentationthreshold(struct mibrec *mib,
-					    int isget,
-					    wlandevice_t *wlandev,
-					    hfa384x_t *hw,
-					    struct p80211msg_dot11req_mibset *msg,
-					    void *data);
+static int prism2mib_fragmenthreshold(struct mibrec *mib,
+				      int isget,
+				      wlandevice_t *wlandev,
+				      hfa384x_t *hw,
+				      struct p80211msg_dot11req_mibset *msg,
+				      void *data);
 
 static int prism2mib_priv(struct mibrec *mib,
 			  int isget,
@@ -198,7 +198,7 @@ static struct mibrec mibtab[] = {
 	{DIDmib_dot11mac_dot11OperationTable_dot11FragmentationThreshold,
 	 F_STA | F_READ | F_WRITE,
 	 HFA384x_RID_FRAGTHRESH, 0, 0,
-	 prism2mib_fragmentationthreshold},
+	 prism2mib_fragmenthreshold},
 	{DIDmib_dot11mac_dot11OperationTable_dot11MaxTransmitMSDULifetime,
 	 F_STA | F_READ,
 	 HFA384x_RID_MAXTXLIFETIME, 0, 0,
@@ -660,12 +660,12 @@ static int prism2mib_excludeunencrypted(struct mibrec *mib,
 *
 ----------------------------------------------------------------*/
 
-static int prism2mib_fragmentationthreshold(struct mibrec *mib,
-					    int isget,
-					    wlandevice_t *wlandev,
-					    hfa384x_t *hw,
-					    struct p80211msg_dot11req_mibset *msg,
-					    void *data)
+static int prism2mib_fragmenthreshold(struct mibrec *mib,
+				      int isget,
+				      wlandevice_t *wlandev,
+				      hfa384x_t *hw,
+				      struct p80211msg_dot11req_mibset *msg,
+				      void *data)
 {
 	int result;
 	u32 *uint32 = (u32 *) data;
diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index 799ce8a..fb1927a 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -58,6 +58,7 @@
 #include <linux/slab.h>
 #include <linux/wireless.h>
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 #include <linux/workqueue.h>
 #include <linux/byteorder/generic.h>
 #include <linux/ctype.h>
@@ -453,7 +454,8 @@ u32 prism2sta_ifstate(wlandevice_t *wlandev, u32 ifstate)
 			result = hfa384x_drvr_start(hw);
 			if (result) {
 				netdev_err(wlandev->netdev,
-				       "hfa384x_drvr_start() failed,result=%d\n", (int)result);
+					"Hfa384x_drvr_start() failed,result=%d\n",
+					(int)result);
 				result =
 				 P80211ENUM_resultcode_implementation_failure;
 				wlandev->msdstate = WLAN_MSD_HWPRESENT;
@@ -496,7 +498,8 @@ u32 prism2sta_ifstate(wlandevice_t *wlandev, u32 ifstate)
 			result = hfa384x_drvr_start(hw);
 			if (result) {
 				netdev_err(wlandev->netdev,
-				       "hfa384x_drvr_start() failed,result=%d\n", (int)result);
+				       "hfa384x_drvr_start() failed,result=%d\n",
+					(int)result);
 				result =
 				  P80211ENUM_resultcode_implementation_failure;
 				wlandev->msdstate = WLAN_MSD_HWPRESENT;
@@ -506,7 +509,8 @@ u32 prism2sta_ifstate(wlandevice_t *wlandev, u32 ifstate)
 			result = prism2sta_getcardinfo(wlandev);
 			if (result) {
 				netdev_err(wlandev->netdev,
-				       "prism2sta_getcardinfo() failed,result=%d\n", (int)result);
+					"prism2sta_getcardinfo() failed,result=%d\n",
+					(int)result);
 				result =
 				  P80211ENUM_resultcode_implementation_failure;
 				hfa384x_drvr_stop(hw);
@@ -516,7 +520,8 @@ u32 prism2sta_ifstate(wlandevice_t *wlandev, u32 ifstate)
 			result = prism2sta_globalsetup(wlandev);
 			if (result) {
 				netdev_err(wlandev->netdev,
-				       "prism2sta_globalsetup() failed,result=%d\n", (int)result);
+				       "prism2sta_globalsetup() failed,result=%d\n",
+					(int)result);
 				result =
 				  P80211ENUM_resultcode_implementation_failure;
 				hfa384x_drvr_stop(hw);
@@ -1271,7 +1276,8 @@ void prism2sta_processing_defer(struct work_struct *data)
 				     HFA384x_RID_CURRENTSSID, result);
 				return;
 			}
-			prism2mgmt_bytestr2pstr((struct hfa384x_bytestr *) &ssid,
+			prism2mgmt_bytestr2pstr((struct hfa384x_bytestr *) &
+						ssid,
 						(p80211pstrd_t *) &
 						wlandev->ssid);
 
@@ -1572,7 +1578,7 @@ static void prism2sta_inf_authreq_defer(wlandevice_t *wlandev,
 	 ** authentication.
 	 */
 
-	memcpy(rec.address, inf->info.authreq.sta_addr, ETH_ALEN);
+	ether_addr_copy(rec.address, inf->info.authreq.sta_addr);
 	rec.status = P80211ENUM_status_unspec_failure;
 
 	/*
-- 
2.1.2

