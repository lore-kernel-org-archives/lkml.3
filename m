Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaEZPob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:44:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43370 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbaEZPoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:44:30 -0400
Date: Mon, 26 May 2014 16:43:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Carlo Caione <carlo@caione.org>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dev@linux-sunxi.org
Message-ID: <20140526154356.GZ22111@sirena.org.uk>
References: <1401116292-24066-1-git-send-email-boris.brezillon@free-electrons.com>
 <1401116292-24066-6-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UGLm9xuS8q6+r3sQ"
Content-Disposition: inline
In-Reply-To: <1401116292-24066-6-git-send-email-boris.brezillon@free-electrons.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.185
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 5/5] regulator: axp20x: resolve self dependency issue
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UGLm9xuS8q6+r3sQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2014 at 04:58:12PM +0200, Boris BREZILLON wrote:
> Some regulators might take their power supply from other regulators defin=
ed
> by the same PMIC.
>=20
> Retry regulators registration until all regulators are registered or the
> last iteration didn't manage to register any new regulator (which means
> there's an external dependency missing and we can thus return
> EPROBE_DEFER).

This is going to apply to most PMICs - we should factor this out into
the core rather than implementing it individual drivers.  It works
normally because typically the dependency is from DCDCs to LDOs and so
with common naming schemes alphabetic sorting saves us.

--UGLm9xuS8q6+r3sQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTg2E5AAoJELSic+t+oim9jDQP/1mIHM0QRFZd0sJyzsOaRc/8
sWzADKWJxcyZaMWpmedfFi1Kj+la8QOfvLZvIMOw6Q21nwGaRoIc2NOHasZptwnn
85eVHG8cHgMTeCvd1I3v1d8Rv7vj1pA3LQSTGM3M+QCVHlLRrw5gfgqZB7FN4jQK
1N/wfRTo/VGkh0eR0fTJiYFG6hA2mGIvRgvA+MkTj+zXL9+WMMpEhtcYaY9r1w8b
WfmmyJIgMhht0hpRILDkW9Q/1o+DRsTDCyQqwNeU9SFopK64VVKb7eNLvU07Ds/H
Y6wWZQ25IHyTiBnkpfRAxerOFxsA9DONy+7dz6FwyLQu0b1MA/NztEpWo5suvmio
cpcgw+5bwGePH/1PDPZv4GHjiTaX3mfOPyXmFC0lnuSVWA/SnUdm/kXHB5tZnYLo
OPTVxMrr0koj4r+5iqEQZwch0sqzNnmd2gFKmRA8eMtJ7Pxxez6f1Je2deeojDK9
Bqrs3nC9OvRq/16dd4DYbTxOdNs0pGux1uYKFgUvCgSzHjjWK45TaUyUKAk4MZEG
8HiKkTQUMEcMxK3Fb+2hkMcc8vvHZL+AwCf+0ATyk8bnfqPYnXbRWmSY6txF1D8H
Yoqd/6NjV8Hxl1+pRXPfPLAkbpw1BlbUr9rIHVbW7thZW+hev7KDxXOvB9TVKi08
KGB//i28gw4ssZU26z52
=GEhc
-----END PGP SIGNATURE-----

--UGLm9xuS8q6+r3sQ--
