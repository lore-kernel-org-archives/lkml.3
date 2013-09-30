Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab3I3Lui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:50:38 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:40342 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab3I3Luf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:50:35 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: Re: [PATCH v2] USB: gadget: f_fs: fix error handling
In-Reply-To: <1380534101-23956-1-git-send-email-r.baldyga@samsung.com>
Organization: http://mina86.com/
References: <1380534101-23956-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:130930:r.baldyga@samsung.com::MZszmjbyesvuTKX1:000000000000000000000000000000000000000003S/
X-Hashcash: 1:20:130930:r.baldyga@samsung.com::8Mu12TzoIrSazaGu:00000000000000000000000000000000000000000hOn
X-Hashcash: 1:20:130930:b.zolnierkie@samsung.com::bjUJRYdR1ommzXgw:00000000000000000000000000000000000000Nq4
X-Hashcash: 1:20:130930:balbi@ti.com::0qxH6ZMuvuMw1iRg:000000M/3
X-Hashcash: 1:20:130930:linux-usb@vger.kernel.org::0WtGL6TJ2+iVS+nd:0000000000000000000000000000000000001bdq
X-Hashcash: 1:20:130930:gregkh@linuxfoundation.org::/G4yx7LMqqDXv7Xn:000000000000000000000000000000000002EN+
X-Hashcash: 1:20:130930:linux-kernel@vger.kernel.org::5krVqVagR0nb6hz2:0000000000000000000000000000000003re8
X-Hashcash: 1:20:130930:andrzej.p@samsung.com::COC/8zUcVKhKHOjF:0000000000000000000000000000000000000000972V
X-Hashcash: 1:20:130930:m.szyprowski@samsung.com::8kGOskjpDxhz5rfU:0000000000000000000000000000000000000CvJa
Date: Mon, 30 Sep 2013 13:50:25 +0200
Message-ID: <xa1teh868r5q.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30 2013, Robert Baldyga wrote:
> Hello,
>
> This is update for my patch fixing error handling in functionfs module.
> I have fixed typos from previous version, and changed description for gre=
ater
> clearity as Sergei Shtylyov suggested.
>
> This patch add missing error check in ffs_func_bind() function, after
> ffs_do_descs() function call for high speed descriptors. Without this che=
ck
> it's possible that the module will try to dereference incorrect pointer.
>
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> Changelog:
>
> v2:
> - fix typos
> - expand patch desctiprion
>
> v1: https://lkml.org/lkml/2013/9/27/128
> ---

Note that it's helpful for maintainers to include everything that is not
meant to go in the commit message after those three minus signs.  This
way, =E2=80=9Cgit am=E2=80=9D will ignore the text.

>  drivers/usb/gadget/f_fs.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index 1a66c5b..0da66ba 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -2264,6 +2264,8 @@ static int ffs_func_bind(struct usb_configuration *=
c,
>  				   data->raw_descs + ret,
>  				   (sizeof data->raw_descs) - ret,
>  				   __ffs_func_bind_do_descs, func);
> +		if (unlikely(ret < 0))
> +			goto error;
>  	}
>=20=20
>  	/*
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

iQIcBAEBAgAGBQJSSWWBAAoJECBgQBJQdR/0ET0P/A47TkSNngYwCdaWZJCr16iD
WGRFUM3jYEWldyrtENcXUzL34ivjgJWDtVMbWdkjernz2qwQ0zN9Iu48TPiFrGtW
PLH24TtYvsq7q51qClHk9Uf7uBA0oJXiDRaBsIU7ZFz8kTPea/CeI9z82T6sclSr
w/raIre27wxKfPoaMjwo+OpxgTPL7eUIrV/PGBtoFNGQ17ZXmMmV/kak4TYItkcZ
G5xPJMPOI09YJGlWW53H92XTamhLeuYb/w7ZAe7UZyNL6o1etYBTG9mLGgfWFdAv
qOI4cUzf/bMNsvkYy9gtMbJ2pilwkpPuE6pGHudHyqjbwn9kqdjdOA/gDGxh+4Qt
4M9KqSxTsrI8W56+3wwSoJbWpC0n2vYp+MXh7aLn+Mkbuco9DfLL/9ELrQZkGA0f
LvwpeiEsrwOQ5idjTM7p7ZthdLInjte2duXJ41tAW5s87g53TbDpu/T2gP8mxPX0
rY39tZduwhSL30HFmdeiweIW1EBJ/BC6CIWpzX12Orjad3yUig2gWeJrhKFsGKNK
SrOqf3H5knHzc2MAgtTRsos/vzCx0RpGbzvQ2K27n2FeuWj1/69cliKeUPJmIgfW
WZ62228plC99XLrAMDcrCB1dQsrotPtRFvcvk1pH9vBpdYrhaLscl9ESS3Sq6vXN
BBkHF7UyLPwfM9Z9zAlN
=kk9O
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
