Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934739Ab3DGX3r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:29:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46706 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934558Ab3DGX3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:29:45 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Lars-Peter Clausen" <lars@metafoo.de>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.251587312@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [25/74] ASoC: dma-sh7760: Fix compile error
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/sh/dma-sh7760.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sh/dma-sh7760.c b/sound/soc/sh/dma-sh7760.c
index 19eff8f..1a8b03e 100644
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

