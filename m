Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377Ab3EAD2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 23:28:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46434 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758801Ab3EAD17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 23:27:59 -0400
Date: Wed, 1 May 2013 13:27:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Frank Schaefer <fschaefer.oss@googlemail.com>
Subject: Re: linux-next: manual merge of the v4l-dvb tree with the i2c tree
Message-Id: <20130501132746.099810489c0f9384d15f13e7@canb.auug.org.au>
In-Reply-To: <20130403121257.852f64242bff004461d8b081@canb.auug.org.au>
References: <20130403121257.852f64242bff004461d8b081@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__1_May_2013_13_27_46_+1000_9F4hfP94yx/meOoq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_May_2013_13_27_46_+1000_9F4hfP94yx/meOoq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 3 Apr 2013 12:12:57 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the v4l-dvb tree got a conflict in
> drivers/media/pci/bt8xx/bttv-input.c between commit bf51a8c5e0b6 ("i2c:
> Ignore return value of i2c_del_adapter()") from the i2c tree and commit
> 457ba4ce4f43 ("[media] bttv: move fini_bttv_i2c() from bttv-input.c to
> bttv-i2c.c") from the v4l-dvb tree.
>=20
> The latter moved the code that the former modified, so I added the
> following fix patch and can carry the fix as necessary (no action is
> required).
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 3 Apr 2013 12:10:05 +1100
> Subject: [PATCH] i2c: fixup for code movement from bttv_input.c
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/media/pci/bt8xx/bttv-i2c.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/media/pci/bt8xx/bttv-i2c.c b/drivers/media/pci/bt8xx=
/bttv-i2c.c
> index b7c52dc..d43911d 100644
> --- a/drivers/media/pci/bt8xx/bttv-i2c.c
> +++ b/drivers/media/pci/bt8xx/bttv-i2c.c
> @@ -397,8 +397,8 @@ int init_bttv_i2c(struct bttv *btv)
> =20
>  int fini_bttv_i2c(struct bttv *btv)
>  {
> -	if (0 !=3D btv->i2c_rc)
> -		return 0;
> +	if (btv->i2c_rc =3D=3D 0)
> +		i2c_del_adapter(&btv->c.i2c_adap);
> =20
> -	return i2c_del_adapter(&btv->c.i2c_adap);
> +	return 0;
>  }
> --=20
> 1.8.1

This fix up patch is now required when I merge the i2c tree (as Linus'
has merged the v4l-dvb stuff).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__1_May_2013_13_27_46_+1000_9F4hfP94yx/meOoq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRgIuyAAoJEECxmPOUX5FECUgP/2CsRUFJ2xjrRp0TLxvzS4sp
97q55ORMAVOsFXPnWIiKvKzytKT6WnpkBgKel7HmCtjXHmGlm1KyLwK0OXWEo4o3
z4QXs1+nXxgUX/WeP2OsWuTVL1eyxKfmDwhKXTq+nTQXsxr+QgyiLA7KOYtTYp6T
qr2hGg1yJqig00MWYEGeOSBEmN8h2JnLGodzjrbcaE0JAuTzwkiwe0Ryp6m1ooWE
XTkG2OVGRWORvpcf5ylypnrcVoOxyheerlq/JYR+B76xHxxo2oaKt9/QGhXIBq1r
odkRFd3ViEVDlTBHhAuSIqJ6Z24IKYeoD4zOfDxkGwFWbKDLJEIBePdXAYGsLpvb
ZFu8LHfQk40X7suGOWwuZiBVr91Z79qni33ZvKfvYSqBCnOezPP+/C/y3wLafMAa
87P1Z9rR64nOGcVM1GKRCUiWTsRT7d9AEkt/O5VIDTsMh3Do/9nnIsNsJ+UxXJnZ
gOFPdVBNoMyFInZRFmt0fjK3ocpm8+JMTbtgNPm+kg1NaxdGRSC4UQCz7wWEny4E
W8IZ5zqq1/F+GrToMZov8wjyNyVbnJkAcDWqCSEeJnh0XRX3MsloXFWXDCUZrp0Y
auf2wLENp7ZxLVOI0lMASN9xCZkSXxMouNiKIiwyXLqf1tGhtmUEx2OBsFSXevWm
2FjoLrsqphOyYkXTRxJE
=ved9
-----END PGP SIGNATURE-----

--Signature=_Wed__1_May_2013_13_27_46_+1000_9F4hfP94yx/meOoq--
