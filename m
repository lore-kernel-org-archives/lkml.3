Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab3JQSEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 14:04:52 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:58564
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756787Ab3JQSEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 14:04:50 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: rob@landley.net
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH] Fix dma_mapping_error() parameters in the usage examples
Date: Thu, 17 Oct 2013 12:04:14 -0600
Message-Id: <1382033054-6723-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the dma_mapping_error() parameter list in the usage examples to add
the missing argument to struct device *.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 Documentation/DMA-API-HOWTO.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
index 14129f1..bb9feac 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.txt
@@ -468,7 +468,7 @@ To map a single region, you do:
 	size_t size = buffer->len;
 
 	dma_handle = dma_map_single(dev, addr, size, direction);
-	if (dma_mapping_error(dma_handle)) {
+	if (dma_mapping_error(dev, dma_handle)) {
 		/*
 		 * reduce current DMA mapping usage,
 		 * delay and try again later or
@@ -525,7 +525,7 @@ Specifically:
 	size_t size = buffer->len;
 
 	dma_handle = dma_map_page(dev, page, offset, size, direction);
-	if (dma_mapping_error(dma_handle)) {
+	if (dma_mapping_error(dev, dma_handle)) {
 		/*
 		 * reduce current DMA mapping usage,
 		 * delay and try again later or
@@ -628,7 +628,7 @@ to use the dma_sync_*() interfaces.
 		dma_addr_t mapping;
 
 		mapping = dma_map_single(cp->dev, buffer, len, DMA_FROM_DEVICE);
-		if (dma_mapping_error(dma_handle)) {
+		if (dma_mapping_error(dev, dma_handle)) {
 			/*
 			 * reduce current DMA mapping usage,
 			 * delay and try again later or
-- 
1.8.1.2

