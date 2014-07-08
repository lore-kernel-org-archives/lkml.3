Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbaGHJTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:19:34 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51130 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752603AbaGHJTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:19:31 -0400
Message-ID: <53BBB746.1000201@arm.com>
Date: Tue, 08 Jul 2014 10:17:58 +0100
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>, Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [alsa-devel] [PATCH v2] ASoC: tda998x: add a codec to the HDMI
 transmitter
References: <20140704091733.10258cfe@armhf>
In-Reply-To: <20140704091733.10258cfe@armhf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/14 08:17, Jean-Francois Moine wrote:
> This patch adds a CODEC function to the NXP TDA998x HDMI transmitter.
> 
> The CODEC handles both I2S and S/PDIF input and does dynamic input
> switch in the TDA998x I2C driver on start/stop audio streaming.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---

[snip]

> +++ b/drivers/gpu/drm/i2c/tda998x_codec.c

[snip]

> +static int tda_startup(struct snd_pcm_substream *substream,
> +                       struct snd_soc_dai *dai)
> +{
> +       struct tda998x_priv *priv = snd_soc_codec_get_drvdata(dai->codec);
> +       u8 *eld = priv->eld;
> +       struct snd_pcm_runtime *runtime = substream->runtime;
> +       u8 *sad;
> +       int sad_count;
> +       unsigned eld_ver, mnl, rate_mask;
> +       unsigned max_channels, fmt;
> +       u64 formats;
> +       struct snd_pcm_hw_constraint_list *rate_constraints =
> +                       &priv->rate_constraints;
> +       static const u32 hdmi_rates[] = {
> +               32000, 44100, 48000, 88200, 9600, 176400, 192000
> +       };
> +

Shouldn't this be 96000, not 9600?  Assuming that the table is ordered in terms of increasing frequencies.

    Andrew

