Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaDALt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:49:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42487 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbaDALRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 079/144] mwifiex: save and copy AP's VHT capability info correctly
Date: Tue,  1 Apr 2014 12:14:43 +0100
Message-Id: <1396350948-29910-80-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amitkumar Karwar <akarwar@marvell.com>

commit d51246481c7f28bbfa1f814ded2da65e531cd4b2 upstream.

While preparing association request, intersection of device's
VHT capability information and corresponding field advertised
by AP is used.

This patch fixes a couple errors while saving and copying vht_cap
and vht_oper fields from AP's beacon.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/mwifiex/11ac.c | 3 +--
 drivers/net/wireless/mwifiex/scan.c | 8 ++++----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11ac.c b/drivers/net/wireless/mwifiex/11ac.c
index 5e0eec4..5d9a808 100644
--- a/drivers/net/wireless/mwifiex/11ac.c
+++ b/drivers/net/wireless/mwifiex/11ac.c
@@ -189,8 +189,7 @@ int mwifiex_cmd_append_11ac_tlv(struct mwifiex_private *priv,
 		vht_cap->header.len  =
 				cpu_to_le16(sizeof(struct ieee80211_vht_cap));
 		memcpy((u8 *)vht_cap + sizeof(struct mwifiex_ie_types_header),
-		       (u8 *)bss_desc->bcn_vht_cap +
-		       sizeof(struct ieee_types_header),
+		       (u8 *)bss_desc->bcn_vht_cap,
 		       le16_to_cpu(vht_cap->header.len));
 
 		mwifiex_fill_vht_cap_tlv(priv, vht_cap, bss_desc->bss_band);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 41f72c6..6f79bac 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -2072,12 +2072,12 @@ mwifiex_save_curr_bcn(struct mwifiex_private *priv)
 			 curr_bss->ht_info_offset);
 
 	if (curr_bss->bcn_vht_cap)
-		curr_bss->bcn_ht_cap = (void *)(curr_bss->beacon_buf +
-						curr_bss->vht_cap_offset);
+		curr_bss->bcn_vht_cap = (void *)(curr_bss->beacon_buf +
+						 curr_bss->vht_cap_offset);
 
 	if (curr_bss->bcn_vht_oper)
-		curr_bss->bcn_ht_oper = (void *)(curr_bss->beacon_buf +
-						 curr_bss->vht_info_offset);
+		curr_bss->bcn_vht_oper = (void *)(curr_bss->beacon_buf +
+						  curr_bss->vht_info_offset);
 
 	if (curr_bss->bcn_bss_co_2040)
 		curr_bss->bcn_bss_co_2040 =
-- 
1.9.1

