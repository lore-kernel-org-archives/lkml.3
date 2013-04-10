Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937238Ab3DJXTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:19:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936799Ab3DJWrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 02/64] ASoC: dma-sh7760: Fix compile error
Date: Wed, 10 Apr 2013 15:45:59 -0700
Message-Id: <20130410224333.671773142@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/sh/dma-sh7760.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/sh/dma-sh7760.c
+++ b/sound/soc/sh/dma-sh7760.c
@@ -342,8 +342,8 @@ static int camelot_pcm_new(struct snd_so
 	return 0;
 }
 
-static struct snd_soc_platform sh7760_soc_platform = {
-	.pcm_ops 	= &camelot_pcm_ops,
+static struct snd_soc_platform_driver sh7760_soc_platform = {
+	.ops		= &camelot_pcm_ops,
 	.pcm_new	= camelot_pcm_new,
 	.pcm_free	= camelot_pcm_free,
 };


