Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935229AbaBDVsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:48:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934402AbaBDVL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:11:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.13 040/140] mwifiex: add missing endian conversion for fw_tsf
Date: Tue,  4 Feb 2014 13:10:27 -0800
Message-Id: <20140204211038.110016829@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amitkumar Karwar <akarwar@marvell.com>

commit 9795229752c31da0c5f8a7dc4c827665327b52f9 upstream.

It is u64 data received from firmware. Little endian to cpu
conversion is required here.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1681,7 +1681,7 @@ int mwifiex_ret_802_11_scan(struct mwifi
 		const u8 *ie_buf;
 		size_t ie_len;
 		u16 channel = 0;
-		u64 fw_tsf = 0;
+		__le64 fw_tsf = 0;
 		u16 beacon_size = 0;
 		u32 curr_bcn_bytes;
 		u32 freq;
@@ -1815,7 +1815,7 @@ int mwifiex_ret_802_11_scan(struct mwifi
 					      ie_buf, ie_len, rssi, GFP_KERNEL);
 				bss_priv = (struct mwifiex_bss_priv *)bss->priv;
 				bss_priv->band = band;
-				bss_priv->fw_tsf = fw_tsf;
+				bss_priv->fw_tsf = le64_to_cpu(fw_tsf);
 				if (priv->media_connected &&
 				    !memcmp(bssid,
 					    priv->curr_bss_params.bss_descriptor


