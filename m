Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538Ab3CYPoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:44:44 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:64845 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758473Ab3CYPom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:44:42 -0400
From: Emil Goode <emilgoode@gmail.com>
To: josh.h.morris@us.ibm.com, pjk1939@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] block: remove unused variable
Date: Mon, 25 Mar 2013 16:48:21 +0100
Message-Id: <1364226501-28745-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct rsxx_dma pointer tmp is not used, we can remove it.
Introduced by: c95246c3a2ac
("Adding in EEH support to the IBM FlashSystem 70/80 device driver")

Sparse gives a warning:
drivers/block/rsxx/dma.c:1050:19: warning:
	unused variable ‘tmp’ [-Wunused-variable]

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/block/rsxx/dma.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/rsxx/dma.c b/drivers/block/rsxx/dma.c
index d523e9c..bacbaa0 100644
--- a/drivers/block/rsxx/dma.c
+++ b/drivers/block/rsxx/dma.c
@@ -1047,7 +1047,6 @@ void rsxx_eeh_cancel_dmas(struct rsxx_cardinfo *card)
 int rsxx_eeh_remap_dmas(struct rsxx_cardinfo *card)
 {
 	struct rsxx_dma *dma;
-	struct rsxx_dma *tmp;
 	int i;
 
 	for (i = 0; i < card->n_targets; i++) {
-- 
1.7.10.4

