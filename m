Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742AbaD2LUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:20:39 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52974 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933717AbaD2LUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:20:34 -0400
From: Xia Kaixu <kaixu.xia@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, arnd@arndb.de, kaixu.xia@linaro.org,
        Liam Girdwood <lgirdwood@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org
Subject: [PATCH 15/15] ASoC: pxa: remove mach header dependency
Date: Tue, 29 Apr 2014 19:18:36 +0800
Message-Id: <1398770316-19715-16-git-send-email-kaixu.xia@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

As we are moving the mmp platform towards multiplatform support,
we have to stop including platform header files.

This changes the pxa-ssp sound driver file to no longer depend
on mach/hardware.h and mach/dma.h. The code using the definitions
from those headers is actually gone already, the only thing
that was still being used was the pxa_dma_desc typedef, which
we can easily work around by using the normal 'struct pxa_dma_desc'
name.

The pxa2xx-dma driver still uses this header, so we include it
explicitly there, which is ok because that is only used on pxa,
not on mmp.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Xia Kaixu <kaixu.xia@linaro.org>
Cc: Mark Brown <broonie@kernel.org> 
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: alsa-devel@alsa-project.org
---
 sound/arm/pxa2xx-pcm.c     |    2 ++
 sound/arm/pxa2xx-pcm.h     |    3 +--
 sound/soc/pxa/pxa-ssp.c    |    2 --
 sound/soc/pxa/pxa2xx-pcm.c |    2 ++
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/sound/arm/pxa2xx-pcm.c b/sound/arm/pxa2xx-pcm.c
index e6c727b..83be8e3 100644
--- a/sound/arm/pxa2xx-pcm.c
+++ b/sound/arm/pxa2xx-pcm.c
@@ -14,6 +14,8 @@
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 
+#include <mach/dma.h>
+
 #include <sound/core.h>
 #include <sound/pxa2xx-lib.h>
 #include <sound/dmaengine_pcm.h>
diff --git a/sound/arm/pxa2xx-pcm.h b/sound/arm/pxa2xx-pcm.h
index 2a8fc08..0033098 100644
--- a/sound/arm/pxa2xx-pcm.h
+++ b/sound/arm/pxa2xx-pcm.h
@@ -9,12 +9,11 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#include <mach/dma.h>
 
 struct pxa2xx_runtime_data {
 	int dma_ch;
 	struct snd_dmaengine_dai_dma_data *params;
-	pxa_dma_desc *dma_desc_array;
+	struct pxa_dma_desc *dma_desc_array;
 	dma_addr_t dma_desc_array_phys;
 };
 
diff --git a/sound/soc/pxa/pxa-ssp.c b/sound/soc/pxa/pxa-ssp.c
index a3119a0..9b19ee7 100644
--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@ -34,8 +34,6 @@
 #include <sound/pxa2xx-lib.h>
 #include <sound/dmaengine_pcm.h>
 
-#include <mach/hardware.h>
-
 #include "../../arm/pxa2xx-pcm.h"
 #include "pxa-ssp.h"
 
diff --git a/sound/soc/pxa/pxa2xx-pcm.c b/sound/soc/pxa/pxa2xx-pcm.c
index d58b09f..42f2f01 100644
--- a/sound/soc/pxa/pxa2xx-pcm.c
+++ b/sound/soc/pxa/pxa2xx-pcm.c
@@ -15,6 +15,8 @@
 #include <linux/dmaengine.h>
 #include <linux/of.h>
 
+#include <mach/dma.h>
+
 #include <sound/core.h>
 #include <sound/soc.h>
 #include <sound/pxa2xx-lib.h>
-- 
1.7.9.5

