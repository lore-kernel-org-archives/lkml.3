Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762609Ab3IDNYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 09:24:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59029 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762404Ab3IDNYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 09:24:50 -0400
Date: Wed, 4 Sep 2013 14:24:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "denis.ciocca@st.com" <denis.ciocca@st.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Message-ID: <20130904132439.GA10155@sirena.org.uk>
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
 <1378287103-21765-12-git-send-email-lee.jones@linaro.org>
 <20130904131111.GJ18206@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <20130904131111.GJ18206@e106331-lin.cambridge.arm.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 11/11] iio: pressure-core: st: Provide correct regulator
 support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 04, 2013 at 02:11:11PM +0100, Mark Rutland wrote:
> On Wed, Sep 04, 2013 at 10:31:43AM +0100, Lee Jones wrote:

> > +	/* Regulator not mandatory, but if requested we should enable it. */
> > +	pdata->regulator =3D regulator_get(&indio_dev->dev, "vdd");
> > +	if (!IS_ERR_OR_NULL(pdata->regulator)) {

> Can regulator_get return NULL? As far as I can see, it either returns a
> valid reulator pointer or an ERR_PTR value.

Yes, NULL is a valid regulator.

> When you say "if requested", do you mean "if described in the dt"? If
> so, the above doesn't distunguish between a regulator not being listed
> and one failing to be got (e.g. if we got EPROBE_DEFER from
> regulator_get).

> I think this would be better handled with something like Mark Brown's
> suggested regulator_get_optional [1,2].

If the regulator may genuinely be absent from the system then it should
be being requested using regulator_get_optional().  Otherwise it should
be being requested using regulator_get().  In both cases it is important=20
that the driver pays attention to errors.

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJzSUAAoJELSic+t+oim9GsoQAJ2QeAiazr61zg2oScTu88Qd
xTV/3LgPZ0ZHJwWWelWS3y6TpMSUYlx/5lFj1bjiQNtdxZ8ITYWM6l1/ipiQ9bsQ
e3t2Vd29bvwNYUlmO0p5zzRWH26BttY7fjaq1BeJ29IPLW8FknTTPJIjESD+MiGD
ZdStP/vRsgKoOvjyy3hlAX1LpsTFACWIcTmvCM0I5HB12aisXt+LnID4uiufJCKd
ibyZf+tqCO9mTfOFhLTo1SUErOJ8xqmytYcM0+sf5Rwj/R+tzJ133G9ACNoLb/WG
o4y54UrUZh8/RhsK/JrmmyvAH3287RbxlwhENgKMdISOoXDmtBi6gGp79bTGFfjQ
ovqzrUNLAGT76AI2X55pyp9qngWbMv5yFYn+Jl1mYkb7qWvhUI41xtPJoTrnHPXP
m6wLGGRKFQuaJPJ/ZLS45C6hVMEJ81cSugiAKArKGebTer89PAe9QE4EVMHDL/a8
XJMxXX1CV/pahFeG1zFYQcilPQmlDtoCcc8y50R52E3wcuBHOHtPQ61XutBkBvU3
z2BWQc8cEMKtYsSMOvbFYvvR0M8krUCbzKWyh7rH/SNOV36NMWs0mK6MGV6QYIeH
lBDDsV7NJRlAkq5+LFgaAFA8eF+PpD4+zKlBwpW9s2CzciFw7oxt0XAL1TnNdKVd
4FO+YnPIxUbLVk1PdoYl
=ALTj
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
