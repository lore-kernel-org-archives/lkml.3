Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbaIZKsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:48:41 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:54248 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbaIZKsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:48:40 -0400
MIME-Version: 1.0
Date: Fri, 26 Sep 2014 18:48:39 +0800
Message-ID: <CAJKoSVS_5LdyjXyGeZENtekodr1Cn5=VVBfDf0hHCJ-xWHvqaw@mail.gmail.com>
Subject: [PATCH] drivers: staging: wlan-ng: fix sparse warnings
From: Cheng-Wei Lee <lee.rhapsody@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, johannes.berg@intel.com,
        josh@joshtriplett.org, sarah.a.sharp@linux.intel.com,
        himangi774@gmail.com, teobaluta@gmail.com, linville@tuxdriver.com,
        gamerh2o@gmail.com
Cc: devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the sparse warnings in wlan-ng/cfg80211.c
The following functions were only used in this file, so done by
declaring them into static.

drivers/staging/wlan-ng/cfg80211.c:710:6: warning: symbol
'prism2_connect_result' was not declared. Should it be static?
drivers/staging/wlan-ng/cfg80211.c:719:6: warning: symbol
'prism2_disconnected' was not declared. Should it be static?
drivers/staging/wlan-ng/cfg80211.c:725:6: warning: symbol
'prism2_roamed' was not declared. Should it be static?

Signed-off-by: Quentin Lee <lee.rhapsody@gmail.com>
---
 drivers/staging/wlan-ng/cfg80211.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wlan-ng/cfg80211.c
b/drivers/staging/wlan-ng/cfg80211.c
index 723319e..9e65429 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -707,7 +707,7 @@ exit:


 /* Interface callback functions, passing data back up to the cfg80211 layer */
-void prism2_connect_result(wlandevice_t *wlandev, u8 failed)
+static void prism2_connect_result(wlandevice_t *wlandev, u8 failed)
 {
 	u16 status = failed ?
 		     WLAN_STATUS_UNSPECIFIED_FAILURE : WLAN_STATUS_SUCCESS;
@@ -716,13 +716,13 @@ void prism2_connect_result(wlandevice_t
*wlandev, u8 failed)
 				NULL, 0, NULL, 0, status, GFP_KERNEL);
 }

-void prism2_disconnected(wlandevice_t *wlandev)
+static void prism2_disconnected(wlandevice_t *wlandev)
 {
 	cfg80211_disconnected(wlandev->netdev, 0, NULL,
 		0, GFP_KERNEL);
 }

-void prism2_roamed(wlandevice_t *wlandev)
+static void prism2_roamed(wlandevice_t *wlandev)
 {
 	cfg80211_roamed(wlandev->netdev, NULL, wlandev->bssid,
 		NULL, 0, NULL, 0, GFP_KERNEL);
-- 
1.7.9.5
