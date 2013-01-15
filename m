Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab3AOAYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:24:13 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:57386 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab3AOAYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:24:08 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] dma: sh/shdma-base.c: remove unnecessary null pointer check
Date: Tue, 15 Jan 2013 01:23:48 +0100
Message-Id: <1358209435-16429-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the variable chan is dereferenced in line 635, so it is no reason to check
null again in line 641.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/dma/sh/shdma-base.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
index f4cd946..4acb85a 100644
--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -638,9 +638,6 @@ static int shdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	unsigned long flags;
 	int ret;
 
-	if (!chan)
-		return -EINVAL;
-
 	switch (cmd) {
 	case DMA_TERMINATE_ALL:
 		spin_lock_irqsave(&schan->chan_lock, flags);
-- 
1.7.10.4

