Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaAEWLh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 17:11:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbaAEWLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 17:11:35 -0500
Date: Mon, 6 Jan 2014 09:11:24 +1100
From: NeilBrown <neilb@suse.de>
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mdadm raid1 regression
Message-ID: <20140106091124.32dc1057@notabene.brown>
In-Reply-To: <CACaajQtt1t-tdCrW6eCgx0_0WxTNR1buV6H2iEj_gWzrV3JZfA@mail.gmail.com>
References: <CACaajQv+HhzStC-U1RGz4ZWdn0-w4X3MyMM9GTJPOFeyrxtP3w@mail.gmail.com>
	<20130422083549.7c1cff84@notabene.brown>
	<CACaajQtt1t-tdCrW6eCgx0_0WxTNR1buV6H2iEj_gWzrV3JZfA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rv7qGMby/VgEKr688z3Fqzu"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/rv7qGMby/VgEKr688z3Fqzu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Dec 2013 10:48:03 +0400 Vasiliy Tolstov <v.tolstov@selfip.ru>
wrote:

> 2013/4/22 NeilBrown <neilb@suse.de>:
> > I'll try to make sure that works correctly for the next release.
> > Thanks for the report.
>=20
>=20
> Sorry, Neil. for bumping up old thread. I'm again have problems with
> data-offset param for mdadm.
> I'm using version from git master (guthub). If i try to create raid1 like
> /sbin/mdadm --create --data-offset=3D2048 --metadata=3D1.2 --verbose
> --force --run --bitmap=3Dinternal --assume-clean --name=3Dmd21_901
> md21_901 --level=3Draid1 --raid-devices=3D2 /dev/mapper/sas00-21_901
> /dev/mapper/sas01-21_901
> I have
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 64e0028e:301aa3ce:cdf1a54f:a9e28f27
>            Name : xen25:md21_901  (local to host xen25)
>   Creation Time : Fri Dec 27 10:43:06 2013
>      Raid Level : raid1
>    Raid Devices : 2
>=20
>  Avail Dev Size : 10489856 (5.00 GiB 5.37 GB)
>      Array Size : 5244928 (5.00 GiB 5.37 GB)
>     Data Offset : 4096 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D4008 sectors, after=3D0 sectors
>           State : clean
>     Device UUID : 38771de6:cb5f0dbc:9f32f85f:164e1e89
>=20
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Fri Dec 27 10:43:22 2013
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 7f07eb77 - correct
>          Events : 2
>=20
>=20
> But when i try to create raid1 like
> /sbin/mdadm --create --data-offset=3D1024 --metadata=3D1.2 --verbose
> --force --run --bitmap=3Dinternal --assume-clean --name=3Dmd21_901
> md21_901 --level=3Draid1 --raid-devices=3D2 /dev/mapper/sas00-21_901
> /dev/mapper/sas01-21_901
> I getting
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ef22dca1:1424ea9e:1b4dce89:27c61a91
>            Name : xen25:md21_901  (local to host xen25)
>   Creation Time : Fri Dec 27 10:44:21 2013
>      Raid Level : raid1
>    Raid Devices : 2
>=20
>  Avail Dev Size : 10491904 (5.00 GiB 5.37 GB)
>      Array Size : 5245952 (5.00 GiB 5.37 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D1960 sectors, after=3D0 sectors
>           State : clean
>     Device UUID : afae5e27:6c706246:4c3e3cb0:e5c726ac
>=20
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Fri Dec 27 10:44:26 2013
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 45be4cd1 - correct
>          Events : 2
>=20
>=20
> Why data offset specified in command line grows twice in resulting md
> array component?
>=20

The value given to --data-offset is assumed to be kilobytes unless it has a
suffix: 'M' for megabytes, 's' for sectors.

The value reported by 'mdadm -D' is (as it says) in sectors.
1024 kilobytes  is 2048 sectors.
If you want to specify sectors, add an 's' suffix.

NeilBrown

--Sig_/rv7qGMby/VgEKr688z3Fqzu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUsnYjDnsnt1WYoG5AQLdLA/+KFmodL23GIRdNzT885hjKolHCWb7wtum
KKhgHBJUWeHFF9ie55ZNYXlNq6ZIHfLiMRKSWLRd1XpcSCuuRy81frSEbQtsAwu7
ClGL7ZuIftxL2bUIi75qy6miBo7vKzGsuNDyX3B+lLi4sbng0hOsLYzMPteVe8Le
DZxy+dFiPow+7ayzh1tZ+p27nZZewF1oP0791wXSw+R0E2mFFdv4uNS12c0hUpZz
NjkVlhYKnMJSBOd0nrDdHUVga4vi2qzgo3hblWrAME8PcswQZVxyKQwKjSsCcmbl
ZlA9AbXLVyuXeNOtxI3JZRnN2NkEPJTmfoBEy4fhPIaBsN/96FOaI6RhUT3lwRMi
1j2BzRFQ9tZKG5DeW/FE+HaWkhd3TAaBBbKRNWzcTgvDLpn2tYS/I4qjX8/K5Ez0
RMLdU+MYyXdhPdkVJWZ4hhKWgkQHjj6CyuvijSgvnsmDcINHH4kD5MNuFthwwAno
ErdYVqMuyEq4na9F0h2TET7B6gkGETZRdlFobvuKuQhdSvUx3xF2f932lEN282Lm
oXHfWZTW5Teq3Tk5fw2FqnjOuP+Di0pm1iGXBcA/wz2xR6qNMd4Dw4+icCEZhyIq
U0gO0BUZnUjkkS0ScTyXc0Z8A+9+vECi5hi0DFQxefNUMjqmyfESlfDzNsyJQ2ND
RkO7ZWP6mho=
=ajyf
-----END PGP SIGNATURE-----

--Sig_/rv7qGMby/VgEKr688z3Fqzu--
