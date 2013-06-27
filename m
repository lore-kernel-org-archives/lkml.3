Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab3F0CdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 22:33:25 -0400
Received: from intranet.asianux.com ([58.214.24.6]:50926 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab3F0CdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 22:33:24 -0400
X-Spam-Score: -100.8
Message-ID: <51CBA43F.9050000@asianux.com>
Date: Thu, 27 Jun 2013 10:32:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hirokazu Takata <takata@linux-m32r.org>
CC: linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: m32r: include: asm: add generic ioremap_wc() definition
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generic ioremap_wc() definition, or compiling failed.

The related error (with allmodconfig):

  drivers/gpu/drm/drm_bufs.c: In function ‘drm_addmap_core’:
  drivers/gpu/drm/drm_bufs.c:219:5: error: implicit declaration of function ‘ioremap_wc’ [-Werror=implicit-function-declaration]
  drivers/gpu/drm/drm_bufs.c:219:17: warning: assignment makes pointer from integer without a cast [enabled by default]

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/m32r/include/asm/io.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/m32r/include/asm/io.h b/arch/m32r/include/asm/io.h
index 4010f1f..f9f4fb6 100644
--- a/arch/m32r/include/asm/io.h
+++ b/arch/m32r/include/asm/io.h
@@ -67,6 +67,7 @@ static inline void __iomem *ioremap(unsigned long offset, unsigned long size)
 
 extern void iounmap(volatile void __iomem *addr);
 #define ioremap_nocache(off,size) ioremap(off,size)
+#define ioremap_wc ioremap_nocache
 
 /*
  * IO bus memory addresses are also 1:1 with the physical address
-- 
1.7.7.6
