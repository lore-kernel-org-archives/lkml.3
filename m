Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab3JGISe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 04:18:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49717 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3JGISd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 04:18:33 -0400
Message-ID: <52526E46.4030205@pengutronix.de>
Date: Mon, 07 Oct 2013 10:18:14 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130929 Icedove/17.0.9
MIME-Version: 1.0
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: Fabio Estevam <festevam@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH|RFC] of: let of_match_device() always return best match
References: <1380826284-18381-1-git-send-email-mkl@pengutronix.de> <CAOMZO5BekS_BvJzrt8vM1=7LjsiO=3hKL=mMfTjxkO3aZ4qwRQ@mail.gmail.com> <525052F5.5080204@pengutronix.de> <21074.28159.130293.169699@ipc1.ka-ro>
In-Reply-To: <21074.28159.130293.169699@ipc1.ka-ro>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="83qUWm3LdAPdbjWAWSF6XaON4rd1tjJBB"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--83qUWm3LdAPdbjWAWSF6XaON4rd1tjJBB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/07/2013 10:17 AM, Lothar Wa=C3=9Fmann wrote:
> Hi,
>=20
> Marc Kleine-Budde writes:
>> On 10/05/2013 07:46 PM, Fabio Estevam wrote:
>>> Hi Marc,
>>>
>>> On Thu, Oct 3, 2013 at 3:51 PM, Marc Kleine-Budde <mkl@pengutronix.de=
> wrote:
>>>
>>>> For example:
>>>>
>>>> The imx28.dtsi gives this compatible string for its CAN core:
>>>>
>>>>>       compatible =3D "fsl,imx28-flexcan", "fsl,p1010-flexcan";
>>>>
>>>> The flexcan driver defines:
>>>>
>>>>> static const struct of_device_id flexcan_of_match[] =3D {
>>>>>       { .compatible =3D "fsl,p1010-flexcan", .data =3D &fsl_p1010_d=
evtype_data, },
>>>>>       { .compatible =3D "fsl,imx28-flexcan", .data =3D &fsl_imx28_d=
evtype_data, },
>>>>>       { .compatible =3D "fsl,imx6q-flexcan", .data =3D &fsl_imx6q_d=
evtype_data, },
>>>>>       { /* sentinel */ },
>>>>> };
>>>>
>>>> The "p1010" was the first Freescale SoC with the flexcan core. But t=
his SoC has
>>>> a bug, so a workaround has to be enabled in the driver. The mx28 has=
 this bug
>>>> fixed, so we don't need this quite costly workaround.
>>>
>>> What about defining in imx28.dtsi:
>>> compatible =3D "fsl,imx28-flexcan".
>>
>> It already works with changing only the driver.
>>
> IMO the change proposed by Fabio is much more sensible. If the imx28
> implementation of the CAN controller is not compatible to p1010 (which
> is obviously true) there is no point in having the "fsl,p1010-flexcan"
> in the DT for imx28.

But it is compatible with the "fsl,p1010-flexcan".

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--83qUWm3LdAPdbjWAWSF6XaON4rd1tjJBB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlJSbkcACgkQjTAFq1RaXHMAgACeIxzFudwO8qCsfod6KTSzW1wG
xA4AoIyBZ++NrFrhos2/MfllWwjUQ0kI
=gHNM
-----END PGP SIGNATURE-----

--83qUWm3LdAPdbjWAWSF6XaON4rd1tjJBB--
