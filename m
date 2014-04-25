Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaDYSio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 14:38:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:59354 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbaDYSik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 14:38:40 -0400
Date: Fri, 25 Apr 2014 20:38:33 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCHv3 09/14] Documentation: DT: omap-ssi binding documentation
Message-ID: <20140425183832.GE22721@earth.universe>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
 <1396053110-21639-10-git-send-email-sre@kernel.org>
 <CAL_Jsq+jGeuM+Vmb8uzz3-ZUvKQu=kDv3RqVY0Dudmc9XTm-BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WK3l2KTTmXPVedZ6"
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+jGeuM+Vmb8uzz3-ZUvKQu=kDv3RqVY0Dudmc9XTm-BA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WK3l2KTTmXPVedZ6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 21, 2014 at 11:43:47AM -0500, Rob Herring wrote:
> On Fri, Mar 28, 2014 at 7:31 PM, Sebastian Reichel <sre@kernel.org> wrote:
> > Create device tree binding documentation for
> > OMAP Synchronous Serial Interface (SSI) device.
> >
> > Signed-off-by: Sebastian Reichel <sre@kernel.org>
> > ---
> >  Documentation/devicetree/bindings/hsi/omap-ssi.txt | 85 ++++++++++++++=
++++++++
> >  1 file changed, 85 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/hsi/omap-ssi.txt
> >
> > diff --git a/Documentation/devicetree/bindings/hsi/omap-ssi.txt b/Docum=
entation/devicetree/bindings/hsi/omap-ssi.txt
> > new file mode 100644
> > index 0000000..709419b
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/hsi/omap-ssi.txt
> > @@ -0,0 +1,85 @@
> > +OMAP SSI controller bindings
> > +
> > +OMAP Synchronous Serial Interface (SSI) controller implements a legacy
> > +variant of MIPI's High Speed Synchronous Serial Interface (HSI).
> > +
> > +Required properties:
> > +- compatible:          Should include "ti,omap3-ssi".
> > +- reg-names:           Contains the values "sys" and "gdd".
> > +- reg:                 Contains a register specifier for each entry in
> > +                       reg-names.
>=20
> You need to define the order here unless you have a strong
> argument why you can't.

ok.

> > +- interrupt-names:      Contains the value "gdd_mpu".
> > +- interrupts:          Contains interrupt information for each entry in
> > +                       interrupt-names.
> > +- ranges:              Represents the bus address mapping between the =
main
> > +                       controller node and the child nodes below.
> > +- clocks:              Contains clock specifiers for each entry in
> > +                        clock-names.
> > +- clock-names:         Must include the following entries:
> > +  "ssi_ssr_fck": The OMAP clock of that name
> > +  "ssi_sst_fck": The OMAP clock of that name
> > +  "ssi_ick": The OMAP clock of that name
> > +- #address-cells:      Should be set to <1>
> > +- #size-cells:         Should be set to <1>
> > +
> > +Each port is represented as a sub-node of the ti,omap3-ssi device.
> > +
> > +Required Port sub-node properties:
> > +- compatible:          Should be set to the following value
> > +                        ti,omap3-ssi-port (applicable to OMAP34xx devi=
ces)
> > +- reg-names:           Contains the values "rx" and "tx".
> > +- reg:                 Contains a register specifier for each entry in
> > +                       reg-names.
>=20
> You need to define the order here unless you have a strong argument
> why you can't.

ok.

> > +- interrupt-parent     Should be a phandle for the interrupt controller
> > +- interrupt-names:     Contains the values "mpu_irq0" and "mpu_irq1".
>=20
> Those names aren't exactly useful.

I removed interrupt-names in PATCHv4.

> > +- interrupts:          Contains interrupt information for each entry in
> > +                       interrupt-names.
>=20
> You need to define the order here unless you have a strong argument
> why you can't.

ok.

> > +- ti,ssi-cawake-gpio:  Defines which GPIO pin is used to signify CAWAKE
> > +                       events for the port. This is an optional board-=
specific
> > +                       property. If it's missing the port will not be
> > +                       enabled.
> > +
> > +Example for Nokia N900:
> > +
> > +ssi-controller@48058000 {
> > +       compatible =3D "ti,omap3-ssi";
> > +
> > +       /* needed until hwmod is updated to use the compatible string */
> > +       ti,hwmods =3D "ssi";
> > +
> > +       reg =3D <0x48058000 0x1000>,
> > +             <0x48059000 0x1000>;
> > +       reg-names =3D "sys",
> > +                   "gdd";
> > +
> > +       interrupts =3D <55>;
> > +       interrupt-names =3D "gdd_mpu";
> > +
> > +       clocks =3D <&ssi_ssr_fck>,
> > +                <&ssi_sst_fck>,
> > +                <&ssi_ick>;
> > +       clock-names =3D "ssi_ssr_fck",
> > +                     "ssi_sst_fck",
> > +                     "ssi_ick";
> > +
> > +       #address-cells =3D <1>;
> > +       #size-cells =3D <1>;
> > +       ranges;
> > +
> > +       ssi-port@0 {
>=20
> Does this h/w really have more than 1 port?

Yes. I added this to the example in PATCHv4.

> This should really be "ssi-port@4805a800" Or you need to fill in
> ranges to have a local offset.

ok.

>> [...]

-- Sebastian

--WK3l2KTTmXPVedZ6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTWquoAAoJENju1/PIO/qaFDIP/j+LmisTdmEr9ZsOjgBGa8Ka
wGY4/UKwJvWFYETSkxuVxCeuM0Ndd88OSc2uEf748/Q3c4WoB+7ugIt/PyxngFYc
yMTtU8MQg3QVlWWb7OXjRgAzmUlV4W2p8qLB6VZuRsPpi8k9hYMw4/hoD/PxTew8
AeXCU/mIGkdKaUm3qhd5uCW76Iovw/11xC+ZY+lma7vVnwq44dU1ZNHRgXz9YxG2
Xa5Tx+M158ORCxyiSoNAqck/jKG3NOz8SFhsoM+XKotrD6uWPkxfZIKbrIuIhHE3
NkmMmP6SNc2TibT5W6n6PploQW75k98P/Qw4PTS0Vu7I4JENIPEs1vcXbpqZDXC/
OXu1JdVxI8ckNc0CAcOeoMURkqEJEYa573CWjkTpa6U/eciVfDpjqy2a8MM3gneh
i/pxl6vBwUjx2HUpaxc3Y9fgs1us9VrERIcQ2Q0UT3RnKYax1Igf9f+PeQpTDfio
4SVb904iVxEFdgmedb4/zujsIYad8mdcw0BrJ5yi9RsB7pcm3QtKohe0kecmsCcF
YO9pP0dYWUwzSpD0uQSnvBBATl9QRYOyAjqcbq4GnVMDmoOE/Jz5aDs0ceD115jM
dWVr7YiuUzu+tRSBrNLC84vUkcbo47eUBDW+UT4eymo8UfQ8OOZGu79+BLTXo2NG
KjCVFngZCjZauDLwdVVZ
=WwJN
-----END PGP SIGNATURE-----

--WK3l2KTTmXPVedZ6--
