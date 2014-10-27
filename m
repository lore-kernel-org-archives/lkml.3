Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaJ0T1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:27:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52423 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbaJ0S5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:57:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xuelin Shi <xuelin.shi@freescale.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 002/105] dmaengine: fix xor sources continuation
Date: Mon, 27 Oct 2014 11:55:37 -0700
Message-Id: <1414436240-13879-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuelin Shi <xuelin.shi@freescale.com>

commit 87cea76384257e6ac3fa4791b6a6b9d0335f7457 upstream.

the partial xor result must be kept until the next
tx is generated.

Signed-off-by: Xuelin Shi <xuelin.shi@freescale.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 crypto/async_tx/async_xor.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 3c562f5..e1bce26 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -78,8 +78,6 @@ do_async_xor(struct dma_chan *chan, struct dmaengine_unmap_data *unmap,
 		tx = dma->device_prep_dma_xor(chan, dma_dest, src_list,
 					      xor_src_cnt, unmap->len,
 					      dma_flags);
-		src_list[0] = tmp;
-
 
 		if (unlikely(!tx))
 			async_tx_quiesce(&submit->depend_tx);
@@ -92,6 +90,7 @@ do_async_xor(struct dma_chan *chan, struct dmaengine_unmap_data *unmap,
 						      xor_src_cnt, unmap->len,
 						      dma_flags);
 		}
+		src_list[0] = tmp;
 
 		dma_set_unmap(tx, unmap);
 		async_tx_submit(chan, tx, submit);
-- 
1.9.1

