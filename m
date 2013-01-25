Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab3AYQYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:24:18 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40285 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504Ab3AYQYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:24:17 -0500
Date: Fri, 25 Jan 2013 18:23:46 +0200
From: Felipe Balbi <balbi@ti.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "tony@atomide.com" <tony@atomide.com>,
        "b-cousson@ti.com" <b-cousson@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 1/4] drivers: usb: phy: add a new driver for usb part
 of control module
Message-ID: <20130125162346.GM28379@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359109440-2195-1-git-send-email-kishon@ti.com>
 <1359109440-2195-2-git-send-email-kishon@ti.com>
 <20130125110141.GK3075@e106331-lin.cambridge.arm.com>
 <20130125111120.GP15886@arwen.pp.htv.fi>
 <20130125122943.GB16795@e106331-lin.cambridge.arm.com>
 <20130125145928.GC28379@arwen.pp.htv.fi>
 <20130125161401.GD16795@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SEFvVLxbW/dEDtN8"
Content-Disposition: inline
In-Reply-To: <20130125161401.GD16795@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SEFvVLxbW/dEDtN8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 25, 2013 at 04:14:02PM +0000, Mark Rutland wrote:
> On Fri, Jan 25, 2013 at 02:59:28PM +0000, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Fri, Jan 25, 2013 at 12:29:43PM +0000, Mark Rutland wrote:
> > > > > > +   depending upon omap4 or omap5.
> > > > > > + - reg-names: The names of the register addresses correspondin=
g to the registers
> > > > > > +   filled in "reg".
> > > > > > + - ti,type: This is used to differentiate whether the control =
module has
> > > > > > +   usb mailbox or usb3 phy power. omap4 has usb mailbox in con=
trol module to
> > > > > > +   notify events to the musb core and omap5 has usb3 phy power=
 register to
> > > > > > +   power on usb3 phy. Should be "1" if it has mailbox and "2" =
if it has usb3
> > > > > > +   phy power.
> > > > >=20
> > > > > Why not make this a string property, perhaps values "mailbox" or =
"register"?
> > > >=20
> > > > NAK.
> > >=20
> > > Can I ask what your objection to using a string property is?
> > >=20
> > > As far as I can see, "ti,type" is only used by this driver, so there'=
s no
> > > common convention to stick to. Using a string makes the binding easie=
r for
> > > humans to read, and thus harder to mess up in a dts, and it decouples=
 the
> > > binding from kernel-side constants.
> >=20
> > IIRC there is some work going on to add #define-like support for DT,
> > which would allow us to match against integers while still having
> > meaningful symbolic representations.
>=20
> I was under the impression that the motivation for using the preprocessor=
 on
> the DT was to allow symbolic names for device/soc-specific values like
> addresses, rather than what amounts to ABI values for the binding.
>=20
> I don't see the point in building a binding that depends on future
> functionality to be legible, especially as we can make it more readable,
> robust, and just as extensible today, with a simple change to the proposed
> binding.
>=20
> Even ignoring the above, the driver isn't doing appropriate sanity checki=
ng.
> If you use a string property, this sanity check is implicit in the parsin=
g --
> you've either matched a value you can handle or you haven't.

Even IRQs use numbers (not talking about the IRQ number, but the IRQ
flags), why would we depend on string comparisson ? It doesn't make
sense.

--=20
balbi

--SEFvVLxbW/dEDtN8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRArGSAAoJEIaOsuA1yqREMuIP/0aHXTwjHfpWxaLlSozoNOAq
o4lXxjEXo0h4G6izLWq2rlQYf8gFlMOfgbqnb2lAVfjDhYAL7uWpMk9NfwShs2ao
RHfsmOpE0rtGejg7xxVTI/I+HK+sqKCyjcZnmLyHI6x0HdQ+QQO+P3x/kgSFGkFM
uj6kD9TZ/QTUy8HiDhCVHpKM8IsG4Lx+0/uceusgwDZf6MyDYPM5UXq+twH9mZeu
pfGr4COG/8y7Wq4iDym96XfXdHHLvvJOCZvf9V30sPffF+92YQTXf6yfeSoFWXGH
89FOtEsiLIK5/ZW56YQCXgj/8PPabeYyeL15pgt/GUW0uQ2arfX4PASygt4j4dy/
4vAC1CYmPpslfa0zlMDMiPoDtNJLIvWpXPkVjm9bSnx+Y5HR1F2A34nM3B+SYv+K
q5EO/5pfB6uL54ORfpv/G4fFWWUHmcmBAJugCtoJ+lxPZl6wllL5TNTFop1viA8B
e0Y1yvfVOeYgnUY41WMJpb9vclJWmWGj8XC93wJ7X2Piunz4009sNyPkdL7kTg1H
b5dE5RJGrqwMKXBPWdqq7dlHDRcGngEr/lf62Hb/vKu59Y2bX0sOfvoOkbcU2c/5
iHvtklCzLd54uwtbW1ex0Yp2CDgtfcMpN5RlBF++iWGQ0g6HkkR37QaSTG4rOV8U
+sGJea8sk18Nx2EBobN9
=8qZx
-----END PGP SIGNATURE-----

--SEFvVLxbW/dEDtN8--
