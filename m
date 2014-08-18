Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaHRSyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:54:01 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47447 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaHRSx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:53:59 -0400
Date: Mon, 18 Aug 2014 13:53:00 -0500
From: Mark Brown <broonie@kernel.org>
To: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20140818185300.GK14537@sirena.org.uk>
References: <1407341786-14990-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wv56KCa6/aA7yLgk"
Content-Disposition: inline
In-Reply-To: <1407341786-14990-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.64.155
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] ASOC: dapm: add code to configure dai link parameters
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wv56KCa6/aA7yLgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 06, 2014 at 05:16:26PM +0100, Nikesh Oswal wrote:

> +/* create new dapm dai link control */
> +static int dapm_new_dai_link(struct snd_soc_dapm_widget *w)
> +{
> +	int i, ret;
> +	struct snd_kcontrol *kcontrol;
> +	struct snd_soc_dapm_context *dapm = w->dapm;
> +	struct snd_card *card = dapm->card->snd_card;
> +
> +
> +	/* add kcontrol */
> +	for (i = 0; i < w->num_kcontrols; i++) {
> +		kcontrol = snd_soc_cnew(&w->kcontrol_news[i], w,
> +		w->name, NULL);

We appear to be creating the control unconditionally so even a link
which has only one configuration will have a control created which
doesn't seem right.  Suppressing the control creation for links that
only have one configuration seems better.

Throughout this you've got coding style problems, you're not indenting
the continuations of multi-line statements.  Please try to follow the
kernel coding style, if your code is visibly different to the rest of
the codebase that's not good.

> +	for (count = 0 ; count < num_params; count++) {
> +		w_param_text[count] =  kzalloc(sizeof(char) * 100, GFP_KERNEL);

Random number!

> +		if (!w_param_text) {
> +			ret = -ENOMEM;
> +			goto  outfree_w_param;
> +		}
> +
> +		sprintf(w_param_text[count], "SampleRate=%d:Channels=%d:BitsPerSample=%d",
> +			config->rate_min, config->channels_min,
> +			snd_pcm_format_width(ffs(config->formats) - 1));
> +		config++;

The configurations have user speciable names in them which are being
ignored here - this means that users can't specify names that are
meaningful for their systems.

--wv56KCa6/aA7yLgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8kuCAAoJELSic+t+oim9J1sP/R5A4x8U1Y8SzDRhB13r3S2X
ojK64pEqUvwwoxYGAllMA2FUexwLlP5V2BjJkFhz89ZI1CmE+LVNwHlWB3ejbpnC
h+DrRK2U9/GhQAG2B61izoh29XKCKFcdDx4aIDdRN4ArwncYPwyhBZQ3RMvaz3+c
OMYUZ1N+A7CFDhnvRVK+GwgbgCVD7wFEwjhVYXzux6sM6ELBdSSBxgiLe4+QaOWx
iIkQJT6yUux0vIW3xt8d/4nWj77o/L9lDfzbYuwGJA568LVCIxXtRd6XG5iSN37B
EijI5gGtNyUN7veNoh5zxy8OcTNIKX9WkLno3Al0VqYAT01AOUug/msJYbAGm0tQ
ksYGs92CzH/pXysX2e4EaR12qVwKwtfRC/mmTVDd51NTzRgVBb6MDwgc0eGXdhhp
Vb75c/L1dl59Dt7uhrKc1/QFmZW5jWKd8IzbLC+kOaxv3jNLKLKheDedg7kZPFaO
s2Nl9fjAugkbKR7sGIY7R9AyCCzYRuuNSms8Wv9pmsRYJbDjTYqTwlDLMl+AqCeZ
c3G+ZyfmV8s+surEWxQgnSli9zYHx69yV6ZgwYddd+aX+1ykIbTbWlB4fhpT661T
rl1ZIni2ZtU0DUI9QQsqH2+dC68Fm8CG9cg3eKNY0k0ghyM4b+paFGxJqv98o0f3
2JqIaKMQ/x4xMnzklOno
=ri3I
-----END PGP SIGNATURE-----

--wv56KCa6/aA7yLgk--
