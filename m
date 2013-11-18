Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab3KRW4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 17:56:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab3KRW4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 17:56:38 -0500
Date: Tue, 19 Nov 2013 09:56:25 +1100
From: NeilBrown <neilb@suse.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH] itg3200: add dt support.
Message-ID: <20131119095625.1fc4f66f@notabene.brown>
In-Reply-To: <20131118115742.GG30853@e106331-lin.cambridge.arm.com>
References: <20131101154854.2d7d1432@notabene.brown>
	<20131118115742.GG30853@e106331-lin.cambridge.arm.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2Sjbqu0a89jxgN+JCgh_INP"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2Sjbqu0a89jxgN+JCgh_INP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Nov 2013 11:57:42 +0000 Mark Rutland <mark.rutland@arm.com> wrot=
e:

> On Fri, Nov 01, 2013 at 04:48:54AM +0000, NeilBrown wrote:
> >=20
> >=20
> > No new configuration, just a 'compatible' string and documentation.
> >=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
> >=20
> > diff --git a/Documentation/devicetree/bindings/iio/gyro/itg3200.txt b/D=
ocumentation/devicetree/bindings/iio/gyro/itg3200.txt
> > new file mode 100644
> > index 000000000000..4581620632df
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/iio/gyro/itg3200.txt
> > @@ -0,0 +1,20 @@
> > +* InvenSense ITG3200 3-axis gyroscope
> > +
> > +Required properties:
> > +
> > +  - compatible : "invensense,itg3200"
> > +  - reg : I2C address, typically 0x68
> > +
> > +Optional properties:
> > +
> > +  - interrupt-parent : should be the phandle for the interrupt control=
ler
> > +  - interrupts : interrupt mapping for GPIO IRQ
>=20
> Why is this a "GPIO IRQ"? This device das no GPIO. The fact that it
> might be wired to a GPIO controller has nothing to do with the ITG3200,
> and shouldn't be a concern of its binding.
>=20

You are of course correct.  I'll resubmit with that word removed.

I probably copied it from bma180.txt without thinking.

/home/git/linux$ git grep 'GPIO IRQ' Documentation/devicetree/bindings/
Documentation/devicetree/bindings/gpio/8xxx_gpio.txt: - interrupts : Interr=
upt mapping for GPIO IRQ.
Documentation/devicetree/bindings/gpio/gpio-xilinx.txt:- interrupts : Inter=
rupt mapping for GPIO IRQ.
Documentation/devicetree/bindings/gpio/pl061-gpio.txt:- interrupts : Interr=
upt mapping for GPIO IRQ.
Documentation/devicetree/bindings/iio/accel/bma180.txt:  - interrupts : int=
errupt mapping for GPIO IRQ, it should by configured wi
Documentation/devicetree/bindings/iio/light/apds9300.txt:  - interrupts : i=
nterrupt mapping for GPIO IRQ

Both bma180.txt and apds9300.txt seem to use the phrase "GPIO IRQ"
inappropriately.

Thanks,
NeilBrown

> Thanks,
> Mark.
>=20
> > +
> > +Example:
> > +
> > +itg3200@68 {
> > +	compatible =3D "invensense,itg3200";
> > +	reg =3D <0x68>;
> > +	interrupt-parent =3D <&gpio2>;
> > +	interrupts =3D <24 IRQ_TYPE_EDGE_RISING>;
> > +};
> > diff --git a/drivers/iio/gyro/itg3200_core.c b/drivers/iio/gyro/itg3200=
_core.c
> > index 4d3f3b92b361..1ed3003ef41a 100644
> > --- a/drivers/iio/gyro/itg3200_core.c
> > +++ b/drivers/iio/gyro/itg3200_core.c
> > @@ -374,10 +374,17 @@ static const struct i2c_device_id itg3200_id[] =
=3D {
> >  };
> >  MODULE_DEVICE_TABLE(i2c, itg3200_id);
> > =20
> > +static const struct of_device_id itg3200_of_match[] =3D {
> > +	{ .compatible =3D "invensense,itg3200", },
> > +	{}
> > +};
> > +MODULE_DEVICE_TABLE(of, itg3200_of_match);
> > +
> >  static struct i2c_driver itg3200_driver =3D {
> >  	.driver =3D {
> >  		.owner  =3D THIS_MODULE,
> >  		.name	=3D "itg3200",
> > +		.of_match_table =3D of_match_ptr(itg3200_of_match),
> >  	},
> >  	.id_table	=3D itg3200_id,
> >  	.probe		=3D itg3200_probe,
>=20


--Sig_/2Sjbqu0a89jxgN+JCgh_INP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoqbGTnsnt1WYoG5AQLImw//YENjBlmsOuSTQjxBRsw0GQj3d6L8qkz2
+Kj6I+BzukQKwIoREiJNnQN4qaxnTcCE+oHxGp8fydMn+baEt4NaZn9f302UpAID
YXRnJMr98g2CxkHhqcXvk6LqwKtGfcEe/UmhbsRckDtoOdaj0LcnhFWtrcV32RTw
15hWRaoBQAdoP16KGi4DujVReznmcUuNbi5XpbsCGw+UMhKJZRzfxyrGCgx3Mtzm
QTggen2APv4a66EyDiCQgOJT/Az9BhtGHULSoE6Q8OEvba4c+8GuCHNBO6Fmoc1f
k7eYnBLbEasSvtL561P4FDCXyaf7TSfseNK8GTB63yhp7TA5Gw5yasOqYc0muQAN
cFZmOY2uDS2maot07YDBe7WMYauRNNwxDfpXrT9fbwulEKtBjE+rgMMWacC4FFSi
FyvrD3rS01ETuJzS/PonQHVJlJhCzUVIiNzRSK5yW45hyv/cGSNF6oY/F9uCKRLG
6W6ii2AnX4NHfA4esLuYa6hZuZWRW4OT1SaV7jYy04JhcYPDf6O95GTFCA8bdN+J
x1jhCBb/PwjQVLA5AGagfmv+ugnnLgDjzNfLtjeOzHVe6OXQgXllDgzDSaLMNzdW
b0irWbXCKgQqHAwlKpKgHSfuJ+uXi3cXkY2RgNT0iKco51Gc8DuzfBm+NVWEb18C
NWkO0RKACnY=
=oVOV
-----END PGP SIGNATURE-----

--Sig_/2Sjbqu0a89jxgN+JCgh_INP--
