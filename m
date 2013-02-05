Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab3BEWIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:08:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47883 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab3BEWIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:08:35 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tormod Volden <debian.tormod@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 15/93] staging: wlan-ng: Fix clamping of returned SSID length
Date: Tue,  5 Feb 2013 20:06:04 -0200
Message-Id: <1360102042-10732-16-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tormod Volden <debian.tormod@gmail.com>

commit 811a37effdb11e54e1ff1ddaa944286c88f58487 upstream.

Commit 2e254212 broke listing of available network names, since it
clamped the length of the returned SSID to WLAN_BSSID_LEN (6) instead of
WLAN_SSID_MAXLEN (32).

https://bugzilla.kernel.org/show_bug.cgi?id=52501

Signed-off-by: Tormod Volden <debian.tormod@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/staging/wlan-ng/prism2mgmt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
index 4efa9bc..89bfd85 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.c
+++ b/drivers/staging/wlan-ng/prism2mgmt.c
@@ -406,7 +406,7 @@ int prism2mgmt_scan_results(wlandevice_t *wlandev, void *msgp)
 	/* SSID */
 	req->ssid.status = P80211ENUM_msgitem_status_data_ok;
 	req->ssid.data.len = le16_to_cpu(item->ssid.len);
-	req->ssid.data.len = min_t(u16, req->ssid.data.len, WLAN_BSSID_LEN);
+	req->ssid.data.len = min_t(u16, req->ssid.data.len, WLAN_SSID_MAXLEN);
 	memcpy(req->ssid.data.data, item->ssid.data, req->ssid.data.len);
 
 	/* supported rates */
-- 
1.7.9.5

