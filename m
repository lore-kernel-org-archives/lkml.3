Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbaBDSnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:43:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35419 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaBDSni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:43:38 -0500
Date: Tue, 4 Feb 2014 18:43:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Simon <horms@verge.net.au>, Magnus <magnus.damm@gmail.com>,
        Linux-SH <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org
Message-ID: <20140204184327.GS22609@sirena.org.uk>
References: <87eh3o7mfc.wl%kuninori.morimoto.gx@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0Cw7BmXaMEMLlkEt"
Content-Disposition: inline
In-Reply-To: <87eh3o7mfc.wl%kuninori.morimoto.gx@gmail.com>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: gpio: bugfix: add gpios-status for DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0Cw7BmXaMEMLlkEt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 30, 2014 at 09:25:14PM -0800, Kuninori Morimoto wrote:
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>=20
> config->gpios[x].flags indicates initial pin status,
> and it will be used for drvdata->state
> on gpio_regulator_probe().

I've applied this, thanks.  However, a couple of things that it'd be
nice to improve with followup patches:

> +- gpios-states		: gpios pin's initial states. 1 means HIGH

A mention that this is an array of values would be good (it's clear from
the code but not from the document), as would saying that the defualt is
low if nothing is specified.

> +		if (proplen !=3D config->nr_gpios) {
> +			/* gpios <-> gpios-states mismatch */
> +			prop =3D NULL;
> +		}
> +	}

It's probably worth printing a warning here.

--0Cw7BmXaMEMLlkEt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8TTMAAoJELSic+t+oim9W6UP/3PDE+LPAIdzs3IBanyL823M
/+Jty5iOx7QATH17C5e/RDvk3CKFTGHE+8AqtJnF3GogJzQ8DGI4kjJ41ZshxSNA
6b6d3QhLU71DWYc1VBINqpFIJEIZricE/wNTsgLDLvhwVjYd4ujwds+YSLLHIcSG
s6V2bkll5owymtibpYZteAr7wbTOt9/yZSuysxTYX/Ry0AUA7xvTn0UEy0nJ7gv+
BbinLY2tLqoR6fjdiEZZDbosZb1MSj09bKpAL5cAgukTkqZFyJtvfhEkrOxMZgml
X4EfbcihiPIijpFeeRPhyuj9dyY5SflfgWkVjdLaDpLeAIM/lMhA+cONj/i8SnPM
wmUiIVcm8el99YrjXTup9M2f7qRsan+TeEAsM5RVwZTU8A4CGdVh1BRVMG2gsSE4
3ucfPXyL0eea+aOWDUfKD3UGWomm6d6gXZ+tjve85Z5ZhJPNon0mI+VYinVSLKPu
K7FoUraohY9ZKbBMwqyhIHAf5Hr265T2a2/q0zRms5wMm8XLdb7y8vHfSns9DdIz
WXA/cdKYJ+ogeyeI8Ymw25Py4Gsedlddi4k7lwN4KIJ8JjKmogneDpuaQCvTv3UL
3QymemnNj9ttgDVXryQXTSUfWmTQvEgfjyJrlMUmPy8tyBUvjM2oiuq8dGcLjaFl
ZR1DBIay4JW9EWNPcz7N
=yvkP
-----END PGP SIGNATURE-----

--0Cw7BmXaMEMLlkEt--
