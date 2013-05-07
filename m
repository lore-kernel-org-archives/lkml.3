Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab3EGENp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:13:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3816 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895Ab3EGD6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:45 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=DUz5HRYRsLUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=6RwFZMxEJcQA:10 a=wggVRkVUAAAA:8 a=VwQbUJbxAAAA:8 a=UOpjjlpZozkG-P3uORQA:9 a=8NEP1B8RWw4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035841.232387752@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [002/126] ASoC: dma-sh7760: Fix compile error
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0002-ASoC-dma-sh7760-Fix-compile-error.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

[ Upstream commit 417a1178f1bf3cdc606376b3ded3a22489fbb3eb ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/soc/sh/dma-sh7760.c |    4 ++--
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
1.7.10.4


