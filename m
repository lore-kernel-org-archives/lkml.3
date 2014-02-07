Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaBGMrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:47:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41932 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358AbaBGLuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 115/233] mwifiex: add missing endian conversion for fw_tsf
Date: Fri,  7 Feb 2014 11:45:34 +0000
Message-Id: <1391773652-25214-116-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amitkumar Karwar <akarwar@marvell.com>

commit 9795229752c31da0c5f8a7dc4c827665327b52f9 upstream.

It is u64 data received from firmware. Little endian to cpu
conversion is required here.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/mwifiex/scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index c447d9b..41f72c6 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1652,7 +1652,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		const u8 *ie_buf;
 		size_t ie_len;
 		u16 channel = 0;
-		u64 fw_tsf = 0;
+		__le64 fw_tsf = 0;
 		u16 beacon_size = 0;
 		u32 curr_bcn_bytes;
 		u32 freq;
@@ -1786,7 +1786,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
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

