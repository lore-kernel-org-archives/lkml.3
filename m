Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbbAIRjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:39:33 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:35295 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752158AbbAIRjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:39:31 -0500
Message-ID: <54B0123C.9070800@arm.com>
Date: Fri, 09 Jan 2015 17:39:08 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>, Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Dave Airlie <airlied@gmail.com>, Jyri Sarha <jsarha@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 3/4] ASoC: tda998x: add a codec to the HDMI transmitter
References: <cover.1420628786.git.moinejf@free.fr> <23b36acc1f769418a06f3e929eba288b5911da12.1420628786.git.moinejf@free.fr>
In-Reply-To: <23b36acc1f769418a06f3e929eba288b5911da12.1420628786.git.moinejf@free.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/15 10:51, Jean-Francois Moine wrote:
> This patch adds a CODEC to the NXP TDA998x HDMI transmitter.
> 
> The CODEC handles both I2S and S/PDIF inputs.
> It maintains the audio format and rate constraints according
> to the HDMI device parameters (EDID) and sets dynamically the input
> ports in the TDA998x I2C driver on start/stop audio streaming.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---

[snip]

> +static int tda998x_codec_startup(struct snd_pcm_substream *substream,
> +                                struct snd_soc_dai *dai)
> +{
> +       struct snd_pcm_runtime *runtime = substream->runtime;
> +       struct snd_pcm_hw_constraint_list *rate_constraints;
> +       u8 *sad;                /* Short Audio Descriptor (3 bytes) */

[...]

> +       snd_pcm_hw_constraint_minmax(runtime,
> +                               SNDRV_PCM_HW_PARAM_CHANNELS,
> +                               1, sad[SAD_MX_CHAN_I]);

In the light of our discussions elsewhere [1], shouldn't this
be constrained by the number of hardware channels that the TDA998x
supports too?  That is, the maximum number of channels should
be the lesser of sd[SAD_MX_CHAN_I] and number_of_I2S channels 
(or S/PDIF channels if so configured).

	Andrew

[1] http://mailman.alsa-project.org/pipermail/alsa-devel/2015-January/086090.html
