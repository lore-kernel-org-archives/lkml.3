Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966595Ab3DRJlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:41:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39981 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab3DRJRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 02/72] ASoC: dma-sh7760: Fix compile error
Date: Thu, 18 Apr 2013 10:15:47 +0100
Message-Id: <1366276617-3553-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 417a1178f1bf3cdc606376b3ded3a22489fbb3eb upstream.

The dma-sh7760 currently fails with the following compile error:
	sound/soc/sh/dma-sh7760.c:346:2: error: unknown field 'pcm_ops' specified in initializer
	sound/soc/sh/dma-sh7760.c:346:2: warning: initialization from incompatible pointer type
	sound/soc/sh/dma-sh7760.c:347:2: error: unknown field 'pcm_new' specified in initializer
	sound/soc/sh/dma-sh7760.c:347:2: warning: initialization makes integer from pointer without a cast
	sound/soc/sh/dma-sh7760.c:348:2: error: unknown field 'pcm_free' specified in initializer
	sound/soc/sh/dma-sh7760.c:348:2: warning: initialization from incompatible pointer type
	sound/soc/sh/dma-sh7760.c: In function 'sh7760_soc_platform_probe':
	sound/soc/sh/dma-sh7760.c:353:2: warning: passing argument 2 of 'snd_soc_register_platform' from incompatible pointer type
	include/sound/soc.h:368:5: note: expected 'struct snd_soc_platform_driver *' but argument is of type 'struct snd_soc_platform *'

This is due the misnaming of the snd_soc_platform_driver type name and 'ops'
field. The issue was introduced in commit f0fba2a("ASoC: multi-component - ASoC
Multi-Component Support").

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/sh/dma-sh7760.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sh/dma-sh7760.c b/sound/soc/sh/dma-sh7760.c
index 7da2018..312715f 100644
--- a/sound/soc/sh/dma-sh7760.c
+++ b/sound/soc/sh/dma-sh7760.c
@@ -342,8 +342,8 @@ static int camelot_pcm_new(struct snd_soc_pcm_runtime *rtd)
 	return 0;
 }
 
-static struct snd_soc_platform sh7760_soc_platform = {
-	.pcm_ops 	= &camelot_pcm_ops,
+static struct snd_soc_platform_driver sh7760_soc_platform = {
+	.ops		= &camelot_pcm_ops,
 	.pcm_new	= camelot_pcm_new,
 	.pcm_free	= camelot_pcm_free,
 };
-- 
1.8.1.2

