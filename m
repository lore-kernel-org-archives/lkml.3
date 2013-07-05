Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750Ab3GEPps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 11:45:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51919 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab3GEPpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 11:45:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: alsa-devel@alsa-project.org
Subject: [PATCH] ASoC: Allow imx-pcm-{dma,fiq}.c to be modules
Date: Fri, 5 Jul 2013 17:45:15 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307051745.16140.arnd@arndb.de>
X-Provags-ID: V02:K0:HFVCVmHAPS86pQlW0DpzR7/bUo1PEDu29ffAnQYgbNG
 s8+DRV6nyXcIQb9yNt4p1+o40fSEoPOACv8WFZ5vtfoQ9TV8on
 4FlBrBbg3BWbKKRDhEcRPqJ7XYPFik9N8hmf6QPkwxNtZvhRg8
 UqLYH1R3hYZaiYQP8idPXNv3Zk2FZhXptfYVG994KyMPzdyp1S
 m+8FyuaA2LlShirh6PiH8X36xZA5gUKv/Po5mjApDE5w6AB3ax
 ZTvCst8UrOR07lmcHUhKpnb1odUvqn0sDPOQMe2LOjJBnIzpDJ
 GFbv9BqoWYHiuat1hAHFbDFQ1RrCUYl18etqBYnnxr4ene0yTl
 QQMp+kRpxU12k+ARKSVQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so we can build the imx sound support
when ALSA itself is a loadable module.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@kernel.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index aa43854..805b83e 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -109,11 +109,11 @@ config SND_SOC_IMX_SSI
 	tristate
 
 config SND_SOC_IMX_PCM_FIQ
-	bool
+	tristate
 	select FIQ
 
 config SND_SOC_IMX_PCM_DMA
-	bool
+	tristate
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 
 config SND_SOC_IMX_AUDMUX
diff --git a/sound/soc/fsl/imx-pcm.h b/sound/soc/fsl/imx-pcm.h
index 67f656c..0e3619e 100644
--- a/sound/soc/fsl/imx-pcm.h
+++ b/sound/soc/fsl/imx-pcm.h
@@ -32,7 +32,7 @@ imx_pcm_dma_params_init_data(struct imx_dma_data *dma_data,
 		dma_data->peripheral_type = IMX_DMATYPE_SSI;
 }
 
-#ifdef CONFIG_SND_SOC_IMX_PCM_DMA
+#if IS_ENABLED(CONFIG_SND_SOC_IMX_PCM_DMA)
 int imx_pcm_dma_init(struct platform_device *pdev);
 void imx_pcm_dma_exit(struct platform_device *pdev);
 #else
@@ -46,7 +46,7 @@ static inline void imx_pcm_dma_exit(struct platform_device *pdev)
 }
 #endif
 
-#ifdef CONFIG_SND_SOC_IMX_PCM_FIQ
+#if IS_ENABLED(CONFIG_SND_SOC_IMX_PCM_FIQ)
 int imx_pcm_fiq_init(struct platform_device *pdev);
 void imx_pcm_fiq_exit(struct platform_device *pdev);
 #else
