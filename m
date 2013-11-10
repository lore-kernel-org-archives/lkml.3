Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab3KJG5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 01:57:22 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:11709
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054Ab3KJG5P convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 01:57:15 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz9371I542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097h186068hz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6h2216hbe9i1155h)
From: Bharat Bhushan <Bharat.Bhushan@freescale.com>
To: Guangyu Chen <guangyu.chen@freescale.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "timur@tabi.org" <timur@tabi.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>
CC: "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v4 1/4] dma: imx-sdma: Add sdma firmware version 2
 support
Thread-Topic: [PATCH v4 1/4] dma: imx-sdma: Add sdma firmware version 2
 support
Thread-Index: AQHO3HBkOYr00Lwto0GGd66N6MG5c5oeCvnQ
Date: Sun, 10 Nov 2013 06:57:08 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D071EDFC5@039-SN2MPN1-013.039d.mgd.msft.net>
References: <cover.1383907685.git.b42378@freescale.com>
 <1524b725cecd208ad63741f0b7214d0039608ac0.1383907685.git.b42378@freescale.com>
In-Reply-To: <1524b725cecd208ad63741f0b7214d0039608ac0.1383907685.git.b42378@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.134.82]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Linuxppc-dev [mailto:linuxppc-dev-
> bounces+bharat.bhushan=freescale.com@lists.ozlabs.org] On Behalf Of Nicolin Chen
> Sent: Friday, November 08, 2013 4:20 PM
> To: vinod.koul@intel.com; dan.j.williams@intel.com; s.hauer@pengutronix.de;
> timur@tabi.org; shawn.guo@linaro.org; broonie@kernel.org
> Cc: mark.rutland@arm.com; devicetree@vger.kernel.org; alsa-devel@alsa-
> project.org; pawel.moll@arm.com; linux-doc@vger.kernel.org;
> swarren@wwwdotorg.org; linux-kernel@vger.kernel.org; rob.herring@calxeda.com;
> dmaengine@vger.kernel.org; ijc+devicetree@hellion.org.uk; linuxppc-
> dev@lists.ozlabs.org; linux-arm-kernel@lists.infradead.org
> Subject: [PATCH v4 1/4] dma: imx-sdma: Add sdma firmware version 2 support
> 
> On i.MX5/6 series, SDMA is using new version firmware to support SSI dual FIFO
> feature and HDMI Audio (i.MX6Q/DL only). Thus add it.
> 
> Signed-off-by: Nicolin Chen <b42378@freescale.com>
> ---
>  drivers/dma/imx-sdma.c                     | 15 ++++++++++++++-
>  include/linux/platform_data/dma-imx-sdma.h |  5 +++++
>  2 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c index
> fc43603..c7ece8d 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -323,6 +323,7 @@ struct sdma_engine {
>  	struct clk			*clk_ipg;
>  	struct clk			*clk_ahb;
>  	spinlock_t			channel_0_lock;
> +	u32				script_number;
>  	struct sdma_script_start_addrs	*script_addrs;
>  	const struct sdma_driver_data	*drvdata;
>  };
> @@ -1238,6 +1239,7 @@ static void sdma_issue_pending(struct dma_chan *chan)  }
> 
>  #define SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V1	34
> +#define SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V2	38
> 
>  static void sdma_add_scripts(struct sdma_engine *sdma,
>  		const struct sdma_script_start_addrs *addr) @@ -1246,7 +1248,7 @@
> static void sdma_add_scripts(struct sdma_engine *sdma,
>  	s32 *saddr_arr = (u32 *)sdma->script_addrs;
>  	int i;
> 
> -	for (i = 0; i < SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V1; i++)
> +	for (i = 0; i < sdma->script_number; i++)
>  		if (addr_arr[i] > 0)
>  			saddr_arr[i] = addr_arr[i];
>  }
> @@ -1272,6 +1274,17 @@ static void sdma_load_firmware(const struct firmware *fw,
> void *context)
>  		goto err_firmware;
>  	if (header->ram_code_start + header->ram_code_size > fw->size)
>  		goto err_firmware;
> +	switch (header->version_major) {
> +		case 1:
> +			sdma->script_number = SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V1;
> +			break;
> +		case 2:
> +			sdma->script_number = SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V2;
> +			break;
> +		default:
> +			dev_err(sdma->dev, "unknown firmware version\n");
> +			return;

Why return and not "goto err_firmware" ?

-Bharat

> +	}
> 
>  	addr = (void *)header + header->script_addrs_start;
>  	ram_code = (void *)header + header->ram_code_start; diff --git
> a/include/linux/platform_data/dma-imx-sdma.h b/include/linux/platform_data/dma-
> imx-sdma.h
> index 3a39428..eabac4e 100644
> --- a/include/linux/platform_data/dma-imx-sdma.h
> +++ b/include/linux/platform_data/dma-imx-sdma.h
> @@ -43,6 +43,11 @@ struct sdma_script_start_addrs {
>  	s32 dptc_dvfs_addr;
>  	s32 utra_addr;
>  	s32 ram_code_start_addr;
> +	/* End of v1 array */
> +	s32 mcu_2_ssish_addr;
> +	s32 ssish_2_mcu_addr;
> +	s32 hdmi_dma_addr;
> +	/* End of v2 array */
>  };
> 
>  /**
> --
> 1.8.4
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


