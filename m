Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaERQAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 12:00:37 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:60077 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaERQAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 12:00:35 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        netdev@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: ibm: ehea: ehea_qmr.c:  Fix for possible null pointer dereference
Date: Sun, 18 May 2014 18:01:21 +0200
Message-Id: <1400428881-10310-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/ethernet/ibm/ehea/ehea_qmr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ehea/ehea_qmr.c b/drivers/net/ethernet/ibm/ehea/ehea_qmr.c
index 9b03033..a0820f7 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_qmr.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_qmr.c
@@ -103,12 +103,14 @@ out_nomem:
 
 static void hw_queue_dtor(struct hw_queue *queue)
 {
-	int pages_per_kpage = PAGE_SIZE / queue->pagesize;
+	int pages_per_kpage;
 	int i, nr_pages;
 
 	if (!queue || !queue->queue_pages)
 		return;
 
+	pages_per_kpage = PAGE_SIZE / queue->pagesize;
+
 	nr_pages = queue->queue_length / queue->pagesize;
 
 	for (i = 0; i < nr_pages; i += pages_per_kpage)
-- 
1.7.10.4

