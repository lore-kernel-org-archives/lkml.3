Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569Ab3E1Bhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 21:37:46 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:33817 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758444Ab3E1Bhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 21:37:45 -0400
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
To: linux-kernel@vger.kernel.org
Cc: msalter@redhat.com, linux-c6x-dev@linux-c6x.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH v3 2/3] c6x: Provide default implementation for dma_{alloc,free}_attrs
Date: Tue, 28 May 2013 10:37:36 +0900
Message-Id: <1369705056-16384-1-git-send-email-dhobsong@igel.co.jp>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most architectures that define CONFIG_HAS_DMA, have implementations for
both dma_alloc_attrs() and dma_free_attrs().  All achitectures that do
not define CONFIG_HAS_DMA also have both of these definitions provided by
dma-mapping-broken.h.

Add default implementations for these functions on c6x.

Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
Acked-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/include/asm/dma-mapping.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/c6x/include/asm/dma-mapping.h b/arch/c6x/include/asm/dma-mapping.h
index 88bd0d8..8947605 100644
--- a/arch/c6x/include/asm/dma-mapping.h
+++ b/arch/c6x/include/asm/dma-mapping.h
@@ -89,6 +89,9 @@ extern void dma_free_coherent(struct device *, size_t, void *, dma_addr_t);
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent((d), (s), (h), (f))
 #define dma_free_noncoherent(d, s, v, h)  dma_free_coherent((d), (s), (v), (h))
 
+#define dma_alloc_attrs(d, s, h, f, a) dma_alloc_coherent(d, s, h, f)
+#define dma_free_attrs(d, s, h, f, a) dma_free_coherent(d, s, h, f)
+
 /* Not supported for now */
 static inline int dma_mmap_coherent(struct device *dev,
 				    struct vm_area_struct *vma, void *cpu_addr,
-- 
1.7.5.4

