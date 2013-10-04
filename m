Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab3JDJQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 05:16:32 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:52002 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab3JDJQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 05:16:30 -0400
Message-ID: <524E8764.4030704@monstr.eu>
Date: Fri, 04 Oct 2013 11:16:20 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Kedareswara rao Appana <appanad@xilinx.com>,
        Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2 3/3] i2c: xilinx: Use devm_* functions
References: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1380550490.git.michal.simek@xilinx.com> <83ec9558211389896f21d9682e9824cd7979466c.1380550490.git.michal.simek@xilinx.com> <20131004053323.GB3194@katana>
In-Reply-To: <20131004053323.GB3194@katana>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="CQ23bgmCkLFHrUg7R8N1uus0QFjqeSUE3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CQ23bgmCkLFHrUg7R8N1uus0QFjqeSUE3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/04/2013 07:33 AM, Wolfram Sang wrote:
>=20
>> +	i2c->base =3D devm_ioremap_resource(&pdev->dev, res);
>> +	if (IS_ERR(i2c->base)) {
>> +		dev_err(&pdev->dev, "Could not allocate iomem\n");
>=20
> devm_ioremap_resource already prints error messages.

you are right.

>=20
>> +	ret =3D devm_request_irq(&pdev->dev, irq, xiic_isr, 0, pdev->name, i=
2c);
>=20
> This is too early. Can you find out why?

Why do you think that it is too early?
I am looking at origin code again and I think that the code
is also problematic because in xiic_reinit() interrupts are enabled
but they are requested later.
Shouldn't be there a logic that interrupts should be enabled when
interrupts are registered by the kernel?

>> +	pdata =3D (struct xiic_i2c_platform_data *)dev_get_platdata(&pdev->d=
ev);
>=20
> Casting a void pointer?

No problem with that.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--CQ23bgmCkLFHrUg7R8N1uus0QFjqeSUE3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJOh2QACgkQykllyylKDCHAngCeLEt9snMTW3A7VzADLxMZqjj5
Rd8Anivajqrb9B49vFxMHQoHMNyWnlZk
=RFUE
-----END PGP SIGNATURE-----

--CQ23bgmCkLFHrUg7R8N1uus0QFjqeSUE3--
