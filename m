Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaCaNl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:41:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35680 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbaCaNYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:24:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 34/71] mwifiex: copy AP's HT capability info correctly
Date: Mon, 31 Mar 2014 14:22:40 +0100
Message-Id: <1396272197-13394-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amitkumar Karwar <akarwar@marvell.com>

commit c99b1861c232e1f641f13b8645e0febb3712cc71 upstream.

While preparing association request, intersection of device's HT
capability information and corresponding fields advertised by AP
is used.

This patch fixes an error while copying this field from AP's
beacon.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/mwifiex/11n.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index fe8ebfe..d5ad81d 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -340,8 +340,7 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 		ht_cap->header.len =
 				cpu_to_le16(sizeof(struct ieee80211_ht_cap));
 		memcpy((u8 *) ht_cap + sizeof(struct mwifiex_ie_types_header),
-		       (u8 *) bss_desc->bcn_ht_cap +
-		       sizeof(struct ieee_types_header),
+		       (u8 *)bss_desc->bcn_ht_cap,
 		       le16_to_cpu(ht_cap->header.len));
 
 		mwifiex_fill_cap_info(priv, radio_type, ht_cap);
-- 
1.9.1

