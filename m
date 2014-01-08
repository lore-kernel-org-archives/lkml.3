Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbaAHNzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:55:32 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40795 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077AbaAHNz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:55:26 -0500
Message-ID: <52CD58C8.3040703@ti.com>
Date: Wed, 8 Jan 2014 15:55:20 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Olaf Hering <olaf@aepfle.de>
CC: <plagnioj@jcrosoft.com>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbmem: really support wildcard video=options for all
 fbdev drivers
References: <1387140035-12234-1-git-send-email-olaf@aepfle.de>
In-Reply-To: <1387140035-12234-1-git-send-email-olaf@aepfle.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="xqgT1XQiKMMw9kNSvqCIhcI2cOfE7c0hM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xqgT1XQiKMMw9kNSvqCIhcI2cOfE7c0hM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-12-15 22:40, Olaf Hering wrote:
> Documentation/fb/modedb.txt states that video=3Doption should be
> considered a global option. But video_setup and fb_get_options are not
> coded that way. Instead its required to boot with video=3Ddriver:option=
 to
> set a given option in drvier.  This is cumbersome because it requires t=
o
> know in advance which driver will be active for a given board/kernel.
>=20
> The following patch implements the documented catchall for the fbdev
> drivers. It is now possible to boot with video=3DXxY without the need t=
o
> know the active driver in advance. The specific case it tries to fix is=

> syslinux in the SUSE installer which offers a menu to set a display
> resolution. Right now this just appends the vga=3D option the kernel. B=
ut
> in addition to vga=3D it should be possible to pass a generic video=3DX=
xY
> for all framebuffer/drm drivers. With this change forcing a certain
> window size of VM displays is now much easier.
>=20
> Today the video=3D option is stored in a global fb_mode_option. But
> unfortunately only drm uses it.
>=20
> Note: this change introduces a small memleak if video=3Doption is actua=
lly
> used because fb_mode_option is const. Most drivers use strsep to get to=

> individual options. This could be fixed in a followup patch which alway=
s
> releases the option string in every caller of fb_get_options.
>=20
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> ---
>  drivers/video/fbmem.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index 010d191..cde4619 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -1930,6 +1930,9 @@ int fb_get_options(const char *name, char **optio=
n)
>  				options =3D opt + name_len + 1;
>  		}
>  	}
> +	/* No match, pass global option */
> +	if (!options && option && fb_mode_option)
> +		options =3D kstrdup(fb_mode_option, GFP_KERNEL);
>  	if (options && !strncmp(options, "off", 3))
>  		retval =3D 1;
> =20
>=20

Queued for 3.14.

 Tomi



--xqgT1XQiKMMw9kNSvqCIhcI2cOfE7c0hM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSzVjIAAoJEPo9qoy8lh71EVwQAKy7oDRwVb1Pc5KMdVW00pQX
GvXDg0oeRRZzuF+wtyrugq5ytRVKvcouIvgyTKzJ7TTT31L+ETvvLwVLreamQxvI
ToaUdlx8jMRNlxPc9G/izliv9RaXmPnTkBJ91VF8mVjyekf8JYQ9vIWNIf2KM8vr
pS/LnAMsqIkiqdHY6BSZu54wsMxuaI9gJ4APa3LSZnWnKZXbgSo66wnKH6w3oY+V
a1rGC2T4kViwoLOyvb8nILC7miW8jgO6NE+lpgsuJssLfVVsazAXX2Nag8y5K/HK
0dB/cs9VKOos2BMpNvzBFEPEeLuX9ZepYefeHlYyTiYteAOOEH9WXtfKiUxziRUn
vXs4zRm9IdMqvHwSUpiSKAPidIHqw/g23wchbYcLxfnsTXL6B0TF7xS1MO2dG34o
MVuIxRzOfbwo2+9htQM+7oS7kd2SnRGqgpFbFN2GvfRQoFjwkHUe9iKCRSgXQCW1
5TofJ/uR8H1zBsDliEizzZhJwZulYtZsm8NyoFXje0bglFDtvQom3jCNoL57ovQI
YysUBv8ziWndECjvYdRKpfuATlFHm24YAFcqJmTgSfg9y57PfKBxL18Hq3vNiqeY
juwnjA1W0uVF4AgslnwUcJUpV8trulTseWN1fKpeRyrJb6oVH7V7Az4V+AdUpMQ4
dtb94I8j2FRklUVB/LWF
=77Zb
-----END PGP SIGNATURE-----

--xqgT1XQiKMMw9kNSvqCIhcI2cOfE7c0hM--
