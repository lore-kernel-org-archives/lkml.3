Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab3IYTip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:38:45 -0400
Received: from smtprelay0174.hostedemail.com ([216.40.44.174]:50112 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755426Ab3IYTil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:38:41 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:4321:4605:5007:6261:7903:10004:10026:10848:11026:11657:11658:11914:12043:12438:12517:12519:12555:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shake37_859e42f55f646
X-Filterd-Recvd-Size: 3432
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] mwifiex: Remove extern from function prototypes
Date: Wed, 25 Sep 2013 12:37:27 -0700
Message-Id: <b3a7cd194857b3dc099e8f8bb0ed97bb4a1b5fde.1380137610.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1380137609.git.joe@perches.com>
References: <cover.1380137609.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a mix of function prototypes with and without extern
in the kernel sources.  Standardize on not using extern for
function prototypes.

Function prototypes don't need to be written with extern.
extern is assumed by the compiler.  Its use is as unnecessary as
using auto to declare automatic/local variables in a block.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/mwifiex/wmm.h | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index 644d6e0..0f129d4 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -83,11 +83,10 @@ mwifiex_wmm_is_ra_list_empty(struct list_head *ra_list_hhead)
 }
 
 void mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
-					struct sk_buff *skb);
+				 struct sk_buff *skb);
 void mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra);
 void mwifiex_rotate_priolists(struct mwifiex_private *priv,
-			      struct mwifiex_ra_list_tbl *ra,
-			      int tid);
+			      struct mwifiex_ra_list_tbl *ra, int tid);
 
 int mwifiex_wmm_lists_empty(struct mwifiex_adapter *adapter);
 void mwifiex_wmm_process_tx(struct mwifiex_adapter *adapter);
@@ -95,21 +94,18 @@ int mwifiex_is_ralist_valid(struct mwifiex_private *priv,
 			    struct mwifiex_ra_list_tbl *ra_list, int tid);
 
 u8 mwifiex_wmm_compute_drv_pkt_delay(struct mwifiex_private *priv,
-					     const struct sk_buff *skb);
+				     const struct sk_buff *skb);
 void mwifiex_wmm_init(struct mwifiex_adapter *adapter);
 
-extern u32 mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
-						 u8 **assoc_buf,
-						 struct ieee_types_wmm_parameter
-						 *wmmie,
-						 struct ieee80211_ht_cap
-						 *htcap);
+u32 mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
+					u8 **assoc_buf,
+					struct ieee_types_wmm_parameter *wmmie,
+					struct ieee80211_ht_cap *htcap);
 
 void mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
-					struct ieee_types_wmm_parameter
-					*wmm_ie);
+					struct ieee_types_wmm_parameter *wmm_ie);
 void mwifiex_wmm_setup_ac_downgrade(struct mwifiex_private *priv);
-extern int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
-				      const struct host_cmd_ds_command *resp);
+int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
+			       const struct host_cmd_ds_command *resp);
 
 #endif /* !_MWIFIEX_WMM_H_ */
-- 
1.8.1.2.459.gbcd45b4.dirty

