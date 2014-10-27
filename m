Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaJ0FZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:25:37 -0400
Received: from smtprelay0025.hostedemail.com ([216.40.44.25]:45884 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752778AbaJ0FZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:25:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3351:3865:3866:3867:3868:3871:4321:5007:6261:10004:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357:14096:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: copy63_4d8b01455692d
X-Filterd-Recvd-Size: 1899
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 07/11] iwlwifi: dvm: Fix probable mask then right shift defect
Date: Sun, 26 Oct 2014 22:25:03 -0700
Message-Id: <83c3bfdd0c8f21fbbcbd9ebb5746a8fb04494fac.1414387334.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1414387334.git.joe@perches.com>
References: <cover.1414387334.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Precedence of & and >> is not the same and is not left to right.
shift has higher precedence and should be done after the mask.

Add parentheses around the mask.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/iwlwifi/dvm/lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/lib.c b/drivers/net/wireless/iwlwifi/dvm/lib.c
index 2191621..02e4ede 100644
--- a/drivers/net/wireless/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/lib.c
@@ -418,8 +418,8 @@ void iwlagn_bt_adjust_rssi_monitor(struct iwl_priv *priv, bool rssi_ena)
 
 static bool iwlagn_bt_traffic_is_sco(struct iwl_bt_uart_msg *uart_msg)
 {
-	return BT_UART_MSG_FRAME3SCOESCO_MSK & uart_msg->frame3 >>
-			BT_UART_MSG_FRAME3SCOESCO_POS;
+	return (BT_UART_MSG_FRAME3SCOESCO_MSK & uart_msg->frame3) >>
+		BT_UART_MSG_FRAME3SCOESCO_POS;
 }
 
 static void iwlagn_bt_traffic_change_work(struct work_struct *work)
-- 
2.1.2

