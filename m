Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965893AbaCUAIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:08:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965868AbaCUAIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:08:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.10 27/85] mwifiex: save and copy APs VHT capability info correctly
Date: Thu, 20 Mar 2014 17:09:30 -0700
Message-Id: <20140321000602.506794753@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/11ac.c |    3 +--
 drivers/net/wireless/mwifiex/scan.c |    8 ++++----
 2 files changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/mwifiex/11ac.c
+++ b/drivers/net/wireless/mwifiex/11ac.c
@@ -189,8 +189,7 @@ int mwifiex_cmd_append_11ac_tlv(struct m
 		vht_cap->header.len  =
 				cpu_to_le16(sizeof(struct ieee80211_vht_cap));
 		memcpy((u8 *)vht_cap + sizeof(struct mwifiex_ie_types_header),
-		       (u8 *)bss_desc->bcn_vht_cap +
-		       sizeof(struct ieee_types_header),
+		       (u8 *)bss_desc->bcn_vht_cap,
 		       le16_to_cpu(vht_cap->header.len));
 
 		mwifiex_fill_vht_cap_tlv(priv, vht_cap, bss_desc->bss_band);
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -2040,12 +2040,12 @@ mwifiex_save_curr_bcn(struct mwifiex_pri
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


