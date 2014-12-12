Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750915AbaLLFBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 00:01:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbaLLFBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 00:01:19 -0500
Date: Fri, 12 Dec 2014 16:01:05 +1100
From: NeilBrown <neilb@suse.de>
To: Sebastian Reichel <sre@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] TTY: add slave driver to power-on device via a
 regulator.
Message-ID: <20141212160105.75ea107d@notabene.brown>
In-Reply-To: <20141211225847.GB11666@earth.universe>
References: <20141211214801.4127.93914.stgit@notabene.brown>
	<20141211215944.4127.4186.stgit@notabene.brown>
	<20141211225847.GB11666@earth.universe>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/0iNRx5DX90u.CxMOCd1La4e"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0iNRx5DX90u.CxMOCd1La4e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Dec 2014 23:58:48 +0100 Sebastian Reichel <sre@kernel.org> wrote:

> Hi,
>=20
> On Fri, Dec 12, 2014 at 08:59:44AM +1100, NeilBrown wrote:
> > The regulator is identified in devicetree as 'vdd-supply'
>=20
> long description is kind of useless...
>=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >  .../devicetree/bindings/serial/slave-reg.txt       |   18 ++++
> >  drivers/tty/Kconfig                                |    2=20
> >  drivers/tty/Makefile                               |    1=20
> >  drivers/tty/slaves/Kconfig                         |   12 ++
> >  drivers/tty/slaves/Makefile                        |    2=20
> >  drivers/tty/slaves/tty-reg.c                       |  102 ++++++++++++=
++++++++
> >  6 files changed, 137 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/serial/slave-reg.=
txt
> >  create mode 100644 drivers/tty/slaves/Kconfig
> >  create mode 100644 drivers/tty/slaves/Makefile
> >  create mode 100644 drivers/tty/slaves/tty-reg.c
> >=20
> > diff --git a/Documentation/devicetree/bindings/serial/slave-reg.txt b/D=
ocumentation/devicetree/bindings/serial/slave-reg.txt
> > new file mode 100644
> > index 000000000000..7896bce8dfe4
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/serial/slave-reg.txt
> > @@ -0,0 +1,18 @@
> > +Regulator powered UART-attached device
> > +
> > +Required properties:
> > +- compatible: "tty,regulator"
> > +- vdd-supply: regulator to power the device
> > +
> > +
> > +This is listed as a child node of a UART.  When the
> > +UART is opened, the device is powered.
> > +
> > +Example:
> > +
> > +&uart1 {
> > +	bluetooth {
> > +		compatible =3D "tty,regulator";
> > +		vdd-supply =3D <&vaux4>;
> > +	};
> > +};
>=20
> NACK. The compatible value should describe the connected device. You
> did not connect a regulator, but a bluetooth chip! DT should look
> like this:
>=20
> &uart1 {
>     bluetooth {
>         compatible =3D "vendor,bluetooth-chip";
>         vdd-supply =3D <&vaux4>;
>     };
> };
>=20
> I think it would be ok to use your generic driver to handle the
> specific compatible value, though.
>=20
> Having the proper compatible value means, that there can be a more
> specific driver later, that other operating systems can expose the
> device as some kind of /dev/bluetooth instead of /dev/ttyXY, that
> userspace is able to know there is a bluetooth device connected to
> /dev/ttyXY by parsing the DT and results in easier-to-understand
> DTS.

So the tty_reg_dt_ids array could conceivably grow a long list of compatible
devices, starting with this one.  I guess that makes sense.

Thanks,
NeilBrown

--Sig_/0iNRx5DX90u.CxMOCd1La4e
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVIp2kTnsnt1WYoG5AQLm7A//fwFUdSFFY0FSSP7T/Z//6g41dJFLcqVU
aOqoZYeex4oTTNeEYtzBS6HjYbxeFs9KjcRf2qrkhrOqXElXquaKrZEqv/cZjfJA
N1KEhNp//i9kUSpB5FmKMYIk07Ak7NSD+SSXUIGD83O7FViC3FYlar5UDbikJojl
p0Jek13nv5WfNKFx5WcMh4B+HaqgZVShEqzugPqCHqQfhYeL9x/o5mIGVuj2fvZG
nSl2Ul7mHYf9IR6E/H6ZUzpyAvZRK4njjl1VHlmPjPXi/WKz4dZhRW6U9SweOM1N
jMQPrvMuqIOQEgPnGV0VoQO6s5dmU9co0/RbfHMRZFk42y2R4V52DXXxz6xMX92+
CYhnIKU5QZn2ou6H56pNDkcqgfaiWwAMu27quN4ez4QdvHvOR6aPtNZ/FJpvcqyt
3FG49I+1Lp25ByWloCGDcv99sMFDRfX/fu8ybMTQE8YOckRXiChdhalMaaHG2HHV
wz3j+0GsxxZOiiwvmcO6QLK8X80hJoqIB4695Mzm78d0yR0Xu+RQMEA+upbCu6tM
QRGrn3f5y5TKgxzcogwK8z4NqqsWKX/5e9fFK8Q/DBXBjUp7Pl7dmXJy835llYYX
ZajMGpN1OLhK6kdjUXF2k4s1rRCEnR7WUqqgyYPzwonw+Pdm3RVKmWFLbL+b9PgH
EDMpH+0S7x0=
=SpId
-----END PGP SIGNATURE-----

--Sig_/0iNRx5DX90u.CxMOCd1La4e--
