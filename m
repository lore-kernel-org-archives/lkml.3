Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463AbaLJWvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 17:51:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:45513 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758209AbaLJWvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 17:51:02 -0500
Date: Wed, 10 Dec 2014 23:50:37 +0100
From: "sre@debian.org" <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "pali.rohar@gmail.com" <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "khilman@kernel.org" <khilman@kernel.org>,
        "aaro.koskinen@iki.fi" <aaro.koskinen@iki.fi>,
        "ivo.g.dimitrov.75@gmail.com" <ivo.g.dimitrov.75@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>
Subject: Re: BCM2048 bluetooth connected over OMAP serial
Message-ID: <20141210225036.GA5585@earth.universe>
References: <20141210164333.GA3154@amd>
 <11367725.nphhSzdtpK@wuerfel>
 <20141210184203.GA28150@leverpostej>
 <20141210205622.GA25286@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <20141210205622.GA25286@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Dec 10, 2014 at 09:56:22PM +0100, Pavel Machek wrote:
> On Wed 2014-12-10 18:42:03, Mark Rutland wrote:
> > On Wed, Dec 10, 2014 at 05:02:42PM +0000, Arnd Bergmann wrote:
> > > On Wednesday 10 December 2014 17:43:33 Pavel Machek wrote:
> > > >=20
> > > > So, there's bluetooth chip that's connected to the SoC by UART and =
some
> > > > GPIOs. What would be right representation in the device tree?
> > > > Something like this?
> > > >=20
> > > >         bluetooth {
> > > >                   compatible =3D "broadcom,bcm2048";
> > > >                   uart =3D <&uart2>;
> > > >                   reset-gpios =3D <&gpio3 27 GPIO_ACTIVE_HIGH>; /* =
want 91 */
> > > >                   host-wakeup-gpios =3D <&gpio4 5 GPIO_ACTIVE_HIGH>=
; /* want 101 */
> > > >                   bluetooth-wakeup-gpios =3D <&gpio2 5 GPIO_ACTIVE_=
HIGH>; /* want 37 */
> > > >                   chip-type =3D >;
> > > >                   bt-sysclk =3D <2>;
> > > >                   reset-gpio-shared =3D <0>;
> > > >         };
> > > >=20
> > > > Is there some way to prevent OMAP tty driver from binding to the
> > > > device and exporting the device to userspace?
> > >=20
> > > I think from the driver perspective, you want this to be a tty line
> > > discipline rather than a driver that attaches to the physical
> > > uart.
> > >=20
> > > For the DT representation, I fear we haven't got a precedent. A uart
> > > phandle sounds reasonable, but there might be other ways to do it
> > > and we should consider if there are better alternatives. It could
> > > possibly be a child node of the uart, but that would require other
> > > infrastructure in the kernel because we don't currently create
> > > devices for those.
> >=20
> > I think the child node is the way to go; that would match what we do for
> > I2C and SPI. We might need new infrastructure, but I don't think we
> > should treat this differently simlpy because we don't have that yet.
>=20
> Well, uart in this case looks more like a GPIO than an I2C (no
> addressing, just few wires). And we do phandle for GPIOs.

Right and the devices use I2C for full communication and GPIOs as
helpers. I guess UART counts as full communication and not as helper.

phandle vs child node is not a matter of adressing and btw where is
the difference between "5th gpio on 1st gpio controller" and "5th
address on 1st i2c controller"?

> Actually, the chip also has PCM, analog audio, and "pc compatible?"
> connections, plus some connection to WIFI. So we may need more
> phandles there....

This is much harder to solve. I think we don't have a DT binding for
a device, which uses two communication interfaces as the bcm2048
(uart & i2c). OTOH we may just add a slave device for the fm-radio
part like this:

uart {
    bcm2048 {
        stuff;
    };
};

i2c {
    bcm2048-radio {
        master =3D <&bcm2048>;
    };
};

-- Sebastian

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUiM45AAoJENju1/PIO/qaV3YQAKMMjP8Dw83+z+KNaKLZiMCU
hpX4RNXDYXh4MHqNKWG/TnKU1ROZuKDwRSrcnv5U0VuI4VviOstnAiSCJgwYygQL
rUW/zVr0NdqF7rTIxt/3ylm0WHOT+4pQhwYxs19YMTMExabiCIQZzjFk+YRkskxG
9wDcs0V8X4LnVrZjAZ0dwmkaGJBiDxY069GPtGB5SCWPmYtSegsMNGaG9ijse+Is
kyY8wufsQ7KlR+QOZ0TxepDDya/rSZ4u05TL9a8hSTHkdPT799alXtvZDgcZrg2Q
unHD1F1yKnUYUZPwIQNBg6BMyVb1y0g0LZz15EerzQpYEbNBPRjGTJyR15Eq4Imk
PBH9Q8ehqE7wHRGUu5hXwgCPXwQLZTuhb0iwjcMVPqnb3XInDp85yocC+7lnjh+A
gps6gI1Eg5daR54Nas1rVtrykYDiKsh+cP6uzwd6ResLzFYkziOnxI4XW+7oxxME
Ua0YXDKJrwDmv63tzKdBFXIAFShNd3mBvn/yU3cVPOEmSUiAxjLYJA3EtgIr/F9b
IpUdelis9vGqO9vB6bk0Gzi8mk+DnlztFQjd9ZKqgbjv5hlQVMSweTLWLV2iExmz
m2TB7eryydUxolDceGBosCXBmn1l73IzyhydE5L4nEEAyBaxk6CN84yZTFYD5+ZM
ncPeC12B+/U7rPb1qZbe
=Mhsd
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
