Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaBDJKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:10:13 -0500
Received: from top.free-electrons.com ([176.31.233.9]:55097 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751234AbaBDJKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:10:06 -0500
Date: Tue, 4 Feb 2014 10:09:26 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-sunxi@googlegroups.com,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH v3 3/5] spi: sunxi: Add Allwinner A31 SPI controller
 driver
Message-ID: <20140204090926.GI25625@lukather>
References: <1391165752-1819-1-git-send-email-maxime.ripard@free-electrons.com>
 <1391165752-1819-4-git-send-email-maxime.ripard@free-electrons.com>
 <20140131124809.GE22609@sirena.org.uk>
 <20140131224704.GI2950@lukather>
 <20140204002110.GP22609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a7XSrSxqzVsaECgU"
Content-Disposition: inline
In-Reply-To: <20140204002110.GP22609@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a7XSrSxqzVsaECgU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Tue, Feb 04, 2014 at 12:21:10AM +0000, Mark Brown wrote:
> On Fri, Jan 31, 2014 at 11:47:04PM +0100, Maxime Ripard wrote:
> > On Fri, Jan 31, 2014 at 12:48:09PM +0000, Mark Brown wrote:
> > > On Fri, Jan 31, 2014 at 11:55:50AM +0100, Maxime Ripard wrote:
>=20
> > > > +	pm_runtime_enable(&pdev->dev);
> > > > +	if (!pm_runtime_enabled(&pdev->dev)) {
> > > > +		ret =3D sun6i_spi_runtime_resume(&pdev->dev);
> > > > +		if (ret) {
> > > > +			dev_err(&pdev->dev, "Couldn't resume the device\n");
> > > > +			return ret;
> > > > +		}
> > > > +	}
>=20
> > > No, as discussed don't do this - notice how other drivers aren't writ=
ten
> > > this way either.  Like I said leave the device powered on startup and
> > > then let it be idled by runtime PM.
>=20
> > Well, some SPI drivers are actually written like that (all the tegra
>=20
> It's not been done consistently, no - that should be fixed.
>=20
> > SPI drivers for example). It's not an excuse, but waking up the device
> > only to put it back in suspend right away seems kind of
>=20
> It isn't awesome, no.  Ideally the runtime PM code would do this but
> then you couldn't ifdef the operations which as far as I can tell is the
> main thing people want from disabling it and it gets complicated for
> devices that genuinely do power up on startup so here we are.

We discussed it with Kevin on IRC, and he suggested that we move that
pm_runtime initialization to the SPI core, but I guess that would also
mean that all drivers shouldn't ifdef the operations, so that the core
can call the runtime_resume callback directly.

However, I don't really get why any driver should be doing so, since
you still need these functions to at least to the device
suspend/resume in the probe/remove, and you don't really want to
duplicate the code.

Right now, about half of the SPI drivers using auto_runtime_pm are
using a ifdef, the other half is not.

> > inefficient. Plus, the pm_runtime_idle callback you suggested are
> > actually calling runtime_idle, while we want to call runtime_suspend.
>=20
> Yeah, I didn't actually check if I was looking at the right call there.

I was actually wrong, it does so in its very last line.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--a7XSrSxqzVsaECgU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS8K5GAAoJEBx+YmzsjxAgH5QQALk76NTGMUunWeqr5XCeSoEP
bYrpdT48kylB6f8LzNmd2gMe1eZE7HKgW/fBvCDGF7Ms0+jXQxPC87ucdvPuPBYr
mwtRhcTjW9WLXZM7tH/Lh8K0sJHiUYqm8MZfGLzQUm1nnZ6587utxJ8Sxy89rHIy
GAUThAcy93plh4TgkdxcBG1svn99k1kdhr+PaA0jiZ5y+yYUwGxgXOJyq5Wv68xk
9mMQ/GYPHNSFFrJbKc7PWUC1PTES07uFv+LFzpS0BzZzqku8F0OKBmLaXlNJJLJa
9zJ/WcpW9+2U2CuROjmXmdNmX46u2utCwGuqXT4XiodrjgjwekBMT50M7KCYctMa
hHvy1Ldq78/eREADJOAzofjPK+p9TVNF445Mh86SPVFcsX5l1go9A3+lSeLqPUse
8RtkwRv/Qa7+bwnyzegjru0ucXuRBPZ8hoxNPMm0FVS5bFqSS7O+MQwf6NNRSWRS
b8fkaqL+q5P0IeYke/B/FMTYvw6anctQG6gouyX9K6YqJd8MDRUfYOrpyWV+7Ya+
hfMf7M58uX1GrjLexWZn2YzreDC9fJTFzH0Hxyl/qQJTPKyZOGEdgPd1lgyxG5DT
D1td6h6TxPglyjsBttyVNtX416Uxh00XCv+ufo2QPgrRPbRy8olD+7e5+TMGa70x
ocB7Z/Fz7pY/HSS4HSBc
=43Nn
-----END PGP SIGNATURE-----

--a7XSrSxqzVsaECgU--
