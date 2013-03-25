Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab3CYNWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 09:22:22 -0400
Received: from smtp-out-223.synserver.de ([212.40.185.223]:1097 "EHLO
	smtp-out-223.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757774Ab3CYNWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 09:22:21 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 32637
From: Lars-Peter Clausen <lars@metafoo.de>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Cc: Jon Hunter <jon-hunter@ti.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] dma: of: Remove unnecessary list_empty check
Date: Mon, 25 Mar 2013 14:24:22 +0100
Message-Id: <1364217862-32677-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

list_for_each_entry is able to handle empty lists just fine, there is no need
to make sure that the list is non empty.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/dma/of-dma.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index 7cad4d7..6679020 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -36,11 +36,6 @@ static struct of_dma *of_dma_get_controller(struct of_phandle_args *dma_spec)
 
 	spin_lock(&of_dma_lock);
 
-	if (list_empty(&of_dma_list)) {
-		spin_unlock(&of_dma_lock);
-		return NULL;
-	}
-
 	list_for_each_entry(ofdma, &of_dma_list, of_dma_controllers)
 		if ((ofdma->of_node == dma_spec->np) &&
 		    (ofdma->of_dma_nbcells == dma_spec->args_count)) {
-- 
1.8.0

