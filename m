Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbaCJNF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 09:05:59 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:38095 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbaCJNF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 09:05:57 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: Re: [PATCH] usb: gadget: f_fs: add missing spinlock and mutex unlock
In-Reply-To: <1394440417-6100-1-git-send-email-r.baldyga@samsung.com>
Organization: http://mina86.com/
References: <1394440417-6100-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140310:m.szyprowski@samsung.com::hnsqvJb8ZEvbytI3:000000000000000000000000000000000000009/0
X-Hashcash: 1:20:140310:andrzej.p@samsung.com::FV0WdOYhUWnWc5lZ:000000000000000000000000000000000000000011ng
X-Hashcash: 1:20:140310:r.baldyga@samsung.com::5w379aZqNGviwtsI:00000000000000000000000000000000000000002PSU
X-Hashcash: 1:20:140310:balbi@ti.com::+5HqCanFgofG4nXs:000001bwL
X-Hashcash: 1:20:140310:r.baldyga@samsung.com::xZWmuifdcl9rosSE:00000000000000000000000000000000000000001hUl
X-Hashcash: 1:20:140310:linux-kernel@vger.kernel.org::92wK6cJsyQIFQ9iJ:0000000000000000000000000000000002qyA
X-Hashcash: 1:20:140310:gregkh@linuxfoundation.org::bfoqq+DtokQcqG6H:000000000000000000000000000000000003Fed
X-Hashcash: 1:20:140310:linux-usb@vger.kernel.org::64pGaCVWX1Q2NMjV:0000000000000000000000000000000000005jcS
Date: Mon, 10 Mar 2014 14:05:47 +0100
Message-ID: <xa1ty50icifo.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 10 2014, Robert Baldyga <r.baldyga@samsung.com> wrote:
> This patch adds missing spin_unlock and mutex_unlock calls in
> error handling code.
>
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  drivers/usb/gadget/f_fs.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index b7d273a..d6bd0a3 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -802,7 +802,7 @@ static ssize_t ffs_epfile_io(struct file *file, struc=
t ffs_io_data *io_data)
>  		if (io_data->aio) {
>  			req =3D usb_ep_alloc_request(ep->ep, GFP_KERNEL);
>  			if (unlikely(!req))
> -				goto error;
> +				goto error_lock;
>=20=20
>  			req->buf      =3D data;
>  			req->length   =3D io_data->len;
> @@ -817,7 +817,7 @@ static ssize_t ffs_epfile_io(struct file *file, struc=
t ffs_io_data *io_data)
>  			ret =3D usb_ep_queue(ep->ep, req, GFP_ATOMIC);
>  			if (unlikely(ret)) {
>  				usb_ep_free_request(ep->ep, req);
> -				goto error;
> +				goto error_lock;
>  			}
>  			ret =3D -EIOCBQUEUED;
>=20=20
> @@ -863,6 +863,10 @@ static ssize_t ffs_epfile_io(struct file *file, stru=
ct ffs_io_data *io_data)
>=20=20
>  	mutex_unlock(&epfile->mutex);
>  	return ret;
> +
> +error_lock:
> +	spin_unlock_irq(&epfile->ffs->eps_lock);
> +	mutex_unlock(&epfile->mutex);
>  error:
>  	kfree(data);
>  	return ret;
> --=20
> 1.7.9.5
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

iQIcBAEBAgAGBQJTHbisAAoJECBgQBJQdR/0fZsQAIi+9Zy7BqGfWQLkzFDoGye4
A+Ll2cXut3Frctx9m2rubl5vJejJb5/rPRhMxuooYT3hMjm/j8BP51XDu3kLdVJf
4CwHSGmsj504YcSvfx3mUWce6mx+uyo9JGL273MZrLClUeOVI/No33CwQtoVn20L
NDL/Q9LaLyTNvmPkEIQ4SEonlMxNmkzcVvuJAkpKQzOXG3z9dt/ZGRfj5bhi8nc/
I5MY9pR6p9jVuoOB6j4xsmhhOAA80HsQF2HB+ZiAC3UDNerD3yOdb5G63QZksXrU
T5GacAzRJuk6DnalvGiJb2rpqj53b102qQVj0c+/xQHAKlQ1WbLp+7K9qsx7gOYF
4DXV7ef6+YR4F9Ho2Ls1hRyiom8Es1yFaJvVgXuLDBQpSliv3iCIg8vxeq21A/PP
flh0YZ5KikBrf92tVY5numnKbB6xdwYqFPNG2ffEWDlOoVm7+BBtjhD9iJVUnajq
Zd/Lc1aV884LZlkzInG0YsBIHAxlgnhsODnk/mIHxYdyJd8W5rL1cXC+iZy8JRmh
0vAhwAx7dyv14Ntc2SLwXfxDSWY4pcbShpDXe90TagLoONqZXorJL1JIUWsn0DiA
amz3JCUAI2rZqZwuJwPX3VRb24LsgCSfEFOfuKiW8ojlKrqpcAOtcPcwARqQpiiH
n7KrJb27MpV5eqkLqUMv
=f60N
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
