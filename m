Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab3FTHvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:51:35 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:32872 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab3FTHvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:51:33 -0400
Message-ID: <51C2B47A.6010906@monstr.eu>
Date: Thu, 20 Jun 2013 09:51:22 +0200
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
References: <4b90b06fce0475b579cfba4d968b4778359154f6.1369826814.git.michal.simek@xilinx.com> <CACRpkdY4xaCOe28nu-NrYQ7pafjhj8-xqFcJRF9iJUy3SrCVrA@mail.gmail.com> <51A8387C.4030704@monstr.eu> <CACRpkdbHiaK6YPgXyxNgEeZxAsddK4x0vS-q3YfyXnj_BgHvuw@mail.gmail.com> <51A852A1.7020505@monstr.eu> <CACRpkdbL4pqiF8zxMi28SRTJ9AESiFt0wJMhK1oBio_cfFhpsQ@mail.gmail.com>
In-Reply-To: <CACRpkdbL4pqiF8zxMi28SRTJ9AESiFt0wJMhK1oBio_cfFhpsQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2ONHUSDNFEOVSEJBAVAPB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2ONHUSDNFEOVSEJBAVAPB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/17/2013 07:29 AM, Linus Walleij wrote:
> On Fri, May 31, 2013 at 9:34 AM, Michal Simek <monstr@monstr.eu> wrote:=

>> On 05/31/2013 09:14 AM, Linus Walleij wrote:
>=20
>>> It's OK, but fix the boolean member so as to just needing to
>>> be present:
>>>
>>> xlnx,is-dual;
>>>
>>> Rather than
>>>
>>> xlnx,is-dual =3D <1>;
>>
>> Surely I can do it but it means to change our BSP and because
>> this IP is used on Microblaze from beginning this change
>> breaks all DTSes from past.
>=20
> I think of_property_read_bool() will accept
> xlnx,is-dual =3D <1>; to mean the same as xlnx,is-dual;
> try it.

First of all sorry for delay.
You are right that of_property_read_bool()
also accept xlnx,is-dual =3D <1>;
but also accept and return 1 when xlnx,is-dual =3D <0>;
which is incorrect behaviour.

If of_prorety_read_bool return 0 for case when xlnx,is-dual =3D <0>
we can use it.
Maybe this will be good change for this function behaviour.
If there is also value then use it. 0 -> false, 1 -> true

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2ONHUSDNFEOVSEJBAVAPB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHCtHoACgkQykllyylKDCEfBACeN6A57Yl5emIAA9DlnPyqbaQc
iyQAnRc5yYXko/KJsYUIS3CNYl90YSlp
=W2YQ
-----END PGP SIGNATURE-----

------enig2ONHUSDNFEOVSEJBAVAPB--
