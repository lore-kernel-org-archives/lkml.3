Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab3KAKpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 06:45:14 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:13613 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331Ab3KAKpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 06:45:12 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz98dI1dbaI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h1155h)
Date: Fri, 1 Nov 2013 18:28:05 +0800
From: Nicolin Chen <b42378@freescale.com>
To: Xiubo Li <Li.Xiubo@freescale.com>, <shawn.guo@linaro.org>
CC: <r65073@freescale.com>, <timur@tabi.org>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <r64188@freescale.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <perex@perex.cz>, <tiwai@suse.de>, <grant.likely@linaro.org>,
        <fabio.estevam@freescale.com>, <LW@KARO-electronics.de>,
        <oskar@scara.com>, <b18965@freescale.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCHv2 6/8] ASoC: fsl: add SGTL5000 based audio machine driver.
Message-ID: <20131101102805.GG28401@MrMyself>
References: <1383289495-24523-1-git-send-email-Li.Xiubo@freescale.com>
 <1383289495-24523-7-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1383289495-24523-7-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Xiubo,

On Fri, Nov 01, 2013 at 03:04:53PM +0800, Xiubo Li wrote:
> This is the SGTL5000 codec based audio driver supported with both
> playback and capture dai link implemention.
> 
> This implementation is only compatible with device tree definition.
> 
> Signed-off-by: Alison Wang <b18965@freescale.com
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> 
> Conflicts:
> 	sound/soc/fsl/Makefile
> ---
>  sound/soc/fsl/Kconfig              |  10 ++
>  sound/soc/fsl/Makefile             |   2 +

>  sound/soc/fsl/fsl-sgtl5000-vf610.c | 208 +++++++++++++++++++++++++++++++++++++

I just doubt if this file naming is appropriate. Even if we might not have
rigor rule for the file names, according to existing ones, they are all in
a same pattern: [SoC name]-[codec name].c

"imx-sgtl5000.c" for example

I think it would make user less confused about what this file exactly is if
this machine driver also follow the pattern: vf610-sgtl5000.c


@Shawn

What do you think about the file name?

>  3 files changed, 220 insertions(+)
>  create mode 100644 sound/soc/fsl/fsl-sgtl5000-vf610.c
> 
> diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
> index 9a8851e..1b835ba 100644
> --- a/sound/soc/fsl/Kconfig
> +++ b/sound/soc/fsl/Kconfig
> @@ -228,4 +228,14 @@ config SND_SOC_FSL_SAI
>  	tristate
>  	select SND_SOC_GENERIC_DMAENGINE_PCM
>  
> +config SND_SOC_FSL_SGTL5000_VF610

Same problem with the this define.

> +	tristate "SoC Audio support for FSL boards with sgtl5000"

And 'FSL' here confuses me a lot. Because those boards based on i.MX series
also could be called FSL boards.

> +	depends on OF && I2C
> +	select SND_SOC_FSL_SAI
> +	select SND_SOC_FSL_PCM
> +	select SND_SOC_SGTL5000
> +	help
> +	  Say Y if you want to add support for SoC audio on an FSL board with
> +	  a sgtl5000 codec.
> +
>  endif # SND_FSL_SOC
> diff --git a/sound/soc/fsl/Makefile b/sound/soc/fsl/Makefile
> index e5acc03..26fc551 100644
> --- a/sound/soc/fsl/Makefile
> +++ b/sound/soc/fsl/Makefile
> @@ -59,5 +59,7 @@ obj-$(CONFIG_SND_SOC_IMX_MC13783) += snd-soc-imx-mc13783.o
>  
>  # FSL ARM SAI/SGT15000 Platform Support
>  snd-soc-fsl-sai-objs := fsl-sai.o
> +snd-soc-fsl-sgtl5000-vf610-objs := fsl-sgtl5000-vf610.o
>  
>  obj-$(CONFIG_SND_SOC_FSL_SAI) += snd-soc-fsl-sai.o
> +obj-$(CONFIG_SND_SOC_FSL_SGTL5000_VF610) += snd-soc-fsl-sgtl5000-vf610.o
> diff --git a/sound/soc/fsl/fsl-sgtl5000-vf610.c b/sound/soc/fsl/fsl-sgtl5000-vf610.c
> new file mode 100644
> index 0000000..f535b42
> --- /dev/null
> +++ b/sound/soc/fsl/fsl-sgtl5000-vf610.c
> @@ -0,0 +1,208 @@
> +/*
> + * Freeacale ALSA SoC Audio using SGT1500 as codec.
> + *
> + * Copyright 2012-2013 Freescale Semiconductor, Inc.
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/i2c.h>
> +#include <linux/clk.h>
> +
> +#include "../codecs/sgtl5000.h"
> +#include "fsl-sai.h"
> +
> +static unsigned int sysclk_rate;
> +
> +static int fsl_sgtl5000_dai_init(struct snd_soc_pcm_runtime *rtd)

Naming issue here again.

At least from my point of view, if you actually merged imx-sgtl5000 with
vf610-sgtl5000 and made it also compatible to other freescale SoCs, you
could then fairly call it fsl_sgtl5000_xxxx.

Well, I might be a little picky here because it's a static function and
won't conflict others. Just the name here doesn't look so explicit to me.

Please reconsider about this whole file's naming.

Best regards,
Nicolin Chen

> +{
> +	int ret;
> +	struct device *dev = rtd->card->dev;
> +
> +	ret = snd_soc_dai_set_sysclk(rtd->codec_dai, SGTL5000_SYSCLK,
> +				     sysclk_rate, SND_SOC_CLOCK_IN);
> +	if (ret) {
> +		dev_err(dev, "could not set codec driver clock params :%d\n",
> +				ret);
> +		return ret;
> +	}
> +
> +	ret = snd_soc_dai_set_sysclk(rtd->cpu_dai, FSL_SAI_CLK_BUS,
> +				     sysclk_rate, SND_SOC_CLOCK_OUT);
> +	if (ret) {
> +		dev_err(dev, "could not set cpu dai driver clock params :%d\n",
> +				ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int sgtl5000_params(struct snd_pcm_substream *substream,
> +		struct snd_pcm_hw_params *params)
> +{
> +	struct snd_soc_pcm_runtime *rtd = substream->private_data;
> +	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
> +	unsigned int channels = params_channels(params);
> +
> +	/* TODO: The SAI driver should figure this out for us */
> +	switch (channels) {
> +	case 2:
> +		snd_soc_dai_set_tdm_slot(cpu_dai, 0xfffffffc, 0xfffffffc, 2, 0);
> +		break;
> +	case 1:
> +		snd_soc_dai_set_tdm_slot(cpu_dai, 0xfffffffe, 0xfffffffe, 1, 0);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct snd_soc_ops fsl_sgtl5000_hifi_ops = {
> +	.hw_params = sgtl5000_params,
> +};
> +
> +static struct snd_soc_dai_link fsl_sgtl5000_dai = {
> +	.name = "HiFi",
> +	.stream_name = "HiFi",
> +	.codec_dai_name = "sgtl5000",
> +	.init = &fsl_sgtl5000_dai_init,
> +	.dai_fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF |
> +		SND_SOC_DAIFMT_CBM_CFM,
> +	.ops = &fsl_sgtl5000_hifi_ops,
> +};
> +
> +static const struct snd_soc_dapm_widget fsl_sgtl5000_dapm_widgets[] = {
> +	SND_SOC_DAPM_MIC("Mic Jack", NULL),
> +	SND_SOC_DAPM_LINE("Line In Jack", NULL),
> +	SND_SOC_DAPM_HP("Headphone Jack", NULL),
> +	SND_SOC_DAPM_SPK("Line Out Jack", NULL),
> +	SND_SOC_DAPM_SPK("Ext Spk", NULL),
> +};
> +
> +static struct snd_soc_card fsl_sgt1500_card = {
> +	.owner = THIS_MODULE,
> +	.num_links = 1,
> +	.dai_link = &fsl_sgtl5000_dai,
> +	.dapm_widgets = fsl_sgtl5000_dapm_widgets,
> +	.num_dapm_widgets = ARRAY_SIZE(fsl_sgtl5000_dapm_widgets),
> +};
> +
> +static int fsl_sgtl5000_parse_dt(struct platform_device *pdev)
> +{
> +	int ret;
> +	struct device_node *sai_np, *codec_np;
> +	struct clk *codec_clk;
> +	struct i2c_client *codec_dev;
> +	struct device_node *np = pdev->dev.of_node;
> +
> +	ret = snd_soc_of_parse_card_name(&fsl_sgt1500_card, "model");
> +	if (ret)
> +		return ret;
> +
> +	ret = snd_soc_of_parse_audio_routing(&fsl_sgt1500_card,
> +			"audio-routing");
> +	if (ret)
> +		return ret;
> +
> +	sai_np = of_parse_phandle(np, "saif-controller", 0);
> +	if (!sai_np) {
> +		dev_err(&pdev->dev, "\"saif-controller\" phandle missing or "
> +				"invalid\n");
> +		return -EINVAL;
> +	}
> +	fsl_sgtl5000_dai.cpu_of_node = sai_np;
> +	fsl_sgtl5000_dai.platform_of_node = sai_np;
> +
> +	codec_np = of_parse_phandle(np, "audio-codec", 0);
> +	if (!codec_np) {
> +		dev_err(&pdev->dev, "\"audio-codec\" phandle missing or "
> +				"invalid\n");
> +		ret = -EINVAL;
> +		goto sai_np_fail;
> +	}
> +	fsl_sgtl5000_dai.codec_of_node = codec_np;
> +
> +	codec_dev = of_find_i2c_device_by_node(codec_np);
> +	if (!codec_dev) {
> +		dev_err(&pdev->dev, "failed to find codec platform device\n");
> +		ret = PTR_ERR(codec_dev);
> +		goto codec_np_fail;
> +	}
> +
> +	codec_clk = devm_clk_get(&codec_dev->dev, NULL);
> +	if (IS_ERR(codec_clk)) {
> +		dev_err(&pdev->dev, "failed to get codec clock\n");
> +		ret = PTR_ERR(codec_clk);
> +		goto codec_np_fail;
> +	}
> +
> +	sysclk_rate = clk_get_rate(codec_clk);
> +
> +codec_np_fail:
> +	of_node_put(codec_np);
> +sai_np_fail:
> +	of_node_put(sai_np);
> +
> +	return ret;
> +}
> +
> +static int fsl_sgtl5000_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +
> +	fsl_sgt1500_card.dev = &pdev->dev;
> +
> +	ret = fsl_sgtl5000_parse_dt(pdev);
> +	if (ret) {
> +		dev_err(&pdev->dev,
> +				"parse sgtl5000 device tree failed :%d\n",
> +				ret);
> +		return ret;
> +	}
> +
> +	ret = devm_snd_soc_register_card(&pdev->dev, &fsl_sgt1500_card);
> +	if (ret) {
> +		dev_err(&pdev->dev, "register soc sound card failed :%d\n",
> +				ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int fsl_sgtl5000_remove(struct platform_device *pdev)
> +{
> +	snd_soc_unregister_card(&fsl_sgt1500_card);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id fsl_sgtl5000_dt_ids[] = {
> +	{ .compatible = "fsl,vf610-sgtl5000", },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, fsl_sgtl5000_dt_ids);
> +
> +static struct platform_driver fsl_sgtl5000_driver = {
> +	.driver = {
> +		.name = "fsl-sgtl5000",
> +		.owner = THIS_MODULE,
> +		.of_match_table = fsl_sgtl5000_dt_ids,
> +	},
> +	.probe = fsl_sgtl5000_probe,
> +	.remove = fsl_sgtl5000_remove,
> +};
> +module_platform_driver(fsl_sgtl5000_driver);
> +
> +MODULE_AUTHOR("Xiubo Li <Li.Xiubo@freescale.com>");
> +MODULE_DESCRIPTION("Freescale SGTL5000 ASoC driver");
> +MODULE_LICENSE("GPL");
> -- 
> 1.8.4
> 


