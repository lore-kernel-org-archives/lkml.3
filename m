Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761450Ab3LIR4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:56:46 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42844 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916Ab3LIR4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:56:43 -0500
Date: Mon, 9 Dec 2013 17:56:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <b42378@freescale.com>
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org, tiwai@suse.de,
        perex@perex.cz, linux-kernel@vger.kernel.org
Message-ID: <20131209175640.GL29268@sirena.org.uk>
References: <cover.1386344000.git.b42378@freescale.com>
 <105d07ac1a77bf99872d75608c97b3342079bfb7.1386344000.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WK7GFmZHL0+Wby+V"
Content-Disposition: inline
In-Reply-To: <105d07ac1a77bf99872d75608c97b3342079bfb7.1386344000.git.b42378@freescale.com>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] ASoC: fsl: imx-wm8962: Grant hw_params/free()
 permission to control FLL
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WK7GFmZHL0+Wby+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 06, 2013 at 11:38:29PM +0800, Nicolin Chen wrote:

> +static int imx_hifi_hw_free(struct snd_pcm_substream *substream)
> +{
> +	struct snd_soc_pcm_runtime *rtd = substream->private_data;
> +	struct snd_soc_dai *codec_dai = rtd->codec_dai;
> +
> +	/* Don't diable FLL if still having multiple substreams running */
> +	if (codec_dai->active != 1)
> +		return 0;
> +
> +	return imx_wm8962_disable_fll(codec_dai);

This will still disable the FLL if there's an analogue bypass path
active.  I'd suggest changing enable() and disable() to reference count.

> +		if (dapm->bias_level == SND_SOC_BIAS_STANDBY)
> +			return imx_wm8962_enable_fll(codec_dai, 44100,
> +						SNDRV_PCM_FORMAT_S16_LE);

It might be slightly nicer to keep the static variable for the frequency
- that way if we start up due to set_bias_level() we'll keep the last
rate played which might be more likely to avoid locking playbacks out.
Very minor thing though, I wouldn't worry about it.

--WK7GFmZHL0+Wby+V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSpgRUAAoJELSic+t+oim9ewAQAILMo5W/BBTQL3v3jecE/dAd
1Efz3wXx7mybOui2V8vu1wbM61KBBruD0h/v8iddm/HIBAdV434NVNBqpub9rtGU
15GjfCkxIFiAWqrn8+eXKhCMj0QuB9Fzne6uq81M7ueun5CC/uiXdS6dGT6hSaN0
KkFnt8TbHSVs7DiQ+EDZsEGTj8VMOONfD5wpn85tsktFHxvcSsYNwwmpBGKOhwqO
FI8wqKTKmm16PAFUFx5Kgq752ZUPdSzTilqTxVuShdLmWxbRGiPv5ha7cEn8rUOR
UejZC3+nmInhBi+tNREUY9Gd8Q9LITIcxOk1FJYalDfw5YWIi4l6rgpcS/J790/q
EzYKz1Dl37Tqm/rU5ipfl6o7fICKDLnOBAm/WxyOdgC5Ob4RYviWSiZfAIbmOMo8
jB8/iIs65pEVcY22gxhkVIvw9gA8dvZYEEtenQ9fJf73I94dBPUMUm2jPyxBzv/n
4sKFTxt/ep0hy4UQGfxW+a0HYRorBgk5tbb0dicVAbUqa/UeG8YToyVTaE/+CoO2
64F8QsvWTQWHpIuWl5yjKaWTiBTYs/q0KorB76zYONt+/n+AdestZ61ZsiBvFO0B
Xe1sa3LzeqeifEgF7EnVrGSRMNvwoxTRz9WttJpG9MusvQ28oBgJMPpE2fzWRHgg
35qB+u5XcYP1CaYr6RbF
=i13n
-----END PGP SIGNATURE-----

--WK7GFmZHL0+Wby+V--
