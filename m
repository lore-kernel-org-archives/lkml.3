Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbaDGHFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 03:05:00 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:43691 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaDGHE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 03:04:57 -0400
Message-ID: <53424E14.9080100@monstr.eu>
Date: Mon, 07 Apr 2014 09:04:52 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 09/20] of/fdt: create common debugfs
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com> <1396563423-30893-10-git-send-email-robherring2@gmail.com> <533EA2B0.7080703@monstr.eu> <CAL_JsqKFK8YDoODYKg5b8SmDzqdNSS6UvYr3_atzhcL2uR-=rA@mail.gmail.com> <533EB207.1020203@monstr.eu> <CAL_Jsq+tf4wgjB7uTNipWEj5d6tPkd6QwO_xiW87P51Y_y48vw@mail.gmail.com> <533EBD7D.6090403@monstr.eu> <CAL_JsqJ28ajOD7UNG6nH07ACjOji_=WrL-K8rAqsRpYL-X1K6Q@mail.gmail.com>
In-Reply-To: <CAL_JsqJ28ajOD7UNG6nH07ACjOji_=WrL-K8rAqsRpYL-X1K6Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="vRumugr6CW3eJWLUvk80gIGwsOUbLtQPp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vRumugr6CW3eJWLUvk80gIGwsOUbLtQPp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/07/2014 02:42 AM, Rob Herring wrote:
> On Fri, Apr 4, 2014 at 9:11 AM, Michal Simek <monstr@monstr.eu> wrote:
>> On 04/04/2014 03:32 PM, Rob Herring wrote:
>>> On Fri, Apr 4, 2014 at 8:22 AM, Michal Simek <monstr@monstr.eu> wrote=
:
>>>> On 04/04/2014 03:00 PM, Rob Herring wrote:
>>>>> On Fri, Apr 4, 2014 at 7:16 AM, Michal Simek <monstr@monstr.eu> wro=
te:
>>>>>> On 04/04/2014 12:16 AM, Rob Herring wrote:
>>>>>>> From: Rob Herring <robh@kernel.org>
>>>>>>>
>>>>>>> Both powerpc and microblaze have the same FDT blob in debugfs fea=
ture.
>>>>>>> Move this to common location and remove the powerpc and microblaz=
e
>>>>>>> implementations. This feature could become more useful when FDT
>>>>>>> overlay support is added.
>>>>>
>>>>> [snip]
>>>
>>>> Anyway I am testing it for microblaze and getting problem
>>>> caused by this patch:
>>>> commit 3d2ee8571ac0580d49c3f41fa28336289934900a
>>>> Author: Rob Herring <robh@kernel.org>
>>>> Date:   Wed Apr 2 15:10:14 2014 -0500
>>>>
>>>>     of/fdt: Convert FDT functions to use libfdt
>>>>
>>>> And reason is that in unflatten_dt_node()
>>>>
>>>> pathp =3D fdt_get_name(blob, *poffset, &l);
>>>>
>>>> is returning NULL
>>>> and here
>>>>         /* version 0x10 has a more compact unit name here instead of=
 the full
>>>>          * path. we accumulate the full path size using "fpsize", we=
'll rebuild
>>>>          * it later. We detect this because the first character of t=
he name is
>>>>          * not '/'.
>>>>          */
>>>>         if ((*pathp) !=3D '/') {
>>>>
>>>> code is trying to read it which is causing this kernel bug:
>>>> Oops: kernel access of bad area, sig: 11
>>>>
>>>> It means fdt_next_node(is doing something wrong)
>>>>
>>>> Any easy way how to debug it?
>>>
>>> I didn't think fdt_get_path should fail. Can you add a print of
>>> *poffset and pathp values.
>=20
> I think I've fixed this now and updated the branch. Please test again
> when you have a chance.

yep. The updated branch works for Microblaze.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--vRumugr6CW3eJWLUvk80gIGwsOUbLtQPp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNCThQACgkQykllyylKDCEJiwCfdEGS8yOP0utR8Zx76qHYzVtj
hLkAn0AKSJ03/lx6Tm2Jbt5iHg952CMF
=iGUs
-----END PGP SIGNATURE-----

--vRumugr6CW3eJWLUvk80gIGwsOUbLtQPp--
