Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab3DVFJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 01:09:24 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36097 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab3DVFJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 01:09:22 -0400
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
To: linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [RFC/PATCH 1/4] arm64: Provide default implementation for dma_{alloc,free}_attrs
Date: Mon, 22 Apr 2013 14:09:09 +0900
Message-Id: <1366607349-2992-1-git-send-email-dhobsong@igel.co.jp>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most architectures that define CONFIG_HAVE_DMA, have implementations for
both dma_alloc_attrs() and dma_free_attrs().  All achitectures that do
not define CONFIG_HAVE_DMA also have both of these definitions provided by
dma-mapping-broken.h.

Add default implementations for these functions on arm64.

Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
---
 arch/arm64/include/asm/dma-mapping.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
index 9947768..65ab181 100644
--- a/arch/arm64/include/asm/dma-mapping.h
+++ b/arch/arm64/include/asm/dma-mapping.h
@@ -81,6 +81,9 @@ static inline void dma_mark_clean(void *addr, size_t size)
 {
 }
 
+#define dma_alloc_attrs(d, s, h, f, a) dma_alloc_coherent(d, s, h, f)
+#define dma_free_attrs(d, s, h, f, a) dma_free_coherent(d, s, h, f)
+
 static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t flags)
 {
-- 
1.7.5.4

