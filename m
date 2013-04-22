Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab3DVFKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 01:10:46 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:42737 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab3DVFKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 01:10:44 -0400
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [RFC/PATCH 4/4] s390: Provide default implementation for dma_{alloc,free}_attrs
Date: Mon, 22 Apr 2013 14:10:31 +0900
Message-Id: <1366607431-3156-1-git-send-email-dhobsong@igel.co.jp>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most architectures that define CONFIG_HAVE_DMA, have implementations for
both dma_alloc_attrs() and dma_free_attrs().  All achitectures that do
not define CONFIG_HAVE_DMA also have both of these definitions provided by
dma-mapping-broken.h.

Add default implementations for these functions on s390.

Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
---
 arch/s390/include/asm/dma-mapping.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/s390/include/asm/dma-mapping.h b/arch/s390/include/asm/dma-mapping.h
index 9411db65..91f7312 100644
--- a/arch/s390/include/asm/dma-mapping.h
+++ b/arch/s390/include/asm/dma-mapping.h
@@ -55,6 +55,9 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 	return (dma_addr == 0UL);
 }
 
+#define dma_alloc_attrs(d, s, h, f, a) dma_alloc_coherent(d, s, h, f)
+#define dma_free_attrs(d, s, h, f, a) dma_free_coherent(d, s, h, f)
+
 static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t flag)
 {
-- 
1.7.5.4

