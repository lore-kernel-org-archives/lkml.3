Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaB1IZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 03:25:46 -0500
Received: from smtp-out-128.synserver.de ([212.40.185.128]:1151 "EHLO
	smtp-out-167.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751164AbaB1IZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 03:25:44 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13776
Message-ID: <5310481D.3070106@metafoo.de>
Date: Fri, 28 Feb 2014 09:26:05 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>
CC: broonie@kernel.org, lgirdwood@gmail.com, alsa-devel@alsa-project.org,
        kuninori.morimoto.gx@renesas.com, abrestic@chromium.org,
        viresh.kumar@linaro.org, timur@tabi.org, peter.ujfalusi@ti.com,
        mr.swami.reddy@ti.com, voice.shen@atmel.com, mike.dyer@md-soft.co.uk,
        bardliao@realtek.com, mahaijuns@gmail.com, s.trumtrar@pengutronix.de,
        rf@opensource.wolfsonmicro.com, LW@KARO-electronics.de,
        swarren@nvidia.com, shc_work@mail.ru, vinod.koul@intel.com,
        b42378@freescale.com, Paul.Handrigan@cirrus.com,
        vishwas.a.deshpande@ti.com, Adam.Thomson.Opensource@diasemi.com,
        axel.lin@ingics.com, ckeepax@opensource.wolfsonmicro.com,
        dgreid@chromium.org, fabio.estevam@freescale.com,
        brian.austin@cirrus.com, Andreas.Irestal@axis.com,
        linux-kernel@vger.kernel.org, sachin.kamat@linaro.org,
        mpa@pengutronix.de, shawn.guo@linaro.org,
        alban.bedel@avionic-design.de, jic23@kernel.org
Subject: Re: [alsa-devel] [PATCH 2/2] ASoC: io: Remove reduntant params of
 snd_soc_codec_set_cache_io()
References: <1393564009-15968-1-git-send-email-Li.Xiubo@freescale.com> <1393564009-15968-3-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1393564009-15968-3-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 06:06 AM, Xiubo Li wrote:
[...]
> @@ -118,7 +115,6 @@ int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
>   EXPORT_SYMBOL_GPL(snd_soc_codec_set_cache_io);
>   #else
>   int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
> -			       int addr_bits, int data_bits,
>   			       enum snd_soc_control_type control)

Since the only control type that is left is SND_SOC_REGMAP that can be 
removed as well. And while you are at it I think we should make it possible 
to specify the regmap struct as a parameter to snd_soc_codec_set_cache_io(). 
So basically the new signature of the function should be:

snd_soc_codec_set_cache_io(struct snd_soc_codec *codec, struct regmap *regmap)

if regmap is NULL the function should use dev_get_regmap(), otherwise use 
the supplied regmap struct. This turns the two step initialization in the 
form of

	codec->control_data = priv->regmap;
	snd_soc_codec_set_cache_io(codec, ...);

into
	snd_soc_codec_set_cache_io(codec, priv->regmap);

which is much nicer in my opinion.

- Lars

