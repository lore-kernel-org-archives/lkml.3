Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab3GIPAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:00:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33417 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab3GIPAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:00:02 -0400
Date: Tue, 9 Jul 2013 15:59:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Bo Shen <voice.shen@atmel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org
Message-ID: <20130709145917.GA27646@sirena.org.uk>
References: <1373372929-17800-1-git-send-email-richard.genoud@gmail.com>
 <1373379933-32749-1-git-send-email-richard.genoud@gmail.com>
 <1373379933-32749-2-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BqlgNdmPmeObzZTR"
Content-Disposition: inline
In-Reply-To: <1373379933-32749-2-git-send-email-richard.genoud@gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.114
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 1/7] sound: sam9x5_wm8731: machine driver for
 at91sam9x5 wm8731 boards
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BqlgNdmPmeObzZTR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2013 at 04:25:27PM +0200, Richard Genoud wrote:

> +/*
> + * Authorized rates are:
> + * Rate = MCLK_RATE / (n * 2)
> + * Where n is in [1..4095]
> + * (cf register SSC_CMR)
> + */
> +static unsigned int rates[] = {
> +	8000,
> +	16000,
> +	32000,
> +	48000,
> +	64000,
> +	96000,
> +};

Shouldn't the SSC driver be enforcing this constraint if it comes from
the SSC hardware?  If the clock is reprogrammable the usual convention
for drivers is to not constrain if the clock is set to zero so a machine
driver could remove the constraint.

> +	ret = atmel_ssc_set_audio(0);
> +	if (ret != 0) {
> +		dev_err(&pdev->dev,
> +			"ASoC: Failed to set SSC 0 for audio: %d\n", ret);
> +		return ret;
> +	}

Shouldn't this be a parameter in the DT too?

> +	cpu_np = of_parse_phandle(np, "atmel,ssc-controller", 0);
> +	if (!cpu_np) {
> +		dev_err(&pdev->dev, "ssc controller node missing\n");
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +	at91sam9x5ek_dai.cpu_of_node = cpu_np;
> +	at91sam9x5ek_dai.platform_of_node = cpu_np;

After all we're looking things up in the DT...

> +	at91sam9x5ek_dai.dai_fmt = snd_soc_of_parse_daifmt(np, "atmel,");

Is this really something that machines would want to reconfigure?  If so
why?

--BqlgNdmPmeObzZTR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR3CVCAAoJELSic+t+oim97HcP/iKE7rM71nsMuTZlWymXsf7U
swALhpMthbc4uqAj6NVisdrXjSbdoLP8FtxYl+AaLuksxFobpACcQOxNcfji1AIi
Rs0ma5auifrRD4M04lscZAeA8Y1NgG2ktd8QdFLeT435roAjg8lkKtHb077xmCVC
NtpiNip3YUDN0x/o0dnOCksnLYeCEDGovIpNK1aO8iQBreKZbHK0/Nkc5L7PQp8L
lVu2EuY/1k78GzOzjKtHYB14Fz+dfQ8JtiJ0NkJFefNPi3DWxYTsAZL9NLYkYog1
zcDcP1M6yNjBlyjPHqy0Wrw6ua5Bk9qHoCWru1LfQlcJ8yWVJHPNlAsc++gmt7d0
V/0DPPzqnj52m8RzzZboMGFdn5o3c/ZEEgz32tHjd6+UuHPXx0JAG6DVMXPe1ZRf
uKNwLwLD+PPJvRL4joJwwrUjn8jJzjcgZLVXwdog7mMFSKN1biIRycLBfc5TtRIh
W8tFmShCm0MW0UFPVkEpk0mxNhFxC+eNfJGGqyiEm7Sg+/ae/oQMAGqw9vG+h2xj
mB5HW2uOtIKINSzoLJD7BxCPl2HaTCmHH3+63AfbFujhNOHaSVr8HKnXquF5WrPD
FIMA2qrcIjcedaGwWlZKj6yGr9Vua5dRySq5FVtxdwmX7boDmQWEDm3gpBpVGIUZ
rRIIp9OcfiNjG9KEG/Yg
=RwPv
-----END PGP SIGNATURE-----

--BqlgNdmPmeObzZTR--
