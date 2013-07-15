Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab3GOPbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:31:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40446 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790Ab3GOPbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:31:07 -0400
Date: Mon, 15 Jul 2013 16:31:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Message-ID: <20130715153101.GK11538@sirena.org.uk>
References: <20130715103644.04e57749@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7Ke/meiCZutM6I/"
Content-Disposition: inline
In-Reply-To: <20130715103644.04e57749@armhf>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: kirkwood-i2s: fix a compilation warning
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7Ke/meiCZutM6I/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 15, 2013 at 10:36:44AM +0200, Jean-Francois Moine wrote:
> In the function kirkwood_set_rate, when the rate cannot be satisfied
> by the internal nor by an external clock, the clock source in undefined:

>  warning: =E2=80=98clks_ctrl=E2=80=99 may be used uninitialized in this f=
unction

> As the ALSA subsystem should never gives such a rate, this patch removes
> the check of the external clock pointer.

> -	} else if (!IS_ERR(priv->extclk)) {
> +	} else {

I'd really like to see an analysis explaining why this can never happen,
the driver explicitly supports running without extclk being provided.
Simply asserting that we should never get such a rate isn't really
enough detail...

--C7Ke/meiCZutM6I/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5BWyAAoJELSic+t+oim9kIYP/1Zb5f5ipqAdT4fmcHCRNsMZ
bB/yGsK1LGnB62zj96RneZL5UvnVR+WfAzXef0jVrtct0FBjXM3kP5SHhBfRllg4
djjlAUVI/JNlgJcNQFB+84B/HcRNWrOVB8i+3qusmfpzFxPniwa10QC+3iRqqa17
NuNtDt4YN3YGje9A8sUYqIlti6MxZZtNdrOMpJ2TzpaEdiSTpCed9f7HLxfbLw3U
P9h88y6VIeKkVMSTDyRcSArO4OLN7TbpUiZs6eKEcLx3//9fY6InppDOGK/RIedW
SlBwYU5lHQHIrJqdCB+2KDTck21qIBUod8ZsoNMp3TQKrCVT1r5yzjyqb1oR0uVz
xiugyjL1fqS1tmncN7eqVEx6xBSXkwin6KpZHPERW8iYaWJ4OSRLcT6FnIHG37CT
wAt8b6IclsabCs84Nj4uqxUoguMYssWpg34JY0noXA1XmAkFKXviC80sWPFBGEUq
S079u1r3D1OFTMsjkYV2Yxm/EKULWYCa1eg27YoG6UG5G8Nnt7q8EE7k3UypOIdA
QwImetc3I4PRgLlaY2Hfy8mU3cbG8st0u9A3LIhHu9OVFCVxRh+LKgwHOTIFh/z4
xIAkJkjCCsDZgbvYOdo97JmOSsO3z8wHY1LR7bpFhgaGF1STTW/3CDglQ43Nf5qg
BiOJN5k2NeGCdlAUrwKo
=NyJd
-----END PGP SIGNATURE-----

--C7Ke/meiCZutM6I/--
