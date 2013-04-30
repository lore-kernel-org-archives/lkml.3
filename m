Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521Ab3D3DDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 23:03:07 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:64245 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab3D3DDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 23:03:05 -0400
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
To: linux-kernel@vger.kernel.org
Cc: deller@gmx.de, linux-parisc@vger.kernel.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH v2 3/4] parisc: Provide default implementation for dma_{alloc,free}_attrs
Date: Tue, 30 Apr 2013 12:02:55 +0900
Message-Id: <1367290975-10539-1-git-send-email-dhobsong@igel.co.jp>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most architectures that define CONFIG_HAVE_DMA, have implementations for
both dma_alloc_attrs() and dma_free_attrs().  All achitectures that do
not define CONFIG_HAVE_DMA also have both of these definitions provided by
dma-mapping-broken.h.

Add default implementations for these functions on parisc.

Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
---
 arch/parisc/include/asm/dma-mapping.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/parisc/include/asm/dma-mapping.h b/arch/parisc/include/asm/dma-mapping.h
index 106b395..d0eae5f 100644
--- a/arch/parisc/include/asm/dma-mapping.h
+++ b/arch/parisc/include/asm/dma-mapping.h
@@ -46,6 +46,9 @@ extern struct hppa_dma_ops pcx_dma_ops;
 
 extern struct hppa_dma_ops *hppa_dma_ops;
 
+#define dma_alloc_attrs(d, s, h, f, a) dma_alloc_coherent(d, s, h, f)
+#define dma_free_attrs(d, s, h, f, a) dma_free_coherent(d, s, h, f)
+
 static inline void *
 dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		   gfp_t flag)
-- 
1.7.5.4

