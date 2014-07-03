Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaGCEw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 00:52:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35409 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbaGCEwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 00:52:17 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>, <lars@metafoo.de>,
        <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, <joelf@ti.com>, <nsekhar@ti.com>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <dmaengine@vger.kernel.org>
Subject: [PATCH v3 2/5] ALSA: pcm_dmaengine: Use the available wrapper to get physical width
Date: Thu, 3 Jul 2014 07:51:53 +0300
Message-ID: <1404363116-10538-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404363116-10538-1-git-send-email-peter.ujfalusi@ti.com>
References: <1404363116-10538-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

params_physical_width() is available via pcm_params.h

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/core/pcm_dmaengine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/pcm_dmaengine.c b/sound/core/pcm_dmaengine.c
index 76cbb9ec953a..d5611ec80381 100644
--- a/sound/core/pcm_dmaengine.c
+++ b/sound/core/pcm_dmaengine.c
@@ -65,7 +65,7 @@ int snd_hwparams_to_dma_slave_config(const struct snd_pcm_substream *substream,
 	enum dma_slave_buswidth buswidth;
 	int bits;
 
-	bits = snd_pcm_format_physical_width(params_format(params));
+	bits = params_physical_width(params);
 	if (bits < 8 || bits > 64)
 		return -EINVAL;
 	else if (bits == 8)
-- 
2.0.0

