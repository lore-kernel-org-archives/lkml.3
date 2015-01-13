Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbbAMUBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:01:11 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:41049 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbbAMUBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:01:09 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rsxx: cregs: Remove unused function
Date: Tue, 13 Jan 2015 21:04:14 +0100
Message-Id: <1421179454-7754-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function rsxx_get_card_capabilities() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/block/rsxx/cregs.c     |    7 -------
 drivers/block/rsxx/rsxx_priv.h |    2 --
 2 files changed, 9 deletions(-)

diff --git a/drivers/block/rsxx/cregs.c b/drivers/block/rsxx/cregs.c
index 926dce9..4fe74f9 100644
--- a/drivers/block/rsxx/cregs.c
+++ b/drivers/block/rsxx/cregs.c
@@ -525,13 +525,6 @@ int rsxx_get_num_targets(struct rsxx_cardinfo *card,
 				  sizeof(*n_targets), n_targets, 0);
 }
 
-int rsxx_get_card_capabilities(struct rsxx_cardinfo *card,
-				   u32 *capabilities)
-{
-	return rsxx_creg_read(card, CREG_ADD_CAPABILITIES,
-				  sizeof(*capabilities), capabilities, 0);
-}
-
 int rsxx_issue_card_cmd(struct rsxx_cardinfo *card, u32 cmd)
 {
 	return rsxx_creg_write(card, CREG_ADD_CARD_CMD,
diff --git a/drivers/block/rsxx/rsxx_priv.h b/drivers/block/rsxx/rsxx_priv.h
index 6bbc64d..fdee897 100644
--- a/drivers/block/rsxx/rsxx_priv.h
+++ b/drivers/block/rsxx/rsxx_priv.h
@@ -416,8 +416,6 @@ int rsxx_get_card_state(struct rsxx_cardinfo *card,
 int rsxx_get_card_size8(struct rsxx_cardinfo *card, u64 *size8);
 int rsxx_get_num_targets(struct rsxx_cardinfo *card,
 			     unsigned int *n_targets);
-int rsxx_get_card_capabilities(struct rsxx_cardinfo *card,
-				   u32 *capabilities);
 int rsxx_issue_card_cmd(struct rsxx_cardinfo *card, u32 cmd);
 int rsxx_creg_setup(struct rsxx_cardinfo *card);
 void rsxx_creg_destroy(struct rsxx_cardinfo *card);
-- 
1.7.10.4

