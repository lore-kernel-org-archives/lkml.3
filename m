Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaEVQxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:53:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48890 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752912AbaEVQsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:48:21 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>,
        Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH v2 09/18] m32r: io: implement dummy relaxed accessor macros for writes
Date: Thu, 22 May 2014 17:47:21 +0100
Message-Id: <1400777250-17335-10-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write{b,w,l}_relaxed are implemented by some architectures in order to
permit memory-mapped I/O accesses with weaker barrier semantics than the
non-relaxed variants.

This patch adds dummy macros for the write accessors to m32r, in the
same vein as the dummy definitions for the relaxed read accessors.

Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/m32r/include/asm/io.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/m32r/include/asm/io.h b/arch/m32r/include/asm/io.h
index 4010f1fc5b65..6e7787f3dac7 100644
--- a/arch/m32r/include/asm/io.h
+++ b/arch/m32r/include/asm/io.h
@@ -161,6 +161,9 @@ static inline void _writel(unsigned long l, unsigned long addr)
 #define __raw_writeb writeb
 #define __raw_writew writew
 #define __raw_writel writel
+#define writeb_relaxed writeb
+#define writew_relaxed writew
+#define writel_relaxed writel
 
 #define ioread8 read
 #define ioread16 readw
-- 
1.9.2

