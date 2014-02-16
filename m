Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaBPLjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 06:39:19 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:52168 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaBPLjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 06:39:18 -0500
Message-ID: <5300A372.1050501@gmail.com>
Date: Sun, 16 Feb 2014 19:39:30 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
CC: Andrew Morton <akpm@linux-foundation.org>, havard@skinnemoen.net,
        josh.wu@atmel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: avr32: include: asm: add generic ioremap_wc() definition
 in "io.h"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need generic ioremap_wc(), or can not pass compiling with allmodconfig,
the related error:

    CC [M]  drivers/gpu/drm/drm_bufs.o
  drivers/gpu/drm/drm_bufs.c: In function 'drm_addmap_core':
  drivers/gpu/drm/drm_bufs.c:217: error: implicit declaration of function 'ioremap_wc'
  drivers/gpu/drm/drm_bufs.c:218: warning: assignment makes pointer from integer without a cast


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/avr32/include/asm/io.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/avr32/include/asm/io.h b/arch/avr32/include/asm/io.h
index fc6483f..4f5ec2b 100644
--- a/arch/avr32/include/asm/io.h
+++ b/arch/avr32/include/asm/io.h
@@ -295,6 +295,8 @@ extern void __iounmap(void __iomem *addr);
 #define iounmap(addr)				\
 	__iounmap(addr)
 
+#define ioremap_wc ioremap_nocache
+
 #define cached(addr) P1SEGADDR(addr)
 #define uncached(addr) P2SEGADDR(addr)
 
-- 
1.7.11.7
