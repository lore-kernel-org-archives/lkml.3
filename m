Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbaDWOVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:21:33 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:52314 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaDWOVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:21:30 -0400
Message-ID: <5357CC66.5080802@monstr.eu>
Date: Wed, 23 Apr 2014 16:21:26 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH v2 18/21] powerpc: use libfdt accessors for header data
References: <1398215901-25609-1-git-send-email-robherring2@gmail.com> <1398215901-25609-19-git-send-email-robherring2@gmail.com> <5357C4BE.3050606@monstr.eu> <CAL_JsqKg8oAd+JmmhERa3Xb1dD9CPz1_cVM3mb=ypWhxkZJHtQ@mail.gmail.com>
In-Reply-To: <CAL_JsqKg8oAd+JmmhERa3Xb1dD9CPz1_cVM3mb=ypWhxkZJHtQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="komXnLxXMvjrR23JtTJPhouIGKGIqmIwx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--komXnLxXMvjrR23JtTJPhouIGKGIqmIwx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 04/23/2014 04:05 PM, Rob Herring wrote:
> On Wed, Apr 23, 2014 at 8:48 AM, Michal Simek <monstr@monstr.eu> wrote:=

>> On 04/23/2014 03:18 AM, Rob Herring wrote:
>>> From: Rob Herring <robh@kernel.org>
>>>
>>> With libfdt support, we can take advantage of helper accessors in lib=
fdt
>>> for accessing the FDT header data. This makes the code more readable =
and
>>> makes the FDT blob structure more opaque to the kernel. This also
>>> prepares for removing struct boot_param_header completely.
>=20
> [...]
>=20
>>> @@ -117,14 +118,14 @@ static void __init move_device_tree(void)
>>>       DBG("-> move_device_tree\n");
>>>
>>>       start =3D __pa(initial_boot_params);
>>> -     size =3D be32_to_cpu(initial_boot_params->totalsize);
>>> +     size =3D fdt_totalsize(initial_boot_params);
>>
>> In 19/21 you use your newly introduced of_get_flat_dt_size()
>> that's why I expect you will use it here too.
>> size =3D of_get_flat_dt_size();
>>
>> The same is for 14/21 where you can use this new function too.
>> It means moving 14/21 to the end and using this new function
>> makes more sense.
>=20
> Really, I would prefer to just use libfdt accessors directly rather
> than have wrappers, but including libfdt.h is not the cleanest
> solution. Since x86 just needed this one function, I added a wrapper.
> Since PPC needs other header fields I prefer to use the libfdt
> accessors directly for all fields. The same goes for drivers/of/fdt.c.

Ok. I see your point but maybe will be good to reflect that it is
there just for x86 case and none else should use it.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--komXnLxXMvjrR23JtTJPhouIGKGIqmIwx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNXzGYACgkQykllyylKDCEu4gCfSmkWv09wbuplfKeIi4WzQG7y
cE4AmgLUtVJ2KYdPBdluuiKR3EbUS0RW
=MWm2
-----END PGP SIGNATURE-----

--komXnLxXMvjrR23JtTJPhouIGKGIqmIwx--
