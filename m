Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaIJIme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:42:34 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:55191 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaIJImb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:42:31 -0400
Date: Wed, 10 Sep 2014 10:42:20 +0200
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <Pawel.Moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH V3] pwm: lpc32xx - Add a driver for the motor PWM
Message-ID: <20140910104220.44558cf7@avionic-0020>
In-Reply-To: <20140909160548.GB3896@leverpostej>
References: <1410277361-26848-1-git-send-email-alban.bedel@avionic-design.de>
	<20140909160548.GB3896@leverpostej>
Organization: Avionic Design
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/LrSXqGn3aX/=Y0tIALeDQOi"; protocol="application/pgp-signature"
X-Provags-ID: V02:K0:w2fCt6ESfytjpcygjyHJV5hg5xd0FmGCGWTUsBJZSoM
 FesX/RSsCZgPqoUBK1+n67L3ocAYCvEnDOZLgF+aQ7UsBrsRGD
 r2h9eMTN2L2n0x1BWR7Syr5VJH33SHosNJmzeMXZ5OHbR1RZws
 Ofy+InZOinba9mcst11dxfIqa+s+ir3S7HSo063uetMIJfzJbp
 FPhDgPD+VY+jZBQFpgMzpMwY1MPbXFvlz3fa7tfR/NH3NrC0Lx
 RiqR47YFvVShi9z5GBmt9sZzSPrYZ5+wgR8OrjW4lom5cO1lDm
 yjhgO6mmgX0fxAO7FKWJyQv8OuKRyrqzfJbipdrAFGVEx1P6y9
 DNbOSHLzNzcPzChhepj0zeD6OlZsns/xGlNCkcOvMzG8ugyAJK
 yA4/x01ByH20A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/LrSXqGn3aX/=Y0tIALeDQOi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 9 Sep 2014 17:05:48 +0100
Mark Rutland <mark.rutland@arm.com> wrote:

> On Tue, Sep 09, 2014 at 04:42:41PM +0100, Alban Bedel wrote:
> > The LPC32xx motor PWMs have two output pin, A and B, with B =3D !A.
> > The driver can switch the polarity to allow use either output pin A
> > or output pin B.
> >=20
> > Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
> > ---
> > V3: * Updated to current mainline API
> >     * Fixed LPC32xx vs. LPC32XX
> >     * Various coding style fix
> > V2: * Splitted the DTS to its own patch
> > ---
> >  .../devicetree/bindings/pwm/lpc32xx-motor-pwm.txt  |  24 +++
> >  drivers/pwm/Kconfig                                |  10 +
> >  drivers/pwm/Makefile                               |   1 +
> >  drivers/pwm/pwm-lpc32xx-motor.c                    | 210 +++++++++++++=
++++++++
> >  4 files changed, 245 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/pwm/lpc32xx-motor=
-pwm.txt
> >  create mode 100644 drivers/pwm/pwm-lpc32xx-motor.c
> >=20
> > diff --git a/Documentation/devicetree/bindings/pwm/lpc32xx-motor-pwm.tx=
t b/Documentation/devicetree/bindings/pwm/lpc32xx-motor-pwm.txt
> > new file mode 100644
> > index 0000000..decc27c
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/pwm/lpc32xx-motor-pwm.txt
> > @@ -0,0 +1,24 @@
> > +LPC32xx Motor PWM controller
> > +
> > +The LPC32xx motor PWMs have two output pin, A and B, with B =3D !A.
> > +By default, output A should be used, if output B is used the PWM
> > +polarity should be inverted using the linux,polarity property.
> > +
> > +Required properties:
> > +- compatible: should be "nxp,lpc3220-motor-pwm"
> > +- reg: physical base address and length of the controller's registers
> > +
> > +Optional properties:
> > +- linux,polarity: Bit mask of the polarity to use for each output,
> > +      a bit set to 0 indicate the default polarity, a bit set to 1
> > +      indicate an inverted polarity. In other word this set if output
> > +      pin A or output pin B has the correct polarity.
>=20
> What exactly does linux have to do with the choice of pin? Why should
> this be "linux,polarity"?

Right, I'll remove this in favor of the standard 3 cells pwm specifiers.

> > +
> > +Examples:
> > +
> > +mpwm@400e8000 {
> > +	compatible =3D "nxp,lpc3220-motor-pwm";
> > +	reg =3D <0x400E8000 0x78>;
> > +	linux,polarity =3D <0x5>; /* Use outputs B0, A1 and B2 */
>=20
> This doesn't match the description of there being two output pins. I
> take it the description above is somewhat misleading?
>=20
> > +	#pwm-cells =3D <2>;
>=20
> The format of these cells should be described.
>=20
> Wouldn't it make more sense to describe the polarity in the
> pwm-specifier? It seems like a property of the connection rather than
> the PWM controller itself.

Yes, will be done.

>=20
> > +	lpc32xx->clk =3D devm_clk_get(&pdev->dev, NULL);
>=20
> No clock was described in the binding.
>=20
> Is there only the one clock feeding the pwm? (rather than separate
> interface and pwm clocks).

There is only one clock for this PWM block.

> Please describe clocks in the binding. If the clock inputs are named,
> please use clock-names.

No clock is defined in the current LPC32xx DTS, what should I do in
this case?

Alban

--Sig_/LrSXqGn3aX/=Y0tIALeDQOi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEA7sAAoJEHSUmkuduC28fTUQAL5BLUJ8AYl9/1zQiE/F5QPs
uaHrSNFOs00YSjycAG+KhsWxvbe0oEW4HtaPpr1GqvQ8oUgFWpMW5st3/zbsB5Ow
M8CzX+v4ehc1cQ0BIsfqwF9pafmh8qyBw0068PDgc1klFlEVYsU4y1yHYBj00ORT
86hDXWdgOmAT8DID5icKZGtjf86DUsva/RrbT7qaQk0Zzqxz1KryriK12YK/Ns8/
upeI2BXAoWQzPTv1Mfdo+z+m7IEiGh1WMutHaDx/P2O1gngxlSrwijsXZYBdoY2N
j73EsJHzJ2oMoV7+QfqC6sdDuzs/EcqkREjGIomDBPsNDdxZ0fK9GTTl/6/I33HE
TEjLzi2X/YbmSSMy6Fu6XvpMw6l44tUpvs/Ds3Y57ZjQhh8X4YEMzdaiJ9/Znret
crsgTvWl+Qv0OsK1w1O+KHOIpIyf6agIxu383j77OGB4cGROE4tr6mxvT0J2ZSqR
c5RF4ngtwUiBmcpDofEjdlVJMU1Tm8/tPF6rrxXIXSKF5rAWzhQZZPVfmsT6fTT5
3gZBPQqZCC6LtTA3hisJ5Qi3Fi3RhV58HSI/URz+Co3g8tcQ21BFWUdCPvFbCdil
nOqGjIb0dvVFCCWNg9zeLCRKWK46vCPna6yVTP8q/hggnXzztrYYKfbFy/Tb6FID
U1Ihr0OlsUjO9VpunN47
=3rgT
-----END PGP SIGNATURE-----

--Sig_/LrSXqGn3aX/=Y0tIALeDQOi--
