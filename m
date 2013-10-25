Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab3JYLGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:06:17 -0400
Received: from smtp.citrix.com ([66.165.176.89]:36184 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684Ab3JYLGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:06:14 -0400
X-IronPort-AV: E=Sophos;i="4.93,569,1378857600"; 
   d="scan'208";a="67327397"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>, Julien Grall <julien.grall@linaro.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v9 14/18] ASoC: Samsung: Rename dma_ops by samsung_dma_ops
Date: Fri, 25 Oct 2013 11:51:49 +0100
Message-ID: <1382698313-13161-14-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
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
index 9338d11..2c0bed4 100644
--- a/sound/soc/samsung/dma.c
+++ b/sound/soc/samsung/dma.c
@@ -352,7 +352,7 @@ static int dma_mmap(struct snd_pcm_substream *substream,
 				     runtime->dma_bytes);
 }
 
-static struct snd_pcm_ops dma_ops = {
+static struct snd_pcm_ops samsung_dma_ops = {
 	.open		= dma_open,
 	.close		= dma_close,
 	.ioctl		= snd_pcm_lib_ioctl,
@@ -439,7 +439,7 @@ out:
 }
 
 static struct snd_soc_platform_driver samsung_asoc_platform = {
-	.ops		= &dma_ops,
+	.ops		= &samsung_dma_ops,
 	.pcm_new	= dma_new,
 	.pcm_free	= dma_free_dma_buffers,
 };
-- 
1.7.2.5

