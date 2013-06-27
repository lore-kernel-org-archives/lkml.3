Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab3F0EiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 00:38:21 -0400
Received: from intranet.asianux.com ([58.214.24.6]:44032 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3F0EiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 00:38:20 -0400
X-Spam-Score: -100.9
Message-ID: <51CBC186.3080401@asianux.com>
Date: Thu, 27 Jun 2013 12:37:26 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hirokazu Takata <takata@linux-m32r.org>
CC: linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: m32r: include: asm: add ioread*_rep() and iowrite*_rep()
References: <51CBA43F.9050000@asianux.com> <51CBAA1E.8000206@asianux.com> <51CBB1A9.5080203@asianux.com>
In-Reply-To: <51CBB1A9.5080203@asianux.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add generic ioread*_rep() and iowrite*_rep(), or compiling failed.

The related error (with allmodconfig):

    CC [M]  drivers/mtd/nand/nand_base.o
  drivers/mtd/nand/nand_base.c: In function ‘nand_write_buf’:
  drivers/mtd/nand/nand_base.c:216:2: error: implicit declaration of function ‘iowrite8_rep’ [-Werror=implicit-function-declaration]
  drivers/mtd/nand/nand_base.c: In function ‘nand_read_buf’:
  drivers/mtd/nand/nand_base.c:231:2: error: implicit declaration of function ‘ioread8_rep’ [-Werror=implicit-function-declaration]
  drivers/mtd/nand/nand_base.c: In function ‘nand_write_buf16’:
  drivers/mtd/nand/nand_base.c:247:2: error: implicit declaration of function ‘iowrite16_rep’ [-Werror=implicit-function-declaration]
  drivers/mtd/nand/nand_base.c: In function ‘nand_read_buf16’:
  drivers/mtd/nand/nand_base.c:263:2: error: implicit declaration of function ‘ioread16_rep’ [-Werror=implicit-function-declaration]


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/m32r/include/asm/io.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/m32r/include/asm/io.h b/arch/m32r/include/asm/io.h
index 4010f1f..167d6ed 100644
--- a/arch/m32r/include/asm/io.h
+++ b/arch/m32r/include/asm/io.h
@@ -169,6 +169,20 @@ static inline void _writel(unsigned long l, unsigned long addr)
 #define iowrite16 writew
 #define iowrite32 writel
 
+#define ioread8_rep(p, dst, count) \
+	insb((unsigned long) (p), (dst), (count))
+#define ioread16_rep(p, dst, count) \
+	insw((unsigned long) (p), (dst), (count))
+#define ioread32_rep(p, dst, count) \
+	insl((unsigned long) (p), (dst), (count))
+
+#define iowrite8_rep(p, src, count) \
+	outsb((unsigned long) (p), (src), (count))
+#define iowrite16_rep(p, src, count) \
+	outsw((unsigned long) (p), (src), (count))
+#define iowrite32_rep(p, src, count) \
+	outsl((unsigned long) (p), (src), (count))
+
 #define mmiowb()
 
 #define flush_write_buffers() do { } while (0)  /* M32R_FIXME */
-- 
1.7.7.6
