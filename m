Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaJFMX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:23:29 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:51502 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaJFMX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:23:26 -0400
Date: Mon, 6 Oct 2014 14:23:23 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v7 04/11] pwm: add DT bindings documentation for
 atmel-hlcdc-pwm driver
Message-ID: <20141006122322.GA26833@ulmo>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
 <1412175188-28278-5-git-send-email-boris.brezillon@free-electrons.com>
 <20141006101350.GD25202@ulmo>
 <20141006113326.GG24686@leverpostej>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <20141006113326.GG24686@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 06, 2014 at 12:33:26PM +0100, Mark Rutland wrote:
> On Mon, Oct 06, 2014 at 11:13:51AM +0100, Thierry Reding wrote:
> > On Wed, Oct 01, 2014 at 04:53:01PM +0200, Boris Brezillon wrote:
> > > From: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > >=20
> > > The HLCDC IP available in some Atmel SoCs (i.e. sam9x5i.e. at91sam9n1=
2,
> > > at91sam9x5 family or sama5d3 family) provide a PWM device.
> > >=20
> > > The DT bindings used for this PWM device is following the default 3 c=
ells
> > > bindings described in Documentation/devicetree/bindings/pwm/pwm.txt.
> > >=20
> > > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > > ---
> > >  .../devicetree/bindings/pwm/atmel-hlcdc-pwm.txt    | 55 ++++++++++++=
++++++++++
> > >  1 file changed, 55 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/pwm/atmel-hlcdc=
-pwm.txt
> > >=20
> > > diff --git a/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.tx=
t b/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
> > > new file mode 100644
> > > index 0000000..86ad3e2
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
> > > @@ -0,0 +1,55 @@
> > > +Device-Tree bindings for Atmel's HLCDC (High LCD Controller) PWM dri=
ver
> > > +
> > > +The Atmel HLCDC PWM is subdevice of the HLCDC MFD device.
> > > +See ../mfd/atmel-hlcdc.txt for more details.
> > > +
> > > +Required properties:
> > > + - compatible: value should be one of the following:
> > > +   "atmel,hlcdc-pwm"
> > > + - pinctr-names: the pin control state names. Should contain "defaul=
t".
> > > + - pinctrl-0: should contain the pinctrl states described by pinctrl
> > > +   default.
> > > + - #pwm-cells: should be set to 3. This PWM chip use the default 3 c=
ells
> > > +   bindings defined in Documentation/devicetree/bindings/pwm/pwm.txt.
> > > +   The first cell encodes the PWM id (0 is the only acceptable value=
 here,
> > > +   because the chip only provide one PWM).
> > > +   The second cell encodes the PWM period in nanoseconds.
> > > +   The third cell encodes the PWM flags (the only supported flag is
> > > +   PWM_POLARITY_INVERTED)
> >=20
> > Given that this already refers to the default 3 cells binding it doesn't
> > need to repeat part of the contents of pwm.txt.
>=20
> Given that pwm.txt states:
>=20
> pwm-specifier : array of #pwm-cells specifying the given PWM=20
>                 (controller specific)

It also goes on to say that:

"
pwm-specifier typically encodes the chip-relative PWM number and the PWM
period in nanoseconds.

Optionally, the pwm-specifier can encode a number of flags (defined in
<dt-bindings/pwm/pwm.h>) in a third cell:
- PWM_POLARITY_INVERTED: invert the PWM signal polarity
"

> I'd leave it here. Just because pwm.txt gives an example of a controller
> specific meaning for the pwm cells, I don't think we should rely on it
> everywhere.

If we do have a default meaning for a specifier and the majority (in
case of PWM every single one) of the device-specific bindings use it,
then I don't think it makes sense to duplicate information everywhere
else. We've been doing the same thing across the kernel for a long
time now, why should PWM be special?

Thierry

--huq684BweRXVnRxX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUMom6AAoJEN0jrNd/PrOh8FIQAIEVLFN32GN4Icf9hhoLRttx
2wqD4fsUCQcgzdwBFsFnOu4sYXvVHrLISEiew/F7loerSOhtme6AH6Qi8BnVkLnv
oEEwQ2fby9vlMD+z8eKjiy4T4VHJj5i3dmwpjwMq3Cvt4kBtkJ7hihphGb+ueW1B
SG17Ne3y+R/ONeIkcL++0Kkd3f9a4nChWUjG47RViTWHxR8hRX6VS2vOtT7aTD19
WCcdwHQt5jzp9gmQqoPqhYKkWNV8XNX2vLTnL5diZJRsZQjrGKVB4jclXWqK9sqb
gl5xSMLWJYO8mO3wruDSktWeA3JT/+sNiWh6eFcZSrCMmtsC48VrYS+p1g9RtQFO
hA8CPwxOK1YW36JqFfig2pmGV/ubFox0knKewACYRQleg3jwRr+z/Cuo4nzmR0am
pI+H31lk0geIQ5v57DQSe0MmGkaB8zElCO5xXFxUNBHV/gYS7TSVpK2UoYPO6ZoB
crM8clf/YMwwNe8RTEJx2OrsYFtbuBocz41wvF5vfiiVMTVZ8wTWcyJqosNsDDb2
yKMrP3fsH1iuDwZFKMa6VvzpgqClaT9r4dRk4gQottmYFsTU9+p8QccrpJv7git2
WWn3nWtnZfoWe7NwtCnzuTAbLLYW/8Y5K63wFFjkp1NUoDeWxA0sY1qNU8nP1VeT
uH//Nr4gW1NCnAbnpbSI
=mZO3
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
