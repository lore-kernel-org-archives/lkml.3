Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab3F1LmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 07:42:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43582 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab3F1LmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 07:42:11 -0400
Date: Fri, 28 Jun 2013 14:41:29 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: Mark Rutland <mark.rutland@arm.com>, <mturquette@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm@vger.kernel.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] Documentation: dt: bindings: TI WiLink modules
Message-ID: <20130628114129.GO11297@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372149330-24335-1-git-send-email-coelho@ti.com>
 <20130628093848.GA2139@e106331-lin.cambridge.arm.com>
 <1372413215.21065.41.camel@cumari.coelho.fi>
 <20130628102145.GB2139@e106331-lin.cambridge.arm.com>
 <1372415514.21065.50.camel@cumari.coelho.fi>
 <1372418531.21065.53.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AKkMM/tm2Mk6Yn/s"
Content-Disposition: inline
In-Reply-To: <1372418531.21065.53.camel@cumari.coelho.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--AKkMM/tm2Mk6Yn/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2013 at 02:22:11PM +0300, Luciano Coelho wrote:
> On Fri, 2013-06-28 at 13:31 +0300, Luciano Coelho wrote:
> > (fixed Mike's address)
> >=20
> > On Fri, 2013-06-28 at 11:21 +0100, Mark Rutland wrote:
> > > On Fri, Jun 28, 2013 at 10:53:35AM +0100, Luciano Coelho wrote:
> > > > On Fri, 2013-06-28 at 10:38 +0100, Mark Rutland wrote:
> > > > > On Tue, Jun 25, 2013 at 09:35:30AM +0100, Luciano Coelho wrote:
> > > > > > +Optional properties:
> > > > > > +--------------------
> > > > > > +
> > > > > > +- refclock: the internal WLAN reference clock frequency (requi=
red for
> > > > > > +  WiLink6 and WiLink7; not used for WiLink8).  Must be one of =
the
> > > > > > +  following:
> > > > > > +	0 =3D 19.2 MHz
> > > > > > +	1 =3D 26.0 MHz
> > > > > > +	2 =3D 38.4 MHz
> > > > > > +	3 =3D 52.0 MHz
> > > > > > +	4 =3D 38.4 MHz, XTAL
> > > > > > +	5 =3D 26.0 MHz, XTAL
> > > > > > +
> > > > > > +- tcxoclock: the internal WLAN TCXO clock frequency (required =
for
> > > > > > +  WiLink7 not used for WiLink6 and WiLink8).  Must be one of t=
he
> > > > > > +  following:
> > > > > > +	0 =3D 19.200 MHz
> > > > > > +	1 =3D 26.000 MHz
> > > > > > +	2 =3D 38.400 MHz
> > > > > > +	3 =3D 52.000 MHz
> > > > > > +	4 =3D 16.368 MHz
> > > > > > +	5 =3D 32.736 MHz
> > > > > > +	6 =3D 16.800 MHz
> > > > > > +	7 =3D 33.600 MHz
> > > > >=20
> > > > > This looks suspiciously like what we have the common clock bindin=
gs for:
> > > > >=20
> > > > > refclk {
> > > > > 	compatible =3D "fixed-clock";
> > > > > 	#clock-cells =3D <0>;
> > > > > 	clock-frequency =3D <19200000>;
> > > > > }
> > > > >=20
> > > > > wilink {
> > > > > 	compatible =3D "ti,wilink7";
> > > > > 	interrupt-parent =3D <&some_interrupt_controller>;
> > > > > 	interrupts =3D <0 1 1>;
> > > > > 	clocks =3D <&refclk>, <&refclk>;
> > > > > 	clock-names =3D "refclk", "txoclk";
> > > > > };
> > > > >=20
> > > > > Could you not use them?
> > > >=20
> > > > Hmmm... this actually does look good.  But these are internal clock=
s in
> > > > the modules, they cannot be accessed from outside.  Does it make se=
nse
> > > > to register them with the clock framework?
> > >=20
> > > Given we already have a common way of describing clocks, I think it
> > > makes sense to use it -- people already understand the common binding=
s,
> > > and it's less code to add add to the kernel. I don't think the fact
> > > these clocks are internal should prevent us from describing them as we
> > > would an external clock.
> >=20
> > Yes, I agree with you.  Thanks for the suggestion! I think it will look
> > much better.  And now that I dug a bit more into the code, I can see
> > that there are only structs being populated, so there shouldn't be any
> > other side-effects.
>=20
> Hmmm, one thing that escaped me.  Besides the frequency, I also need a
> boolean that tells if the clock is XTAL or not.  I can't figure out how
> to pass this if I use the generic clock framework.  Any suggestions?

Could you use clock-output-names for that ?

XTAL clock:

refclk {
	compatible =3D "fixed-clock";
	#clock cells =3D <0>;
	clock-frequency =3D <19200000>;
	clock-output-names =3D "xtal";
};

non-XTAL clock:

refclk {
	compatible =3D "fixed-clock";
	#clock cells =3D <0>;
	clock-frequency =3D <19200000>;
	clock-output-names =3D "osc"; /* any better name ? */
};

--=20
balbi

--AKkMM/tm2Mk6Yn/s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzXZpAAoJEIaOsuA1yqREpDMP/jbHHQ1Jyhg2J9Z0lPTKg6dw
GU2mSD1LJx4mZqPQUHNHzZozuJTIMkKZNzXGd6nkAjI1+7jsEBJkN/fAOdERrEzP
FrckjCk/+gb0Wl3ROag/ZMMQg9onO6KWp/qecwOqti3G0rk+/spsli9OZUO2ub1y
rRd4bm28qid+bykaV5ZCwmZ9IlJXX8///Nl/aViscpiHTHLiPx0e9+dCFnoqTQN7
X8SyjuANmTtwGvpXpP2/b1oMiI9PDbIxPrAeqm+IL9jP67zeD1gYo+Rxfe63nqSE
E8oCPCHL2d55BVAP4PgkuJgGZX7k4Ts0rU1YQZ28SjdG5Wl/ieIE7n1XM/xBq2BU
aLm3Ua6Wqsx9lQhXiyF7SsAenN/gwTkV+4Y7acbYjvM1UJwDfODQsxHFqPHQvd0I
QXqJOS+ffe3XZwuamgSu5hhClM2cGvA0r5va4HICojKeRGfBQhtc/vHh9s6n6Uzj
Z8RHsCA4c/+44Ah9+d+mKUVVV/rEFi9V3YcBeKkxYVJ98TDpcbAMw949Ie9m/RSU
w+JDlgGRwq+Ts6USkZ3nyPUZguhSuZPh0QvbCn5sfFPfR1nHJ4DY+HWP507MFV+V
3EQtt+KXpp3P1Bkd7mc2NwBORoxREKl/5ugbTScUNDglM+wcPQozXBVF/vHGr2py
lZic5Dq/viEFe73aA8Ub
=Z66b
-----END PGP SIGNATURE-----

--AKkMM/tm2Mk6Yn/s--
