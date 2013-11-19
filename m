Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab3KSEzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 23:55:18 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:54747 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3KSEzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 23:55:16 -0500
Message-ID: <528AEFB7.4060301@gmail.com>
Date: Tue, 19 Nov 2013 12:57:27 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Kuo <rkuo@codeaurora.org>
CC: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: hexagon: Kconfig: add HAVE_DMA_ATTR in Kconfig and
 remove "linux/dma-mapping.h" from "asm/dma-mapping.h"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When HAS_DMA, and also need use generic implementation, HAVE_DMA_ATTR
must be enabled, or can not pass compiling with allmodconfig, the
related error:

    CC [M]  drivers/ata/libata-core.o
  drivers/ata/libata-core.c: In function 'ata_sg_clean':
  drivers/ata/libata-core.c:4598:3: error: implicit declaration of function 'dma_unmap_sg' [-Werror=implicit-function-declaration]
  drivers/ata/libata-core.c: In function 'ata_sg_setup':
  drivers/ata/libata-core.c:4708:2: error: implicit declaration of function 'dma_map_sg' [-Werror=implicit-function-declaration]

"linux/dma-mapping.h" will include "asm/dma-mapping.h", so need remove
"linux/dma-mapping.h" from "asm/dma-mapping.h",


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/hexagon/Kconfig                   |    1 +
 arch/hexagon/include/asm/dma-mapping.h |    1 -
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 09df260..fbc5c78 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -28,6 +28,7 @@ config HEXAGON
 	select GENERIC_CLOCKEVENTS_BROADCAST
 	select MODULES_USE_ELF_RELA
 	select GENERIC_CPU_DEVICES
+	select HAVE_DMA_ATTRS
 	---help---
 	  Qualcomm Hexagon is a processor architecture designed for high
 	  performance and low power across a wide variety of applications.
diff --git a/arch/hexagon/include/asm/dma-mapping.h b/arch/hexagon/include/asm/dma-mapping.h
index 85e9935..1696542 100644
--- a/arch/hexagon/include/asm/dma-mapping.h
+++ b/arch/hexagon/include/asm/dma-mapping.h
@@ -25,7 +25,6 @@
 #include <linux/cache.h>
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
-#include <linux/dma-mapping.h>
 #include <linux/dma-debug.h>
 #include <linux/dma-attrs.h>
 #include <asm/io.h>
-- 
1.7.7.6
