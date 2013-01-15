Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab3AOAUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:20:05 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:34381 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab3AOAUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:20:04 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] dma: remove unnecessary null pointer check in mmp_pdma.c
Date: Tue, 15 Jan 2013 01:19:48 +0100
Message-Id: <1358209188-16350-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the pointer cfg is dereferenced in line 594, so it's no reason to check null
again in line 620.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/dma/mmp_pdma.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index c6d98c0..81d7b89 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -617,10 +617,8 @@ static int mmp_pdma_control(struct dma_chan *dchan, enum dma_ctrl_cmd cmd,
 		else if (maxburst == 32)
 			chan->dcmd |= DCMD_BURST32;
 
-		if (cfg) {
-			chan->dir = cfg->direction;
-			chan->drcmr = cfg->slave_id;
-		}
+		chan->dir = cfg->direction;
+		chan->drcmr = cfg->slave_id;
 		chan->dev_addr = addr;
 		break;
 	default:
-- 
1.7.10.4

