Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaECBGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 21:06:41 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51587 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaECBGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 21:06:40 -0400
Message-ID: <53644114.9000201@gmail.com>
Date: Sat, 03 May 2014 09:06:28 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/unicore32/include/asm/io.h: add readl_relaxed() generic
 definition
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need generic definition for readl_relaxed(), like other architectures
have done. Or can not pass compiling with allmodconfig, the related
error:

    CC [M]  drivers/message/fusion/mptbase.o
  drivers/message/fusion/mptbase.c: In function ‘mpt_send_handshake_request’:
  drivers/message/fusion/mptbase.c:1224: error: implicit declaration of function ‘readl_relaxed’

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/unicore32/include/asm/io.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/unicore32/include/asm/io.h b/arch/unicore32/include/asm/io.h
index ae327e4..cb1d8fd 100644
--- a/arch/unicore32/include/asm/io.h
+++ b/arch/unicore32/include/asm/io.h
@@ -39,6 +39,10 @@ extern void __uc32_iounmap(volatile void __iomem *addr);
 #define ioremap_nocache(cookie, size)	__uc32_ioremap(cookie, size)
 #define iounmap(cookie)			__uc32_iounmap(cookie)
 
+#define readb_relaxed readb
+#define readw_relaxed readw
+#define readl_relaxed readl
+
 #define HAVE_ARCH_PIO_SIZE
 #define PIO_OFFSET		(unsigned int)(PCI_IOBASE)
 #define PIO_MASK		(unsigned int)(IO_SPACE_LIMIT)
-- 
1.9.2.459.g68773ac
