Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab3A1J6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:58:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55839 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab3A1J6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:58:11 -0500
Date: Mon, 28 Jan 2013 10:57:54 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] pwm: Add pwm_cansleep() as exported API to users
Message-ID: <20130128095754.GA23134@avionic-0098.adnet.avionic-design.de>
References: <1359121471-21457-1-git-send-email-florian.vaussard@epfl.ch>
 <1359121471-21457-2-git-send-email-florian.vaussard@epfl.ch>
 <20130126054024.GB29243@avionic-0098.adnet.avionic-design.de>
 <51063AB5.2060108@ti.com>
 <51064687.5090605@epfl.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <51064687.5090605@epfl.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:bMaqB0n7H6l/l6WGOjl6WRd5FwyQbCVFrmTIcLDNB5q
 slt8GeW+lO3Jilhubkd6P6wS8e2IJCmxz4Ee+uXv9NSJ5IyGtT
 cgwJMGgZsZj6jLzPTSqaKaXdxdapejIo/Skd14ulIjDjMMLsy1
 G3RZm9mQxebfwLn6B/IdlfLVu4eR/0xXUr9rAl/aiTEwfvJFSo
 SXl5nA0mEqp0WXG9SgzBMGoYKZ4pi6peVNRO0zFYX/B+gjrvR3
 n6WC0xT0ivFuIC8O4rASWF5U6EXGMREP+rUHcrYKeC55IvR63T
 SV1/BtgS2C/heZSp2vLa6NJrs57A/beWQPrIzSd0OGZ5Fz2+yC
 uvfWViB8YwjjzV9YRWtNynLqxbUz9WnbbIrcaQ1C7JCcy/Oxjr
 qwv4O3WjJRVIPX4w/f5BJOnjuwd+zLSsybzPa8MRocUjyO7/nJ
 MRtIj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 10:36:07AM +0100, Florian Vaussard wrote:
> Hello,
>=20
> Le 28/01/2013 09:45, Peter Ujfalusi a =C3=A9crit :
> >hi Thierry,
> >
> >On 01/26/2013 06:40 AM, Thierry Reding wrote:
[...]
> >>>+{
> >>>+	return pwm->chip->can_sleep;
> >>>+}
> >>>+EXPORT_SYMBOL_GPL(pwm_cansleep);
> >>
> >>Would it make sense to check for NULL pointers here? I guess that
> >>passing NULL into the function could be considered a programming error
> >>and an oops would be okay, but in that case there's no point in making
> >>the function return an int. Also see my next comment.
> >
> >While it is unlikely to happen it is better to be safe, something like t=
his
> >will do:
> >
> >return pwm ? pwm->chip->can_sleep : 0;
> >
>=20
> Ok. And what about:
>=20
> BUG_ON(pwm =3D=3D NULL);
> return pwm->chip->can_sleep;

I don't think we need that. In case pwm =3D=3D NULL, dereferencing it will
oops anyway. So either we make it safe and return an error code, or we
let it oops without explicit BUG_ON().

Thierry

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRBkuiAAoJEN0jrNd/PrOhqX0QAJFEw4PeFDonzDMo9410DMav
liqmUEecakQJJGrsrTkIw5SB3+DerY9p+HAQ1S6MAuglaPTCirQNpjyj6hHktwqN
CJ4JmcGKc0gbkZuAbQvvB0Cl/34oP0hsyvGRcw9gF7Xl+X/g0OU/7FXTekq+4y49
zJLjAbv24fgTeBS8UsPrPw+5K3S3BRleREk9apau/RLgCp/eYJ4s9smJ+co8+igY
mn68xPxOyzYZP68gNKYT74qm1XPGFOH/uBPgtE7jB4QNI5deIZ8gcYVctfmVwJ3Q
6LglzLzbWioxk6GpnWfp5eQ/JWTHOocGuSlUsNRFrAmmafF4AI6QzYFOZui3nocV
nBO4NzBXw8flTT1JrXeGrlAGo2k4dxQ6+tpqqCDKNKJQO7DVEeyzQxW3qCypVL/I
N/DN05yxbNy1J24a7mJYYjr+Yi/rBwc+j4OgtAyfsQXHs5Wd5t4QxV+QCQnYWUig
ON62BJ7tvG+eHIiCnPuLhAYR1KAqcLjGmVHmqewzQ0rR612iVn5u4LRYEk40u+79
BUIkJlvVxhzwY56v5f7O+kDXNopEMpme9CtzXaL9TddpibfsPpeqdGO+DNYTvsFC
h/NOn/5fG+5NdZc9s8cOQHqAiuQH3/DrAnEcfFkDRwG+mpoWW+38AnDOEuw98blF
+SY7lwPLzbt5VXzCbXmf
=vIsP
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
