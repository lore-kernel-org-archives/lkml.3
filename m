Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3AKOWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:22:09 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48374 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3AKOWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:22:06 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Andy Whitcroft <apw@shadowen.org>, Alexander Nyberg <alexn@dsv.su.se>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2 1/2] Fix wrong EOF compare
In-Reply-To: <1357871401-7075-1-git-send-email-minchan@kernel.org>
Organization: http://mina86.com/
References: <1357871401-7075-1-git-send-email-minchan@kernel.org>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Fri, 11 Jan 2013 15:21:55 +0100
Message-ID: <xa1tbocvby0s.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 11 2013, Minchan Kim <minchan@kernel.org> wrote:
> The C standards allows the character type char to be singed or unsinged,
> depending on the platform and compiler. Most of systems uses signed char,
> but those based on PowerPC and ARM processors typically use unsigned char.
> This can lead to unexpected results when the variable is used to compare
> with EOF(-1). It happens my ARM system and this patch fixes it.
>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Andy Whitcroft <apw@shadowen.org>
> Cc: Alexander Nyberg <alexn@dsv.su.se>
> Cc: Michal Nazarewicz <mina86@mina86.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> Cc: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  Documentation/page_owner.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/page_owner.c b/Documentation/page_owner.c
> index f0156e1..43dde96 100644
> --- a/Documentation/page_owner.c
> +++ b/Documentation/page_owner.c
> @@ -32,12 +32,13 @@ int read_block(char *buf, FILE *fin)
>  {
>  	int ret =3D 0;
>  	int hit =3D 0;
> +	int val;
>  	char *curr =3D buf;
>=20=20
>  	for (;;) {
> -		*curr =3D getc(fin);
> -		if (*curr =3D=3D EOF) return -1;
> -
> +		val =3D getc(fin);
> +		if (val =3D=3D EOF) return -1;
> +		*curr =3D val;
>  		ret++;
>  		if (*curr =3D=3D '\n' && hit =3D=3D 1)
>  			return ret - 1;

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQ8CADAAoJECBgQBJQdR/0VJIP+QGfrRUQHb1JqdrnDZ1w/W/w
3vgB7tW6+gbrHC84KYy0uiQHjgpzecSk7Sc7mM3SkJPi34OZIHlG9gkSD+HNRAbU
5BO7xMTvxpwNdvW6HtECj/Q2LlqrsbwWiRL0an9SvB67cnxTqrMxl2layDOwskqF
EE5U7XV8cxwkxFoWxqDx8RjMYwxTvqrI6O6HacpQzKKuRnk0HZYdnyzc6xWjqEuP
f9k+y8QHBAVmqTNFDhlqHuDuREKjtXB6JdzDXH/MQXTXNosQM2+Ngme4UgAviRyp
1mG+c8VllMAGesfohgc/VNQiJtc0RUdwjLq68tP6r67h+8BpbQx7SF+bJ3sRXSpO
K7mLLU4qlxw/yoyK50sa+xH5FMcvjmEQCDKLzhKMIPL0CZtPvV/5djVh4Qjdrrzu
8sjCNGoQgrqvZxE6CSjENIflzdhgEatGpEdOXi4rbOCFXvE/cgVgL4YtGfw5OFOB
LoF18rhMrgyg4stwZrPCZx0iKULyuUzxH7LKkGy3VlH2jge9YlqqJlMDdhkym2GO
I4IYi8LcVsKZ9zxZbpSM+PnyZ0k5a8vK0O8bJ8zlY1xA6dBMLAgjvYTpmN45w2KD
HrLegLNdT8TUXPTAki+CJ0CzVZqupyDCCANerkoCQy3efPX8EvwGm47sXx0X9Y42
ko/auHQbZkt3XUID+2Ho
=k20u
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
