Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3ITXLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 19:11:04 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:63521 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab3ITXK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 19:10:56 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH][RFC] Fix breakage in ffs_fs_mount()
In-Reply-To: <20130920161421.GR13318@ZenIV.linux.org.uk>
Organization: http://mina86.com/
References: <20130920161421.GR13318@ZenIV.linux.org.uk>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:130920:linux-usb@vger.kernel.org::XMSe46YuU6iz3Oib:0000000000000000000000000000000000000zqu
X-Hashcash: 1:20:130920:balbi@ti.com::9Odu3pEeRgRT3MWf:0000020Yy
X-Hashcash: 1:20:130920:viro@zeniv.linux.org.uk::AL5bs/4q8Zu6xXaH:000000000000000000000000000000000000004Lz9
X-Hashcash: 1:20:130920:linux-kernel@vger.kernel.org::pNWa7DGsk5Ltxpfb:000000000000000000000000000000000Bggz
Date: Sat, 21 Sep 2013 01:10:48 +0200
Message-ID: <xa1tsiwzytqf.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 20 2013, Al Viro wrote:
> 	There's a bunch of failure exits in ffs_fs_mount() with
> seriously broken recovery logics.  Most of that appears to stem
> from misunderstanding of the ->kill_sb() semantics;

That sounds likely.

[=E2=80=A6]

> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> --=20
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index 1a66c5b..0658908 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -1034,37 +1034,19 @@ struct ffs_sb_fill_data {
>  	struct ffs_file_perms perms;
>  	umode_t root_mode;
>  	const char *dev_name;
> -	union {
> -		/* set by ffs_fs_mount(), read by ffs_sb_fill() */
> -		void *private_data;
> -		/* set by ffs_sb_fill(), read by ffs_fs_mount */
> -		struct ffs_data *ffs_data;
> -	};
> +	struct ffs_data *ffs_data;
>  };
>=20=20
>  static int ffs_sb_fill(struct super_block *sb, void *_data, int silent)
>  {
>  	struct ffs_sb_fill_data *data =3D _data;
>  	struct inode	*inode;
> -	struct ffs_data	*ffs;
> +	struct ffs_data	*ffs =3D data->ffs_data;
>=20=20
>  	ENTER();
>=20=20
> -	/* Initialise data */
> -	ffs =3D ffs_data_new();
> -	if (unlikely(!ffs))
> -		goto Enomem;
> -
>  	ffs->sb              =3D sb;
> -	ffs->dev_name        =3D kstrdup(data->dev_name, GFP_KERNEL);
> -	if (unlikely(!ffs->dev_name))
> -		goto Enomem;
> -	ffs->file_perms      =3D data->perms;
> -	ffs->private_data    =3D data->private_data;
> -
> -	/* used by the caller of this function */
> -	data->ffs_data       =3D ffs;
> -
> +	data->ffs_data       =3D NULL;
>  	sb->s_fs_info        =3D ffs;
>  	sb->s_blocksize      =3D PAGE_CACHE_SIZE;
>  	sb->s_blocksize_bits =3D PAGE_CACHE_SHIFT;
> @@ -1080,17 +1062,14 @@ static int ffs_sb_fill(struct super_block *sb, vo=
id *_data, int silent)
>  				  &data->perms);
>  	sb->s_root =3D d_make_root(inode);
>  	if (unlikely(!sb->s_root))
> -		goto Enomem;
> +		return -ENOMEM;
>=20=20
>  	/* EP0 file */
>  	if (unlikely(!ffs_sb_create_file(sb, "ep0", ffs,
>  					 &ffs_ep0_operations, NULL)))
> -		goto Enomem;
> +		return -ENOMEM;
>=20=20
>  	return 0;
> -
> -Enomem:
> -	return -ENOMEM;
>  }
>=20=20
>  static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
> @@ -1193,6 +1172,7 @@ ffs_fs_mount(struct file_system_type *t, int flags,
>  	struct dentry *rv;
>  	int ret;
>  	void *ffs_dev;
> +	struct ffs_data	*ffs;
>=20=20
>  	ENTER();
>=20=20
> @@ -1200,18 +1180,30 @@ ffs_fs_mount(struct file_system_type *t, int flag=
s,
>  	if (unlikely(ret < 0))
>  		return ERR_PTR(ret);
>=20=20
> +	ffs =3D ffs_data_new();
> +	if (unlikely(!ffs))
> +		return ERR_PTR(-ENOMEM);
> +	ffs->file_perms =3D data.perms;
> +
> +	ffs->dev_name =3D kstrdup(dev_name, GFP_KERNEL);
> +	if (unlikely(!ffs->dev_name)) {
> +		ffs_data_put(ffs);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
>  	ffs_dev =3D functionfs_acquire_dev_callback(dev_name);
> -	if (IS_ERR(ffs_dev))
> -		return ffs_dev;
> +	if (IS_ERR(ffs_dev)) {
> +		ffs_data_put(ffs);
> +		return ERR_CAST(ffs_dev);
> +	}
> +	ffs->private_data =3D ffs_dev;
> +	data.ffs_data =3D ffs;
>=20=20
> -	data.dev_name =3D dev_name;
> -	data.private_data =3D ffs_dev;
>  	rv =3D mount_nodev(t, flags, &data, ffs_sb_fill);
> -
> -	/* data.ffs_data is set by ffs_sb_fill */
> -	if (IS_ERR(rv))
> +	if (IS_ERR(rv) && data.ffs_data) {
>  		functionfs_release_dev_callback(data.ffs_data);
> -
> +		ffs_data_put(data.ffs_data);
> +	}
>  	return rv;
>  }
>=20=20

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSPNX5AAoJECBgQBJQdR/0gNsP/1q/yjDze1ImDbrLleks6ZS6
SlEMN1JGdJ71/erkWU7QLj1SzI3PQAEv1B3Z9KGR0hhyMbibvTBRIJSP+nXzTxjF
D0zQS4NTtwJNMuHOYYOz27I5hsf4yjq0W3AFRqU7aGA4K162l/VwSe/tbLD5BUdN
1x8by6GbU+5oMtojNX3AIstJ4JNo1j7GXl2p4LqnVozdMo3Vf+nTVryVDW9OfDW0
rVGI2dj4XzxdelF0mKti8d2D0NA+PFTsmWaZnLdKxF3IF/cyLnd1bzsUNSxuP0FF
tkZaiCD8cH6w+E1kWorG6DRg2xSSmqh+a1DCdb6oaYl/3Snrb6/MzaTGk60WwrF4
5/658Rs45ACrQIaG9NS0/b7d/7pzm5gZzO2Nb1v6IHVTZajeYQkae6nXpAA9KP3g
4H0bqtg1/a23pV3b3whNNhMrEpHCxsIxWYUOJNV3Owpv7BgCGEkhy0QHjDA8JiAQ
cmdGMgJhEuYmohZgPyPQRt55ISQM/Hb2gDm6wQy3XejxZvFkaVa0oUt9JNXudQiI
hag2KVhgYUKAppqGYKzzIbXu49OGAhFMnEd3T2li12X+K+JvXFMMPxCkJfH3w4C2
63wBMX7xx3W6EQZnvduVJGekG7nuT7e4MwSTmF3iC1rw3iZ1aU8dZc49UBHlYNIy
Ar0CKxQ5DAJ0sdUG6czC
=0BUA
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
