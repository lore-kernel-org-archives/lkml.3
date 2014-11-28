Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbaK1PHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:07:55 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42154 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaK1PHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:07:53 -0500
Date: Fri, 28 Nov 2014 15:07:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <20141128150729.GP7712@sirena.org.uk>
References: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
 <1417087253-12306-5-git-send-email-k.kozlowski@samsung.com>
 <20141127184342.GC7712@sirena.org.uk>
 <1417170655.18249.24.camel@AMDC1943>
 <20141128113859.GH7712@sirena.org.uk>
 <1417184044.18249.39.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5YTekl7Q9pOfbcU3"
Content-Disposition: inline
In-Reply-To: <1417184044.18249.39.camel@AMDC1943>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 4/7] regulator: Use ena_gpio supplied with generic
 regulator bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5YTekl7Q9pOfbcU3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2014 at 03:14:04PM +0100, Krzysztof Kozlowski wrote:
> On pi=C4=85, 2014-11-28 at 11:38 +0000, Mark Brown wrote:

> > This sort of thing is a sign that we're not saving much by moving the
> > parsing to the core and perhaps there's more flexiblity here...=20

> The driver receive callbacks (or exposes other kind of interface) for
> other core-generalized code. Recent example is parsing regulator mode
> (added by Javier) and .of_map_mode() callback.

Right, but that's actually doing some device specific translation and
successfully factoring out the bulk of the code - the fact that it's
taking parameters and returning data is a good sign.  This is a callback
placed randomly away from any other related code (adding to the
confusion - it's not integrated into the rest of the flow around this at
all) without a clear purpose.

> I thought how to do this without this additional set_ena_gpio() call.
> One way would be to extend the regulator modes (FAST/IDLE/STANDBY/ and
> GPIO) but this would look somehow unnatural.

Yes, that's absolutely hideous.

--5YTekl7Q9pOfbcU3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUeI+xAAoJECTWi3JdVIfQwhwH/1CrTJZXExrRsl5sFVkCURuQ
pyRP5xBkiVsZ1fTL4Y/em9spw7tfbx2/iA43qcLyo8YyWN309vVQWcUaVcts2ulg
TCPAVgVb8EUfrrqPJddIVxCKqURz0qGwdGJFmJvsswG4S6rN9fvN2j8VHTTKstEb
i0QPy91wNNNl8l12+SGJinE8heOgnXiiplUzDhxtunq+MRZCQdTNoPoeEWRr9pic
4vYdwTrnwRg/GDd2E+Qdl4lSHaO2BDsmRX4sUlBlD95BIi8MfDOOCAoxmumoUQiU
FOJqdSvQhkvbXGK/hhTkrTi1DXXYxMNQaCWnDpV+oHvs9D7dDyR2t8b8pkgPxYY=
=1wcJ
-----END PGP SIGNATURE-----

--5YTekl7Q9pOfbcU3--
