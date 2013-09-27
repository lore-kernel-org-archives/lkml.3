Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab3I0OFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:05:18 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:47547 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3I0OFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:05:12 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: Re: [PATCH] USB: gadget: f_fs: fix error handling
In-Reply-To: <1380277734-17590-1-git-send-email-r.baldyga@samsung.com>
Organization: http://mina86.com/
References: <1380277734-17590-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:130927:linux-usb@vger.kernel.org::T0WNHe0zgHHb2iFY:00000000000000000000000000000000000005M4
X-Hashcash: 1:20:130927:m.szyprowski@samsung.com::5UqOM/CG9o+roQz6:00000000000000000000000000000000000000GRE
X-Hashcash: 1:20:130927:andrzej.p@samsung.com::nnEyLFJRaYhotJ4x:00000000000000000000000000000000000000000rqm
X-Hashcash: 1:20:130927:r.baldyga@samsung.com::WVGrTWhZXxcffZGR:00000000000000000000000000000000000000000vQu
X-Hashcash: 1:20:130927:b.zolnierkie@samsung.com::efiHg+tKsA9PY7A4:00000000000000000000000000000000000001+QS
X-Hashcash: 1:20:130927:gregkh@linuxfoundation.org::kAFGcWZ63dUrNVvE:000000000000000000000000000000000001y5H
X-Hashcash: 1:20:130927:linux-kernel@vger.kernel.org::i8yq29FWulynOKeP:00000000000000000000000000000000088Jz
X-Hashcash: 1:20:130927:balbi@ti.com::ykdbAZ+Z/Xus2A+w:00000D3Zv
X-Hashcash: 1:20:130927:r.baldyga@samsung.com::zb30r6DfkSLEpDJo:0000000000000000000000000000000000000000E7E0
Date: Fri, 27 Sep 2013 16:05:03 +0200
Message-ID: <xa1thad6xsvk.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27 2013, Robert Baldyga wrote:
> This patch add missing error check in ffs_func_bind() function, after
> ffs_do_descs() funcion call for hs descriptors. Without this check it's
> possible that the module will try dereference incorrect pointer.
>
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  drivers/usb/gadget/f_fs.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index 1a66c5b..fe7d532 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -2264,7 +2264,10 @@ static int ffs_func_bind(struct usb_configuration =
*c,
>  				   data->raw_descs + ret,
>  				   (sizeof data->raw_descs) - ret,
>  				   __ffs_func_bind_do_descs, func);
> +		if (unlikely(ret < 0))
> +			goto error;
>  	}
> +=09

This new line with only a tab in it is not needed here though.

>=20=20
>  	/*
>  	 * Now handle interface numbers allocation and interface and

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

iQIcBAEBAgAGBQJSRZCPAAoJECBgQBJQdR/0rS0P/jMKAVMUaVSy5/bcekKFpR33
vYPzxC4sJTV5AfLRkHJNOgnvVTTlFnkvOcY6nmySakUF2FhUVXkTp1phosvasqKq
N27mO6YMh8ga1R4M/vlZtiRl/ASy4DgDvDpmLNrBmWIlo37Nlw4Fv2lHKmB+xAmY
eP/34JvVzrGtsLkT+zwagdAb3NwaA7EX+R5PUUR1lvqhafKyl6bS0NVXcYpQAJ4A
gOu2eQgudCblGrShEmwmjYofN+b1cLVE42ucmgmu1bcQb/Ha56K2D0puMxuQF6On
zomC5dwTRb2ycsN67qkDS+OEBhZ1uiQppmjsPqyu46/MTFmaZJ5Pz+vxtygt1CPv
WayVRfT28SDNYK/RPFz0XDVCB6i2pxkj6bnEkkhOYBwAmJTsHgvsmG6PCB+GRCvS
9EqcXoWSagc/Y32zAaj8x5Kl//KtssdMteF/xVltM5r25D9vpwjRBD+WCOMclMUq
YLir7ERLLRpZ5yY+qmyvPt/NXwREkEw8ZpguJzxk0wjtlF/YYwcXnVqApRZFIIaN
O7896r5eEZM0Era6jqpCChoaPmpHHpUOwACsoNZ0F+saM8ku7hhSdPEwtqueWLcw
o88vgF9ZMfln2DcmL5BT7WAusxJZZELCdPq39Q/PZS76GrD1wMaefCnhOkv9IU1q
/nbiPnBv3y8+NxJImQ7O
=CIg8
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
