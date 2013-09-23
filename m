Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab3IWXGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 19:06:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49905 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab3IWXGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 19:06:08 -0400
From: Joel Fernandes <joelf@ti.com>
To: Matt Porter <matt@ohporter.com>, Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <djbw@fb.com>, Jyri Sarha <jsarha@ti.com>,
        Lars Peter-Clausen <lars@metafoo.de>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH 3/3] dma: edma: Increase maximum SG limit to 20
Date: Mon, 23 Sep 2013 18:05:15 -0500
Message-ID: <1379977515-3794-4-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379977515-3794-1-git-send-email-joelf@ti.com>
References: <1379977515-3794-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

davinci-pcm uses 16 as the no.of periods. With this, in EDMA we have to
allocate atleast 17 slots: 1 slot for channel, and 16 slots the periods.

Due to this, the MAX_NR_SG limitation causes problems, set it to 20 to make
cyclic DMA work when davinci-pcm is converted to use DMA Engine. Also add
a comment clarifying this.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 9b63e1e..407b496 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -46,8 +46,14 @@
 #define EDMA_CHANS	64
 #endif /* CONFIG_ARCH_DAVINCI_DA8XX */
 
-/* Max of 16 segments per channel to conserve PaRAM slots */
-#define MAX_NR_SG		16
+/*
+ * Max of 20 segments per channel to conserve PaRAM slots
+ * Also note that MAX_NR_SG should be atleast the no.of periods
+ * that are required for ASoC, otherwise DMA prep calls will
+ * fail. Today davinci-pcm is the only user of this driver and
+ * requires atleast 17 slots, so we setup the default to 20.
+ */
+#define MAX_NR_SG		20
 #define EDMA_MAX_SLOTS		MAX_NR_SG
 #define EDMA_DESCRIPTORS	16
 
-- 
1.8.1.2

