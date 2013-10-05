Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab3JESlP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 14:41:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60968 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3JESlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 14:41:12 -0400
Message-ID: <525052F5.5080204@pengutronix.de>
Date: Sat, 05 Oct 2013 19:57:09 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130929 Icedove/17.0.9
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH|RFC] of: let of_match_device() always return best match
References: <1380826284-18381-1-git-send-email-mkl@pengutronix.de> <CAOMZO5BekS_BvJzrt8vM1=7LjsiO=3hKL=mMfTjxkO3aZ4qwRQ@mail.gmail.com>
In-Reply-To: <CAOMZO5BekS_BvJzrt8vM1=7LjsiO=3hKL=mMfTjxkO3aZ4qwRQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="NBB3Wr9PH9B3QJ3m4PWwrcB4RbHIE9xdk"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NBB3Wr9PH9B3QJ3m4PWwrcB4RbHIE9xdk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/05/2013 07:46 PM, Fabio Estevam wrote:
> Hi Marc,
>=20
> On Thu, Oct 3, 2013 at 3:51 PM, Marc Kleine-Budde <mkl@pengutronix.de> =
wrote:
>=20
>> For example:
>>
>> The imx28.dtsi gives this compatible string for its CAN core:
>>
>>>       compatible =3D "fsl,imx28-flexcan", "fsl,p1010-flexcan";
>>
>> The flexcan driver defines:
>>
>>> static const struct of_device_id flexcan_of_match[] =3D {
>>>       { .compatible =3D "fsl,p1010-flexcan", .data =3D &fsl_p1010_dev=
type_data, },
>>>       { .compatible =3D "fsl,imx28-flexcan", .data =3D &fsl_imx28_dev=
type_data, },
>>>       { .compatible =3D "fsl,imx6q-flexcan", .data =3D &fsl_imx6q_dev=
type_data, },
>>>       { /* sentinel */ },
>>> };
>>
>> The "p1010" was the first Freescale SoC with the flexcan core. But thi=
s SoC has
>> a bug, so a workaround has to be enabled in the driver. The mx28 has t=
his bug
>> fixed, so we don't need this quite costly workaround.
>=20
> What about defining in imx28.dtsi:
> compatible =3D "fsl,imx28-flexcan".

It already works with changing only the driver.

> and the in the flexcan driver we could do the same as in the fec_main d=
river:
>=20
> static struct platform_device_id fec_devtype[] =3D {

For DT based probing I need to modify the struct of_device_id, but I got
the idea :)

>     {
>         /* keep it for coldfire */
>         .name =3D DRIVER_NAME,
>         .driver_data =3D 0,
>     }, {
>         .name =3D "imx25-fec",
>         .driver_data =3D FEC_QUIRK_USE_GASKET,
>     }, {
>         .name =3D "imx27-fec",
>         .driver_data =3D 0,
>     }, {
>         .name =3D "imx28-fec",
>         .driver_data =3D FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME,
>     }, {
>         .name =3D "imx6q-fec",
>         .driver_data =3D FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
>                 FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
>                 FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358,
>     }, {
>         .name =3D "mvf600-fec",
>         .driver_data =3D FEC_QUIRK_ENET_MAC,
>     }, {
>         /* sentinel */
>     }
> };
>=20
> So that we know which SoC needs to have the workaround applied or not.

I've already created a patch that rearranges the struct of_device_id in
the driver, works for me. I posted it (with another fix) for review on
linux-can[1].

Thanks,
Marc

[1] http://comments.gmane.org/gmane.linux.can/4050
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--NBB3Wr9PH9B3QJ3m4PWwrcB4RbHIE9xdk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlJQUvUACgkQjTAFq1RaXHOoaQCfRxK4tcOy/dIQV7FSxVAw1PnH
TuoAn3Lx8rYIXPqg27zTNytZsXnmFr7Z
=og5H
-----END PGP SIGNATURE-----

--NBB3Wr9PH9B3QJ3m4PWwrcB4RbHIE9xdk--
