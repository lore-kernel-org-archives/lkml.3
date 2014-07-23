Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746AbaGWKW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:22:59 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53224 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756014AbaGWKW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:22:57 -0400
Message-ID: <53CF8CCE.3030205@arm.com>
Date: Wed, 23 Jul 2014 11:22:06 +0100
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
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] ASoC: tda998x: add a codec to the HDMI transmitter
References: <20140708114057.5ef3cfd0@armhf>
In-Reply-To: <20140708114057.5ef3cfd0@armhf>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/14 10:40, Jean-Francois Moine wrote:
> This patch adds a CODEC function to the NXP TDA998x HDMI transmitter.
> 
> The CODEC handles both I2S and S/PDIF input and does dynamic input
> switch in the TDA998x I2C driver on start/stop audio streaming.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---

Shouldn't the patch also capture the current audio rate in tda998x_codec.c:tda_hw_params?  Otherwise, when tda998x_drv.c:tda998x_audio_start invokes tda998x_drv.c:tda998x_configure_audio, the value of 'N' will be calculated incorrectly.

So something similar to:

diff --git a/drivers/gpu/drm/i2c/tda998x_codec.c b/drivers/gpu/drm/i2c/tda998x_codec.c
index e7f223d..b6c4fb3 100755
--- a/drivers/gpu/drm/i2c/tda998x_codec.c
+++ b/drivers/gpu/drm/i2c/tda998x_codec.c
@@ -111,6 +111,7 @@ static int tda_hw_params(struct snd_pcm_substream *substream,
 		tda998x_audio_start(priv, 0);
 		return 0;
 	}
+	priv->params.audio_sample_rate = params_rate(params);
 	priv->params.audio_format = dai->id;
 	priv->audio_sample_format = params_format(params);
 	params.audio_cfg =


   Andrew


