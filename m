Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbaJ1HVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:21:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbaJ1Dn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:43:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xuelin Shi <xuelin.shi@freescale.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 3.16 033/127] dmaengine: fix xor sources continuation
Date: Tue, 28 Oct 2014 11:34:28 +0800
Message-Id: <20141028033422.370313590@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuelin Shi <xuelin.shi@freescale.com>

commit 87cea76384257e6ac3fa4791b6a6b9d0335f7457 upstream.

the partial xor result must be kept until the next
tx is generated.

Signed-off-by: Xuelin Shi <xuelin.shi@freescale.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/async_tx/async_xor.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -78,8 +78,6 @@ do_async_xor(struct dma_chan *chan, stru
 		tx = dma->device_prep_dma_xor(chan, dma_dest, src_list,
 					      xor_src_cnt, unmap->len,
 					      dma_flags);
-		src_list[0] = tmp;
-
 
 		if (unlikely(!tx))
 			async_tx_quiesce(&submit->depend_tx);
@@ -92,6 +90,7 @@ do_async_xor(struct dma_chan *chan, stru
 						      xor_src_cnt, unmap->len,
 						      dma_flags);
 		}
+		src_list[0] = tmp;
 
 		dma_set_unmap(tx, unmap);
 		async_tx_submit(chan, tx, submit);


