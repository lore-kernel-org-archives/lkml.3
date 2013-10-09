Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3JIVGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 17:06:04 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:4418 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127Ab3JIVGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 17:06:01 -0400
X-IronPort-AV: E=Sophos;i="4.90,1066,1371081600"; 
   d="scan'208";a="59435235"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>, Julien Grall <julien.grall@linaro.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v8 14/17] ASoC: Samsung: Rename dma_ops by samsung_dma_ops
Date: Wed, 9 Oct 2013 21:48:27 +0100
Message-ID: <1381351710-1876-14-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1310092109190.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310092109190.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julien Grall <julien.grall@linaro.org>

The commit "arm: introduce a global dma_ops pointer" introduce compilation issue
when CONFIG_SND_SOC_SAMSUNG is enabled.

sound/soc/samsung/dma.c:345:27: error: conflicting types for 'dma_ops'
/local/home/julien/works/arndale/linux/arch/arm/include/asm/dma-mapping.h:16:28:
note: previous declaration of 'dma_ops' was here

Signed-off-by: Julien Grall <julien.grall@linaro.org>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 sound/soc/samsung/dma.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/samsung/dma.c b/sound/soc/samsung/dma.c
index 21b7926..827c0d8 100644
--- a/sound/soc/samsung/dma.c
+++ b/sound/soc/samsung/dma.c
@@ -341,7 +341,7 @@ static int dma_mmap(struct snd_pcm_substream *substream,
 				     runtime->dma_bytes);
 }
 
-static struct snd_pcm_ops dma_ops = {
+static struct snd_pcm_ops samsung_dma_ops = {
 	.open		= dma_open,
 	.close		= dma_close,
 	.ioctl		= snd_pcm_lib_ioctl,
@@ -428,7 +428,7 @@ out:
 }
 
 static struct snd_soc_platform_driver samsung_asoc_platform = {
-	.ops		= &dma_ops,
+	.ops		= &samsung_dma_ops,
 	.pcm_new	= dma_new,
 	.pcm_free	= dma_free_dma_buffers,
 };
-- 
1.7.2.5

