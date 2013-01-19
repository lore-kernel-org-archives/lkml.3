Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab3ASBUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:20:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:56883 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848Ab3ASBUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:20:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tormod Volden <debian.tormod@gmail.com>
Subject: [ 20/21] staging: wlan-ng: Fix clamping of returned SSID length
Date: Fri, 18 Jan 2013 17:19:38 -0800
Message-Id: <20130119010714.716690078@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010710.897187774@linuxfoundation.org>
References: <20130119010710.897187774@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tormod Volden <debian.tormod@gmail.com>

commit 811a37effdb11e54e1ff1ddaa944286c88f58487 upstream.

Commit 2e254212 broke listing of available network names, since it
clamped the length of the returned SSID to WLAN_BSSID_LEN (6) instead of
WLAN_SSID_MAXLEN (32).

https://bugzilla.kernel.org/show_bug.cgi?id=52501

Signed-off-by: Tormod Volden <debian.tormod@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/wlan-ng/prism2mgmt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/wlan-ng/prism2mgmt.c
+++ b/drivers/staging/wlan-ng/prism2mgmt.c
@@ -406,7 +406,7 @@ int prism2mgmt_scan_results(wlandevice_t
 	/* SSID */
 	req->ssid.status = P80211ENUM_msgitem_status_data_ok;
 	req->ssid.data.len = le16_to_cpu(item->ssid.len);
-	req->ssid.data.len = min_t(u16, req->ssid.data.len, WLAN_BSSID_LEN);
+	req->ssid.data.len = min_t(u16, req->ssid.data.len, WLAN_SSID_MAXLEN);
 	memcpy(req->ssid.data.data, item->ssid.data, req->ssid.data.len);
 
 	/* supported rates */


