Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937458Ab3DIKK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:10:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39995 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935101Ab3DIKKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:10:54 -0400
Message-ID: <5163E925.4060601@ti.com>
Date: Tue, 9 Apr 2013 13:10:45 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: linux-next: manual merge of the omap_dss2 tree with Linus' tree
References: <20130408143623.bbf18647b96df42b8b8ec6a0@canb.auug.org.au>
In-Reply-To: <20130408143623.bbf18647b96df42b8b8ec6a0@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig22EA518EFF3EB7B73E810343"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig22EA518EFF3EB7B73E810343
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 2013-04-08 07:36, Stephen Rothwell wrote:
> Hi Tomi,
>=20
> Today's linux-next merge of the omap_dss2 tree got a conflict in
> drivers/video/fbmon.c between commit 477fc03f5baa ("fbmon: use
> VESA_DMT_VSYNC_HIGH to fix typo") from Linus' tree and commit
> 06a3307975aa ("videomode: combine videomode dmt_flags and data_flags")
> from the omap_dss2 tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action=

> is required).
>=20
> diff --cc drivers/video/fbmon.c
> index 7f67099,e5cc2fd..0000000
> --- a/drivers/video/fbmon.c
> +++ b/drivers/video/fbmon.c
> @@@ -1398,13 -1398,13 +1398,13 @@@ int fb_videomode_from_videomode(cons=
t s
>  =20
>   	fbmode->sync =3D 0;
>   	fbmode->vmode =3D 0;
> - 	if (vm->dmt_flags & VESA_DMT_HSYNC_HIGH)
> + 	if (vm->flags & DISPLAY_FLAGS_HSYNC_HIGH)
>   		fbmode->sync |=3D FB_SYNC_HOR_HIGH_ACT;
> - 	if (vm->dmt_flags & VESA_DMT_VSYNC_HIGH)
>  -	if (vm->flags & DISPLAY_FLAGS_HSYNC_HIGH)
> ++	if (vm->flags & DISPLAY_FLAGS_VSYNC_HIGH)
>   		fbmode->sync |=3D FB_SYNC_VERT_HIGH_ACT;
> - 	if (vm->data_flags & DISPLAY_FLAGS_INTERLACED)
> + 	if (vm->flags & DISPLAY_FLAGS_INTERLACED)
>   		fbmode->vmode |=3D FB_VMODE_INTERLACED;
> - 	if (vm->data_flags & DISPLAY_FLAGS_DOUBLESCAN)
> + 	if (vm->flags & DISPLAY_FLAGS_DOUBLESCAN)
>   		fbmode->vmode |=3D FB_VMODE_DOUBLE;
>   	fbmode->flag =3D 0;

Thanks, looks correct.

I wonder what I should do about this conflict. Both the fix in Linus'
tree and the new code come from fbdev tree (I'm currently handling fbdev
patches), and it feels a bit silly to have conflicts between the fixes
and new commits from the same subsystem tree.

I could just leave the conflict be, or I could merge the fix into the
fbdev-next branch. Do you know if there's a rule of thumb I should
follow here?

 Tomi



--------------enig22EA518EFF3EB7B73E810343
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRY+klAAoJEPo9qoy8lh71AgEQAJyQ4NBDJ6fcdGbuqilQt+Hk
fe/Bip5XKTdEAy/od5KgQe2lxt8sDgey5sfXxn/Njurnw6R+39LVMDChzvW0m2+/
lLmYh6I/rkjvzl6p9B/pz+bAExvFOo91ZbTrDkDj9pemyzHmkybqnywjLiQHWbxv
GZ6wGaSRWVYxHLIDeAUPB3TwEXsLjzlI2YN/QnyYyIs9rK4YZijJ/HlWmovJo0mT
EqgWdXBjg4IBrZzjB2WrMmMNPEfmJ2OK2HjSz/lz1vZg3GLz2IsaHdv6ZSJUv98H
pLbYX6+4b51vC+DhhNnh26xH4tCaXoa93OgMsomqCOzsxh1FNgyF4wxsYb+GIexr
qCdMlHMI8AVGgj0x51RPwBg2XwM8u0bZ6ZgaunLlu/3N+sb/al566eFD0EAM+ZrS
IEpF8bHu5LDnyN8EfS2ME48nqrjIkZt6aWfXLOlkY6fKr9fNM7kqf5HfgMgriMSQ
7ecTCvdL2ZHZgG5ReakRbW8r7ZYgjJQovBkHV/AH3AaGuZ4/RAxqPlYvYvXt8kZ+
wKm5PAKrJ5vltHN1c/4jzh01hyVRo4G0bg4HoIFNkZiaTxo5dEqjQ+5RP+aFM6HU
OJ3mUDw+mTWm8FdmU5rqD2gTw3eecIVIEc2YAASE3PvG2wxvxq/XXPBTAMNXDRwR
gb2YgTYiO64Q57atjwQk
=5t5+
-----END PGP SIGNATURE-----

--------------enig22EA518EFF3EB7B73E810343--
