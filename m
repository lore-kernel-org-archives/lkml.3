Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbaB0MPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:15:38 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:46460 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaB0MPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:15:35 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Chuansheng Liu <chuansheng.liu@intel.com>, balbi@ti.com,
        gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        david.a.cohen@intel.com, jin.can.zhuang@intel.com, yu.y.wang@intel.com,
        Chuansheng Liu <chuansheng.liu@intel.com>
Subject: Re: [PATCH] usb: gadget: return the right length in ffs_epfile_io()
In-Reply-To: <1393483771-24623-1-git-send-email-chuansheng.liu@intel.com>
Organization: http://mina86.com/
References: <1393483771-24623-1-git-send-email-chuansheng.liu@intel.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140227:yu.y.wang@intel.com::KzHlw6wMoFDW3PBb:0000000000000000000000000000000000000000001iPq
X-Hashcash: 1:20:140227:linux-usb@vger.kernel.org::wDFVbVbASApsI/5U:00000000000000000000000000000000000024YT
X-Hashcash: 1:20:140227:gregkh@linuxfoundation.org::sXDYGoeUPhaFRr+v:000000000000000000000000000000000003TsN
X-Hashcash: 1:20:140227:chuansheng.liu@intel.com::TwtZIJn+SpY7ifIa:00000000000000000000000000000000000003iDo
X-Hashcash: 1:20:140227:linux-kernel@vger.kernel.org::oy2FsqZrsvLV7Ziv:00000000000000000000000000000000045q4
X-Hashcash: 1:20:140227:david.a.cohen@intel.com::z3o7TsdfHDpqWSsQ:000000000000000000000000000000000000005jH1
X-Hashcash: 1:20:140227:chuansheng.liu@intel.com::HLQ+Ay3PoCXvRxJn:00000000000000000000000000000000000005K3K
X-Hashcash: 1:20:140227:jin.can.zhuang@intel.com::2B6XOOdgPeF+J5XZ:00000000000000000000000000000000000008p1D
X-Hashcash: 1:20:140227:balbi@ti.com::qXg6rRnJbegi7noP:00000CQ8b
Date: Thu, 27 Feb 2014 13:15:25 +0100
Message-ID: <xa1teh2o4uqq.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27 2014, Chuansheng Liu <chuansheng.liu@intel.com> wrote:
> When the request length is aligned to maxpacketsize, sometimes
> the return length ret > the user space requested len.
>
> At that time, we will use min_t(size_t, ret, len) to limit the
> size in case of user data buffer overflow.
>
> But we need return the min_t(size_t, ret, len) to tell the user
> space rightly also.
>
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  drivers/usb/gadget/f_fs.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index 2b43343..31ee7af 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -687,10 +687,12 @@ static ssize_t ffs_epfile_io(struct file *file,
>  			 * space for.
>  			 */
>  			ret =3D ep->status;
> -			if (read && ret > 0 &&
> -			    unlikely(copy_to_user(buf, data,
> -						  min_t(size_t, ret, len))))
> -				ret =3D -EFAULT;
> +			if (read && ret > 0) {
> +				ret =3D min_t(size_t, ret, len);
> +
> +				if (unlikely(copy_to_user(buf, data, ret)))
> +					ret =3D -EFAULT;
> +			}
>  		}
>  	}
>=20=20
> --=20
> 1.9.rc0
>

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

iQIcBAEBAgAGBQJTDyxdAAoJECBgQBJQdR/0+m8QAJFaybaNbXMaJ4oAfx7i+Q44
dWI32zE00cA76iymP456+hpNYKBj4mNCsuZRYyemhWqm2NedX7xGuC+Az9eZH1Ce
/VC3XNeWG9Wt1uRXS4LsRZBRFa49RtigH+LaGsNnK1qpGGqZqrG9GhJnKWdcZFOn
KNJ2k2GGpF/r1tc29X2VSOOo+nvGcPU+L7FZ/lfO9+mqI9y6DLlCUEGwIz8c/agp
v7qh3H0itJmXXvu3iKe6rpbTJYj7CxUWw/TSFrBDySoHdgJLOac6KzY+9ZUkL/j+
gslPeAj7DnpDUe7CYngbIE5H1ZMPDXK2WDLBOFc+bMWrfWI0tBgR7BgtBMgBdGAH
J60x9Xii4+rSgzE/BnfRS/GxEvFGQH9ENar1T/kD9jTtjTTdc2x59/TFoNd+QqF7
2KiW9gPSlrG/m6M6l6RDhk/944gUjohCTuMsTK4yJZME0xGkzIJnstxSfTO1e/iL
3lgFpsHZIDNGDgy4Qb7VfOvm+bLBkKwcXLRb41NUuMt1R6fl1bon9IjT+fQUqjWP
Dw+g2lqWyNIPcn5wNYJYOzBo6EMXo0Cx1z5J/y2RNcx9zI5DS76tndi4X6+nc+74
H0tzvE/dLNzo0oQLhJKN/dX2KzRkXfGi54LVnasNHR6nEeSUSZmb0mXKAejZRzB9
Hv6xzbkpH19fQci7NtbU
=GU4c
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
