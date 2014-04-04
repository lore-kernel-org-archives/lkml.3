Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaDDOLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:11:17 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34705 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaDDOLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:11:15 -0400
Message-ID: <533EBD7D.6090403@monstr.eu>
Date: Fri, 04 Apr 2014 16:11:09 +0200
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
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com> <1396563423-30893-10-git-send-email-robherring2@gmail.com> <533EA2B0.7080703@monstr.eu> <CAL_JsqKFK8YDoODYKg5b8SmDzqdNSS6UvYr3_atzhcL2uR-=rA@mail.gmail.com> <533EB207.1020203@monstr.eu> <CAL_Jsq+tf4wgjB7uTNipWEj5d6tPkd6QwO_xiW87P51Y_y48vw@mail.gmail.com>
In-Reply-To: <CAL_Jsq+tf4wgjB7uTNipWEj5d6tPkd6QwO_xiW87P51Y_y48vw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="wDs2envSkvlJFMrG8R4oH31swnTA2b3Lw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wDs2envSkvlJFMrG8R4oH31swnTA2b3Lw
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/04/2014 03:32 PM, Rob Herring wrote:
> On Fri, Apr 4, 2014 at 8:22 AM, Michal Simek <monstr@monstr.eu> wrote:
>> On 04/04/2014 03:00 PM, Rob Herring wrote:
>>> On Fri, Apr 4, 2014 at 7:16 AM, Michal Simek <monstr@monstr.eu> wrote=
:
>>>> On 04/04/2014 12:16 AM, Rob Herring wrote:
>>>>> From: Rob Herring <robh@kernel.org>
>>>>>
>>>>> Both powerpc and microblaze have the same FDT blob in debugfs featu=
re.
>>>>> Move this to common location and remove the powerpc and microblaze
>>>>> implementations. This feature could become more useful when FDT
>>>>> overlay support is added.
>>>
>>> [snip]
>=20
>> Anyway I am testing it for microblaze and getting problem
>> caused by this patch:
>> commit 3d2ee8571ac0580d49c3f41fa28336289934900a
>> Author: Rob Herring <robh@kernel.org>
>> Date:   Wed Apr 2 15:10:14 2014 -0500
>>
>>     of/fdt: Convert FDT functions to use libfdt
>>
>> And reason is that in unflatten_dt_node()
>>
>> pathp =3D fdt_get_name(blob, *poffset, &l);
>>
>> is returning NULL
>> and here
>>         /* version 0x10 has a more compact unit name here instead of t=
he full
>>          * path. we accumulate the full path size using "fpsize", we'l=
l rebuild
>>          * it later. We detect this because the first character of the=
 name is
>>          * not '/'.
>>          */
>>         if ((*pathp) !=3D '/') {
>>
>> code is trying to read it which is causing this kernel bug:
>> Oops: kernel access of bad area, sig: 11
>>
>> It means fdt_next_node(is doing something wrong)
>>
>> Any easy way how to debug it?
>=20
> I didn't think fdt_get_path should fail. Can you add a print of
> *poffset and pathp values.

Early console on uart16650 at 0x40401000
bootconsole [earlyser0] enabled
Ramdisk addr 0x00000000,
FDT at 0x806b96d4
Linux version 3.14.0-rc8-next-20140331-12541-g43b5fdb-dirty (monstr@monst=
r-desktop) (gcc version 4.6.4 20120924 (prerelease) (crosstool-NG 1.18.0)=
 ) #51 Fri Apr 4 16:09:17 CEST 2014
 -> unflatten_device_tree()
Unflattening device tree:
magic: d00dfeed
size: 00014e20
version: 00000011
unflatten_dt_node blob c0298b00, c0331f84 0
unflatten_dt_node 1a c0298b3c/ -- len 0
unflatten_dt_node 8 old offset 0
unflatten_dt_node 8 new offset 6c
unflatten_dt_node blob c0298b00, c0331f84 6c
unflatten_dt_node 1a c0298ba8/aliases -- len 7
unflatten_dt_node 8 old offset 6c
unflatten_dt_node 8 new offset cc
unflatten_dt_node blob c0298b00, c0331f84 cc
unflatten_dt_node 1a c0298c08/chosen -- len 6
unflatten_dt_node 8 old offset cc
unflatten_dt_node 8 new offset 130
unflatten_dt_node blob c0298b00, c0331f84 130
unflatten_dt_node 1a c0298c6c/cpus -- len 4
unflatten_dt_node 8 old offset 130
unflatten_dt_node 8 new offset 16c
unflatten_dt_node blob c0298b00, c0331f84 16c
unflatten_dt_node 1a c0298ca8/cpu@0 -- len 5
unflatten_dt_node 8 old offset 16c
unflatten_dt_node 8 new offset 7bc
unflatten_dt_node blob c0298b00, c0331f84 7bc
unflatten_dt_node 1a   (null)/NULL -- len fffffffc

Below is the possition of debug messages.

Thanks,
Michal

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index ee8853c..5422e4e 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -8,6 +8,7 @@
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
  */
+#define DEBUG

 #include <linux/kernel.h>
 #include <linux/initrd.h>
@@ -116,9 +117,15 @@ static void * unflatten_dt_node(struct boot_param_he=
ader *blob,
        int has_name =3D 0;
        int new_format =3D 0;

+printk("%s blob %x, %x %x\n", __func__, blob, poffset,  *poffset);
+
        pathp =3D fdt_get_name(blob, *poffset, &l);
+printk("%s 1a %p/%s -- len %x\n", __func__, pathp, pathp ? pathp : "NULL=
", l);
+
        allocl =3D l++;

+       if (!pathp)
+               while (1);
        /* version 0x10 has a more compact unit name here instead of the =
full
         * path. we accumulate the full path size using "fpsize", we'll r=
ebuild
         * it later. We detect this because the first character of the na=
me is
@@ -267,7 +274,9 @@ static void * unflatten_dt_node(struct boot_param_hea=
der *blob,
        }

        old_depth =3D depth;
+printk("%s 8 old offset %x\n", __func__, *poffset);
        *poffset =3D fdt_next_node(blob, *poffset, &depth);
+printk("%s 8 new offset %x\n", __func__, *poffset);
        while (*poffset > 0 && depth > old_depth) {
                mem =3D unflatten_dt_node(blob, mem, poffset, np, allnext=
pp,
                                                fpsize);






--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--wDs2envSkvlJFMrG8R4oH31swnTA2b3Lw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM+vX0ACgkQykllyylKDCE0CgCfUCUXCVDhoALiuxgS4OtiOlfK
TGEAnjE3dg8VvTMeeAeA70of2OKpmKg6
=chcV
-----END PGP SIGNATURE-----

--wDs2envSkvlJFMrG8R4oH31swnTA2b3Lw--
