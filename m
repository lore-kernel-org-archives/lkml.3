Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab3CJNWn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:22:43 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:53080 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3CJNWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:22:42 -0400
From: Andrei Epure <epure.andrei@gmail.com>
To: johannes.berg@intel.com, wey-yi.w.guy@intel.com, ilw@linux.intel.com,
        linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrei Epure <epure.andrei@gmail.com>
Subject: [PATCH] wireless:iwlwifi: changed kmalloc+memcpy with kmemdup
Date: Sun, 10 Mar 2013 15:22:33 +0200
Message-Id: <1362921753-9554-1-git-send-email-epure.andrei@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl-test.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-test.c b/drivers/net/wireless/iwlwifi/iwl-test.c
index ce0c67b..9bc402c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-test.c
+++ b/drivers/net/wireless/iwlwifi/iwl-test.c
@@ -271,7 +271,7 @@ static int iwl_test_fw_cmd(struct iwl_test *tst, struct nlattr **tb)
 
 	reply_len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
 	skb = iwl_test_alloc_reply(tst, reply_len + 20);
-	reply_buf = kmalloc(reply_len, GFP_KERNEL);
+	reply_buf = kmemdup(&(pkt->hdr), reply_len, GFP_KERNEL);
 	if (!skb || !reply_buf) {
 		kfree_skb(skb);
 		kfree(reply_buf);
@@ -279,7 +279,6 @@ static int iwl_test_fw_cmd(struct iwl_test *tst, struct nlattr **tb)
 	}
 
 	/* The reply is in a page, that we cannot send to user space. */
-	memcpy(reply_buf, &(pkt->hdr), reply_len);
 	iwl_free_resp(&cmd);
 
 	if (nla_put_u32(skb, IWL_TM_ATTR_COMMAND,
-- 
1.7.10.4

