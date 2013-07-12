Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953Ab3GLLtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:49:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49817 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834Ab3GLLtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:49:51 -0400
Date: Fri, 12 Jul 2013 12:49:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Bo Shen <voice.shen@atmel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Message-ID: <20130712114926.GE24508@sirena.org.uk>
References: <1373559359-31607-1-git-send-email-richard.genoud@gmail.com>
 <1373559359-31607-3-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fr7jhMP26BSURKlp"
Content-Disposition: inline
In-Reply-To: <1373559359-31607-3-git-send-email-richard.genoud@gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.114
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 2/7] sound: sam9x5_wm8731: machine driver for
 at91sam9x5 wm8731 boards
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fr7jhMP26BSURKlp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 11, 2013 at 06:15:54PM +0200, Richard Genoud wrote:
> From: Nicolas Ferre <nicolas.ferre@atmel.com>
>=20
> Description of the Asoc machine driver for an at91sam9x5 based board

ASoC.

> +sam9x5 pins:
> + * LOUT
> + * ROUT
> + * LHPOUT
> + * RHPOUT
> + * LLINEIN
> + * RLINEIN
> + * MICIN

These aren't pins on the CPU, they're pins on the CODEC, and you should
be adding this to the binding document for the CODEC and referring to
that rather than having them in each individual binding document.  This
also helps if any new variants are added (not that this is likely for
the WM8731).

> +static struct sam9x5_drvdata sam9x5_priv;

Why is this a global static?

> +	ret =3D snd_soc_register_card(&snd_soc_sam9x5);
> +	if (ret) {
> +		dev_err(&pdev->dev,
> +			"ASoC: Platform device allocation failed\n");
> +		goto out_put_audio;
> +	}

> +	platform_set_drvdata(pdev, &snd_soc_sam9x5);

It should be being dynamically allocated and retrieved as driver data
when needed.

--Fr7jhMP26BSURKlp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR3+1DAAoJELSic+t+oim95AsP/3bXnAukXiiPnuv0mi3StyaL
W8nMl6B317eWWb981owyWrrFJfRGa62wI+S/6Tj00A3Dc8EbZoCGBV1yCwvCj7aD
hJQJ8JTgVojDPWPAOa/OTtwnatkfguLh/n4jCUAztMDGT4aF3VEJ+Go5X216ECgx
UMbaXx7VSbK639oVjwI9FrSN/vE/59pB/s/jJ3VpmKVqvYfcnZRo6BH1K7YaF4zK
n4Vh8H+QQwMdtEA1PwbUR+MMZN7UwxorfPrhiI8DdaGr8HgAUPVBxEzZb7NSuH2G
kbN/l2Iat+TOTQ3FYb+tPdWXQWYP2R+uRbL8M6YesUlNL8AMfdfSJoiU994Qq2F+
BHcDKVDpvoiZQEp1nbjJgtx9Vfrf5kTq68oagsfxMYF4TjipB+PxjP+0stcGSfic
T8ouZ0ABEsggHaZyRcNYbGKQOHpYiYYj66BqRCI6pk8L3LsSw/zKQrV524zFZT2C
WFe+bzM6pXe+mHFUIVwSCB4FtlLCSPRheuYbR728av65LZVySRM16Zh9Z+qqXkMa
6KUZ1sMB9FOsaTyM+L1g4LfulfrUVk6TtlO9Lhf8m6NohzuWuyhIPFi4sFgUWrFP
VsljSXyc2LJsmU9mBBMejSpVjwm+nfoJ3cKMYY773qWLeYVl5nUGZDD/2jKArso9
msrtfWYlGCLBRhJvzQaM
=fz1S
-----END PGP SIGNATURE-----

--Fr7jhMP26BSURKlp--
