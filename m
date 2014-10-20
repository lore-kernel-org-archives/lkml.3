Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaJTTh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:37:57 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:64481 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaJTThy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:37:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Srikanth Thokala <sthokal@xilinx.com>, vinod.koul@intel.com,
        dan.j.williams@intel.com, michals@xilinx.com, grant.likely@linaro.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org, svemula@xilinx.com,
        linux-kernel@vger.kernel.org, anirudh@xilinx.com,
        dmaengine@vger.kernel.org, appanad@xilinx.com
Subject: Re: [PATCH v4] dma: Add Xilinx AXI Direct Memory Access Engine driver support
Date: Mon, 20 Oct 2014 21:37:14 +0200
Message-ID: <4301925.4pMHXMXqA4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413374436-14410-1-git-send-email-sthokal@xilinx.com>
References: <1413374436-14410-1-git-send-email-sthokal@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:lSRiY6YfjUmbU4vooUTmCUPMUlIsbeMtUuaUobNl9+p
 bJBiQ8btJuojjdT2FhpnMN05Pku5CbVcbDfpvk2IKzYHDzRQTo
 ZMfekrzX7Jy+bn0cvNLb5cBvh0d4ILUXJxwa+TMozm9pvmX9ma
 eW6Z6gE8hsEqDc/LH/1u5KN3ANc30+ZR4XXeUS+FiQmIpVz7pI
 XSvDe6Aw+rTkSfBUG5kbhq08hiUXvYxw09qoVJjyZpwbUjzOS+
 qhxCEfyNZmCQ3dHypEx+R46jZjQqULc+uL300+proDEraEtIgf
 zGciGAU5aDBYS5pRo3DJfO31rYDQOARcUm2nVjYNxjexB5ln++
 HpT8Dt3Jv1FUoqW+fI3A=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 October 2014 17:30:36 Srikanth Thokala wrote:
> @@ -15,6 +15,9 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/dmaengine.h>
>  
> +/* Number of AXI DMA APP Words */
> +#define XILINX_DMA_NUM_APP_WORDS       5
> +
>  /**
>   * struct xilinx_vdma_config - VDMA Configuration structure
>   * @frm_dly: Frame delay
> @@ -41,7 +44,21 @@ struct xilinx_vdma_config {
>         int ext_fsync;
>  };
>  
> +/**
> + * struct xilinx_dma_config - DMA Configuration structure
> + * @coalesc: Interrupt coalescing threshold
> + * @delay: Delay counter
> + * @reset: Reset Channel
> + */
> +struct xilinx_dma_config {
> +       int coalesc;
> +       int delay;
> +       int reset;
> +};
> +
>  int xilinx_vdma_channel_set_config(struct dma_chan *dchan,
>                                         struct xilinx_vdma_config *cfg);
> +int xilinx_dma_channel_set_config(struct dma_chan *dchan,
> +                                       struct xilinx_dma_config *cfg);
>  

You add this to a global header file, but I don't see any uses outside
of the driver itself. Please move all of this into the driver itself
and remove the header file.

	Arnd
