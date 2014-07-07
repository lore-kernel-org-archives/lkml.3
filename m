Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbaGGIt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:49:59 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41495 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaGGIt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:49:56 -0400
Message-ID: <53BA5F14.4050708@gmail.com>
Date: Mon, 07 Jul 2014 16:49:24 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, john.stultz@linaro.org,
        ccross@android.com, rebecca@android.com,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
CC: devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers: staging: android: ion: Kconfig: Let it also depend
 on HAS_DMA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ION need HAS_DMA (e.g. need DMA_SHARED_BUFFER), so it has to depend on
HAS_DMA, or can not pass compiling with allmodconfig under score which
NO_DMA.  And the related error:

    CC      drivers/staging/android/ion/ion_cma_heap.o
  drivers/staging/android/ion/ion_cma_heap.c: In function 'ion_cma_mmap':
  drivers/staging/android/ion/ion_cma_heap.c:168:2: error: implicit declaration of function 'dma_mmap_coherent' [-Werror=implicit-function-declaration]
    return dma_mmap_coherent(dev, vma, info->cpu_addr, info->handle,
    ^
  cc1: some warnings being treated as errors
  make[4]: *** [drivers/staging/android/ion/ion_cma_heap.o] Error 1
  make[3]: *** [drivers/staging/android/ion] Error 2
  make[2]: *** [drivers/staging/android] Error 2
  make[1]: *** [drivers/staging] Error 2
  make: *** [drivers] Error 2


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/staging/android/ion/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/Kconfig b/drivers/staging/android/ion/Kconfig
index 0f8fec1..0a6e4d0 100644
--- a/drivers/staging/android/ion/Kconfig
+++ b/drivers/staging/android/ion/Kconfig
@@ -1,6 +1,6 @@
 menuconfig ION
 	bool "Ion Memory Manager"
-	depends on HAVE_MEMBLOCK
+	depends on HAVE_MEMBLOCK && HAS_DMA
 	select GENERIC_ALLOCATOR
 	select DMA_SHARED_BUFFER
 	---help---
-- 
1.9.2.459.g68773ac
