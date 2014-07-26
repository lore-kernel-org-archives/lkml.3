Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbaGZUJw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:09:52 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:53257 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaGZUJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 16:09:49 -0400
From: torresariass@gmail.com
To: devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Trivial Patch Monkey <trivial@kernel.org>,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Tugce Sirin <ztugcesirin@gmail.com>,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        Santiago Torres <torresariass@gmail.com>
Subject: [PATCH] wlan-ng:prism2sta: Changes reporting format to meet checkpatch.pl
Date: Sat, 26 Jul 2014 16:09:24 -0400
Message-Id: <1406405364-30340-1-git-send-email-torresariass@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santiago Torres <torresariass@gmail.com>

[linux-next]: Make the format strings for netdev_err shorter so they can
fit under the 80 column width requirement.

To achieve this, the "result="  was stripped down to an implicit version
(i.e. result=%d to (%d)). This allows the whole string to fit inside the
80 column limit to pass some of the checkpatch.pl requirements.

While the error message is not as explicit as it used to be, it
shouldn't affect readability; specially since it is the only formatted
value printed to the log.

Signed-off by: Santiago Torres-Arias <torresariass@gmail.com>
---
 drivers/staging/wlan-ng/prism2sta.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index 799ce8a..f05f142 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -453,7 +453,8 @@ u32 prism2sta_ifstate(wlandevice_t *wlandev, u32 ifstate)
 			result = hfa384x_drvr_start(hw);
 			if (result) {
 				netdev_err(wlandev->netdev,
-				       "hfa384x_drvr_start() failed,result=%d\n", (int)result);
+					"hfa384x_drvr_start() failed (%d)\n",
+					(int)result);
 				result =
 				 P80211ENUM_resultcode_implementation_failure;
 				wlandev->msdstate = WLAN_MSD_HWPRESENT;
@@ -496,7 +497,8 @@ u32 prism2sta_ifstate(wlandevice_t *wlandev, u32 ifstate)
 			result = hfa384x_drvr_start(hw);
 			if (result) {
 				netdev_err(wlandev->netdev,
-				       "hfa384x_drvr_start() failed,result=%d\n", (int)result);
+				       "hfa384x_drvr_start() failed (%d)\n",
+				       (int)result);
 				result =
 				  P80211ENUM_resultcode_implementation_failure;
 				wlandev->msdstate = WLAN_MSD_HWPRESENT;
@@ -506,7 +508,8 @@ u32 prism2sta_ifstate(wlandevice_t *wlandev, u32 ifstate)
 			result = prism2sta_getcardinfo(wlandev);
 			if (result) {
 				netdev_err(wlandev->netdev,
-				       "prism2sta_getcardinfo() failed,result=%d\n", (int)result);
+				       "prism2sta_getcardinfo() failed (%d)\n",
+				       (int)result);
 				result =
 				  P80211ENUM_resultcode_implementation_failure;
 				hfa384x_drvr_stop(hw);
@@ -516,7 +519,8 @@ u32 prism2sta_ifstate(wlandevice_t *wlandev, u32 ifstate)
 			result = prism2sta_globalsetup(wlandev);
 			if (result) {
 				netdev_err(wlandev->netdev,
-				       "prism2sta_globalsetup() failed,result=%d\n", (int)result);
+				       "prism2sta_globalsetup() failed (%d)\n",
+				       (int)result);
 				result =
 				  P80211ENUM_resultcode_implementation_failure;
 				hfa384x_drvr_stop(hw);
-- 
1.7.9.5

