Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965280Ab3FTLAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:00:21 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:55886 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964966Ab3FTLAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:00:15 -0400
Message-ID: <51C2E0AF.7040702@monstr.eu>
Date: Thu, 20 Jun 2013 12:59:59 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 1/2] GPIO: Add support for dual channel in gpio-xilinx.c
References: <4b90b06fce0475b579cfba4d968b4778359154f6.1369826814.git.michal.simek@xilinx.com> <CACRpkdY4xaCOe28nu-NrYQ7pafjhj8-xqFcJRF9iJUy3SrCVrA@mail.gmail.com> <51A8387C.4030704@monstr.eu> <CACRpkdbHiaK6YPgXyxNgEeZxAsddK4x0vS-q3YfyXnj_BgHvuw@mail.gmail.com> <51A852A1.7020505@monstr.eu> <CACRpkdbL4pqiF8zxMi28SRTJ9AESiFt0wJMhK1oBio_cfFhpsQ@mail.gmail.com> <51C2B47A.6010906@monstr.eu> <CACRpkdbWXFLgcUJ-gcUArRotJMoX4JBU9mmheooJBWsLR=QHOA@mail.gmail.com>
In-Reply-To: <CACRpkdbWXFLgcUJ-gcUArRotJMoX4JBU9mmheooJBWsLR=QHOA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2HPSMLBMTGVVEBVKMEWOO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2HPSMLBMTGVVEBVKMEWOO
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/20/2013 11:23 AM, Linus Walleij wrote:
> On Thu, Jun 20, 2013 at 9:51 AM, Michal Simek <monstr@monstr.eu> wrote:=

>> On 06/17/2013 07:29 AM, Linus Walleij wrote:
>=20
>>> I think of_property_read_bool() will accept
>>> xlnx,is-dual =3D <1>; to mean the same as xlnx,is-dual;
>>> try it.
>>
>> First of all sorry for delay.
>> You are right that of_property_read_bool()
>> also accept xlnx,is-dual =3D <1>;
>> but also accept and return 1 when xlnx,is-dual =3D <0>;
>> which is incorrect behaviour.
>=20
> OK but that is a coding issue, not a DT bindings design issue.
> Can't we think a bit outside the box?

Before that fyi: I am working on supporing irq in this driver too.
Sure.

> What about something like this:
>=20
> static bool is_dual (struct device_node *np)
> {
>     struct property *prop =3D of_find_property(np, "xlnx,is-dual", NULL=
);
>     int ret;
>     u32 val;
>=20
>     if (!prop)
>         return false;
>=20
>     ret =3D of_property_read_u32(np, "xlnx,is-dual", &val);
>     if (ret < 0)
>         return true; /* node exists but has no cells */
>=20
>     return !!val;
> }

we can do it in this way but what I don't like on this is that IP
is design to support 2 channels right now.
It can happen that Xilinx decides to extend this for new channels.
Register map is prepared for it and there is enough space to do it.

And when this is done then is-dual (which is current name which
is used in hardware configuration from design tools) will contain
larger value >1.
I agree that is-dual is not the best name.

What about to do it differently?
Generate number of channel in the description.
And also do for() loop in the probe function to read values based
on this channel number.

Thanks,
Michal




--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2HPSMLBMTGVVEBVKMEWOO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHC4LEACgkQykllyylKDCFZjACfU8XBcP4LjjjRlf9q1B6ahskU
ZJ8An25m30BfZbMwQ+Hb3R5X7P7ZrwNY
=2nKg
-----END PGP SIGNATURE-----

------enig2HPSMLBMTGVVEBVKMEWOO--
