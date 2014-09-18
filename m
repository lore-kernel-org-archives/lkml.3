Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307AbaIREc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 00:32:26 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:7569 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaIREcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 00:32:25 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <rdunlap@infradead.org>, <shuah.khan@hp.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <peifeiyue@huawei.com>
Subject: [PATCH] Documentation: correct parameter error for dma_mapping_error
Date: Thu, 18 Sep 2014 12:15:28 +0800
Message-ID: <1411013728-56125-1-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_mapping_error takes two parameters, but some of examples
in Documentation/DMA-API-HOWTO.txt just takes one. So correct
it.

Signed-off-by: Liu Hua <sdu.liu@huawei.com>
---
 Documentation/DMA-API-HOWTO.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
index dcbbe36..0f7afb2 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.txt
@@ -531,7 +531,7 @@ To map a single region, you do:
 	size_t size = buffer->len;
 
 	dma_handle = dma_map_single(dev, addr, size, direction);
-	if (dma_mapping_error(dma_handle)) {
+	if (dma_mapping_error(dev, dma_handle)) {
 		/*
 		 * reduce current DMA mapping usage,
 		 * delay and try again later or
@@ -588,7 +588,7 @@ Specifically:
 	size_t size = buffer->len;
 
 	dma_handle = dma_map_page(dev, page, offset, size, direction);
-	if (dma_mapping_error(dma_handle)) {
+	if (dma_mapping_error(dev, dma_handle)) {
 		/*
 		 * reduce current DMA mapping usage,
 		 * delay and try again later or
@@ -689,7 +689,7 @@ to use the dma_sync_*() interfaces.
 		dma_addr_t mapping;
 
 		mapping = dma_map_single(cp->dev, buffer, len, DMA_FROM_DEVICE);
-		if (dma_mapping_error(dma_handle)) {
+		if (dma_mapping_error(cp->dev, dma_handle)) {
 			/*
 			 * reduce current DMA mapping usage,
 			 * delay and try again later or
-- 
1.9.0

