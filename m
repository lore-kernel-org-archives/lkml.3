Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077AbaJ3MAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:00:11 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:58878 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936AbaJ3MAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:00:08 -0400
Message-ID: <545227E4.5070507@vanguardiasur.com.ar>
Date: Thu, 30 Oct 2014 08:58:28 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Organization: VanguardiaSur
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org
CC: Wolfram Sang <wsa@the-dreams.de>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: I2C OF IRQ parsing issue due to probe ordering
References: <2287003.09eTeKUr1V@avalon>
In-Reply-To: <2287003.09eTeKUr1V@avalon>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="gOgA5SvUduQpahb5QIkSQIjTbDLtWOjWu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gOgA5SvUduQpahb5QIkSQIjTbDLtWOjWu
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

On 10/25/2014 07:13 PM, Laurent Pinchart wrote:
> Hello,
>=20
> I recently ran into an issue with the OF IRQ parsing code in the I2C co=
re
> (of_i2c_register_devices in drivers/i2c/i2c-core.c).
>=20
> My DT contains the following nodes.
>=20
>         gpio1: gpio@e6051000 {
>                 ...
>                 #interrupt-cells =3D <2>;
>                 interrupt-controller;
>                 clocks =3D <&mstp9_clks R8A7790_CLK_GPIO1>;
>         };
>=20
>         iic2: i2c@e6520000 {
>                 #address-cells =3D <1>;
>                 #size-cells =3D <0>;
>                 ...
>                 hdmi@39 {
>                         compatible =3D "adi,adv7511w";
>                         reg =3D <0x39>;
>                         interrupt-parent =3D <&gpio1>;
>                         interrupts =3D <15 IRQ_TYPE_EDGE_FALLING>;
>                         ...
>                 };
>         };
>=20
>         mstp9_clks: mstp9_clks@e6150994 {
>                 ...
>         };
>=20
> The i2c@e6520000 node is probed before the gpio@e6051000 node. The
> of_i2c_register_devices() function tries to register all children, incl=
uding
> hdmi@39. It tries to parse and map the I2C client IRQ by calling
> irq_of_parse_and_map(), which returns 0 as the interrupt controller isn=
't
> probed yet. The adv7511 driver later probes the hdmi@39 device and gets=

> client->irq set to 0.
>=20
> We can't control the probe order.

Maybe I'm missing something, but I think your i2c adapter is probed with
a subsys_initcall (as many other adapters). Otherwise, I can't see why
it would be probed before the the gpio controller.

I think this initcall is your problem. Have you tried just using
platform_driver's probe?

--=20
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar


--gOgA5SvUduQpahb5QIkSQIjTbDLtWOjWu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUUifpAAoJEIOKbhOEIHKiM08QAI8DAOiiz5oia4PV7XsnBUMD
gAqU5UuFn5rbGNyrZbElWBDOOIq8E2hnDeyVtgu5fQCHG0kFEUPl5d+NSoScQqBI
vrIbKZDhsJO6vRxtFxiKYbGxA//xX7jTkjZvw8eY7Sq7OE3ic0lxn7sDwBSnGR0e
9aQbeiIU/UN3XORbANVwTraz3MZrDeumelkmgsPyO+QWhsgBTB/yODmvjULM9wPa
GLfdR/83wr4RAydIPK/Lz6CySghyHmC+81sPydHsCL/buQdcAKHc/2VjfmPJ37za
navml0bNKybL56yOBInEuObGyE4SF3bvNJvFiPLa9vUpPyYoeB2s1kViey+783KQ
/DzwA3wTtfvQ+//xK0ScCyo4nVbZaQAB31zC/PN/shb1R3hdO7aYUkFgcWZdr+SQ
rPXemjTcxANLqPWtLXZcgV1smdygLIusgBbeoAoadq8m+sgo9jWJgl3EAYkWjr23
1w4eHxJAuKNUUVzorDK/jSrxzcclgc1ZRFZFumhbI3k9yj4hddDlkufrkxntllTK
jKJFyLmLTK5kG2v92esBsO3TWExWtiNsHw6ozs67xxpuim8Q+aSlUitq39Z2tlHV
wSzzqDzqxnYSbe/RUKYeZWLKiEb5UoFwOrFyX5uY9fTs8sUSE7N2qT8F49numMCl
i+bJbuSi5KNPP4h1Tzto
=LEV6
-----END PGP SIGNATURE-----

--gOgA5SvUduQpahb5QIkSQIjTbDLtWOjWu--
