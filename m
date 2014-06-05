Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326AbaFEOaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:30:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58302 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750809AbaFEOaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:30:04 -0400
Date: Thu, 5 Jun 2014 16:27:29 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: carlo@caione.org, Boris Brezillon <boris@free-electrons.com>,
        lgirdwood@gmail.com, lee.jones@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH 3/5] regulator: axp20x: Update the bindings to use a
 local parent regulator
Message-ID: <20140605142729.GG5765@lukather>
References: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
 <1401297069-7423-4-git-send-email-maxime.ripard@free-electrons.com>
 <20140528185051.GB22488@sirena.org.uk>
 <20140603131204.GJ27722@lukather>
 <20140603144319.GD31751@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XRI2XbIfl/05pQwm"
Content-Disposition: inline
In-Reply-To: <20140603144319.GD31751@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XRI2XbIfl/05pQwm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 03:43:19PM +0100, Mark Brown wrote:
> On Tue, Jun 03, 2014 at 03:12:04PM +0200, Maxime Ripard wrote:
> > On Wed, May 28, 2014 at 07:50:51PM +0100, Mark Brown wrote:
> > > On Wed, May 28, 2014 at 07:11:07PM +0200, Maxime Ripard wrote:
>=20
> > > >  		axp_mic_reg: ldo5 {
> > > > +			vin-supply =3D <&axp_ipsout_reg>;
>=20
> > > This is saying that every single regulator on the device is powered b=
y a
> > > (presumably) single input called "vin".  This would certainly be an
> > > unusual package design...  As ever the name of the supply should foll=
ow
> > > the name of the pin on the device.
>=20
> > Not exactly. Each regulator has its own input pin, named
> > <regulator_name>in in the schematics, with the exception of LDO2 and
> > LDO4 that share the same pin.
>=20
> OK, so the supplies should be called <regulator_name>in then not vin.

Which they already do. So I guess we don't have to change the bindings
after all. One last thing I fail to understand though, is why do we
need to have that duplication of the informations between the mfd
driver and the regulator one.

You already list the regulators available and their supply in the
regulator driver, why do you need to set the regulator parents in the
mfd driver as well?

My guess is that it's to work around the fact that
regulator_dev_lookup only looks for the regulator's device of_node (so
not the PMIC one, but one of its child), which doesn't have the supply
properties, and then just falls back on the regulator alias
list. Would it make some sense to add a lookup in the parent device
of_node (which would be the "main" PMIC node in our case)?

Also, there's also the fact that all the supply properties seems to
also be mandatory in the DT, even though the regulator itself might
not be used at all on the board, and the input voltage not wired to
anything.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--XRI2XbIfl/05pQwm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTkH5RAAoJEBx+YmzsjxAgtugP/iQx823+n/r1wqxS4d5vUDYg
NrhrpuO+NCJWO06R7edTY3LU84whEJb8ZczKwtznL0dh1x9FETHf9GzvPXjrCypl
i/4bP4qDjoAEqfgs/VhRRLsFS+8sx5qoUsgJyfjuc3ak6iZV31shSD2RP9hbICTR
7C1xtEUhPHfijq4pidgwTas/BM1G3ZOd7pdU19ceBu2tiAX+AdMu05a0s62DK+eW
Omj2s4lnLBL6StHWkE0/gYXfdOH2uFHMqiuAoKSOGtnrrRi5dnY6XrdjzqwSB6ne
i5/f1SKr6YQgRMS/YZAYDwrK/gS1iNgOO07CEM8sIRHMSX7hr8ZxorhI5ygdm/4f
AeAkvgo86x1xbBTSaZ0wuImN/LtiC33xsV97kYKZn0ucAlEHI32XBooPwOq4A/W3
tC5r+ZuLDQEVoBu+2TkSUrdS7zlgg5GtljF/0SRIULvE3T5KGri+KTEU6Ya2Q8oH
iIm5oigJHI+a7wDDFAjXTEk09ID8SCRH6ZKqZHsUC821T4vJ/vR2FDSkjacuWLlw
L+qcML7iv2vTKJ0Ctqa30ny/cXFlmOS0kes+FrdX5KYC1ejdN4AxV79sqD00mpUj
bmVZ6QzcBVc6K9h0BHxWiQE2P2NvoWEF3halFDhQWf59WdYEzz5DtqaJS30WDXCe
1kHJNd54zpa8lrSrUIm3
=EYqd
-----END PGP SIGNATURE-----

--XRI2XbIfl/05pQwm--
