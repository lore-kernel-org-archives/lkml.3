Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaBJTm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:42:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34654 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbaBJTmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:42:54 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 054/124] mwifiex: add missing endian conversion for fw_tsf
Date: Mon, 10 Feb 2014 11:39:54 -0800
Message-Id: <1392061264-28124-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amitkumar Karwar <akarwar@marvell.com>

commit 9795229752c31da0c5f8a7dc4c827665327b52f9 upstream.

It is u64 data received from firmware. Little endian to cpu
conversion is required here.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/mwifiex/scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 771be26..084c6b9 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1618,7 +1618,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		const u8 *ie_buf;
 		size_t ie_len;
 		u16 channel = 0;
-		u64 fw_tsf = 0;
+		__le64 fw_tsf = 0;
 		u16 beacon_size = 0;
 		u32 curr_bcn_bytes;
 		u32 freq;
@@ -1745,7 +1745,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 					      ie_buf, ie_len, rssi, GFP_KERNEL);
 				bss_priv = (struct mwifiex_bss_priv *)bss->priv;
 				bss_priv->band = band;
-				bss_priv->fw_tsf = fw_tsf;
+				bss_priv->fw_tsf = le64_to_cpu(fw_tsf);
 				if (priv->media_connected &&
 				    !memcmp(bssid,
 					    priv->curr_bss_params.bss_descriptor
-- 
1.8.3.2

