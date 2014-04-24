Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbaDXNjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:39:42 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43923 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617AbaDXNjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:39:37 -0400
Date: Thu, 24 Apr 2014 14:39:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        sbkim73@samsung.com, rdunlap@infradead.org, dianders@chromium.org
Message-ID: <20140424133920.GA12304@sirena.org.uk>
References: <1398243705-31151-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fqxOrU+oVxTp8sLK"
Content-Disposition: inline
In-Reply-To: <1398243705-31151-1-git-send-email-tushar.behera@linaro.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] ASoC: SAMSUNG: Add sound card driver for Snow board
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fqxOrU+oVxTp8sLK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2014 at 02:31:45PM +0530, Tushar Behera wrote:

> +Required properties:
> +- compatible : Can be one of the following,
> +			"google,snow-audio-max98090" or
> +			"google,snow-audio-max98095"
> +- samsung,i2s-controller: The phandle of the Samsung I2S0 controller

This should be any I2S controller, not just I2S0?

> +- samsung,audio-codec: The phandle of the audio codec

This binding only has one I2S controller and CODEC.  However...

> +static struct snd_soc_dai_link snow_dai[] = {
> +	{ /* Playback DAI i/f */
> +		.name = "Playback",
> +		.stream_name = "Playback",
> +		.codec_dai_name = "HiFi",
> +		.dai_fmt = SND_SOC_DAIFMT_I2S |
> +				SND_SOC_DAIFMT_NB_NF |
> +				SND_SOC_DAIFMT_CBS_CFS,
> +	}, { /* Capture DAI i/f */
> +		.name = "Capture",
> +		.stream_name = "Capture",
> +		.codec_dai_name = "HiFi",
> +		.dai_fmt = SND_SOC_DAIFMT_I2S |
> +				SND_SOC_DAIFMT_NB_NF |
> +				SND_SOC_DAIFMT_CBS_CFS,
> +	},
> +};

...for some reason we have separate capture and playback DAI links
defined.  Why is that?  Also, why is the secondary I2S playback stream
not supported (this may be a reason to restrict to only the one I2S
interface)?

Please also use subject lines consistent with the subsystem - NO NEED TO
SHOUT.

--fqxOrU+oVxTp8sLK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTWRQFAAoJELSic+t+oim9FLEP/2a7HlgBLyAyhlBpVVq4cudI
UXXiPqrnYEprtqB+UouodnWQDLcn7EuEIa2YiE9Z9YbzUmn/0rNusq1UBgzkgTZo
OOSiKknpOqJmwHig39tXdoyW+Q3Gf2FP945rcHI38ogXDqYt6OVNCJ93wOutYBpf
tKgejkbuSYLLB7ypk+x0xtmipWA6/0TLwf06CBGtICzWk7SoGdZP54rFtjacTEYJ
x4XXlGMJX1Wp8vrRopSSHFWSMXet8m2lFvRgv8PIvHyQZsrvSGNS4v1hdSiqSoyH
Vl0tp68YPcoK25RJojB0n4gPKoXi2ysqv1U3yvPtCXee+cUmaHv2P/HvR4VtVkMh
uAaiDab6fbisJOPL3iSrZKgZulzLac9mUpO4Tqe09E7OdwJK4ffLXt/mBaPxh79A
g+eScceRhWEpfy8nW5Kxe8/blRy8E/QX2H9Ray5e9k17tLCtfvnQ51uXM2bHt1EI
bCDNz8wxJSRBWyU2UwjLqRTSAUYiC2HVEoYksDyIzycUZ+fyZyP1ryiPtEKZixgb
fnRFyEeO5pn+HFH4ANxGp6UK2doZMLSFAvap6KSaIsHm4usZ9gLsgarMzdKCcLcL
tmPea5SImfWgqKzh41Zy1pFmwzlyUhfoAD3AQgtcMQbkJHgFa1qFdRR53UApOyoh
ncpz8pHpV7F85EYSLPwM
=3Q3e
-----END PGP SIGNATURE-----

--fqxOrU+oVxTp8sLK--
