Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaFENLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:11:36 -0400
Received: from sauhun.de ([89.238.76.85]:45181 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbaFENLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:11:34 -0400
Date: Thu, 5 Jun 2014 15:11:23 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, khali@linux-fr.org,
        linus.walleij@linaro.org, paul.gortmaker@windriver.com,
        jg1.han@samsung.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        Jim Davis <jim.epost@gmail.com>
Subject: Re: [PATCH] i2c: pca954x: Fix compilation without CONFIG_GPIOLIB
Message-ID: <20140605131123.GA2837@katana>
References: <CA+r1Zhi9Qd4aZ2WJ02K4Gv=zg7QvG+r=t2VpiXRKXcYRc1vt=A@mail.gmail.com>
 <1401900992-16581-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <1401900992-16581-1-git-send-email-laurent.pinchart@ideasonboard.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 06:56:32PM +0200, Laurent Pinchart wrote:
> The pca954x driver recently switched to the GPIO descriptor API without
> including the correct <linux/gpio/consumer.h> header. This breaks
> compilation without CONFIG_GPIOLIB.
>=20
> drivers/i2c/muxes/i2c-mux-pca954x.c: In function =E2=80=98pca954x_probe=
=E2=80=99:
> drivers/i2c/muxes/i2c-mux-pca954x.c:204:2: error: implicit declaration
> of function =E2=80=98devm_gpiod_get=E2=80=99 [-Werror=3Dimplicit-function=
-declaration]
>   gpio =3D devm_gpiod_get(&client->dev, "reset");
>   ^
> drivers/i2c/muxes/i2c-mux-pca954x.c:204:7: warning: assignment makes
> pointer from integer without a cast [enabled by default]
>   gpio =3D devm_gpiod_get(&client->dev, "reset");
>        ^
> drivers/i2c/muxes/i2c-mux-pca954x.c:206:3: error: implicit declaration
> of function =E2=80=98gpiod_direction_output=E2=80=99
> [-Werror=3Dimplicit-function-declaration]
>    gpiod_direction_output(gpio, 0);
>    ^
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/i2c/muxes/i2c-mux-pca954x.o] Error 1
>=20
> Fix it by including the right header.
>=20
> Reported-by: Jim Davis <jim.epost@gmail.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Applied to for-next, thanks!


--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTkGx7AAoJEBQN5MwUoCm26ZMP/irveKFJYHwzFytMwXgURcIL
b+ujBwBPeBwtrWKWus96Ye6lk527d0hJRLMjemyT+M1IfGaUsKTJ4ivXcOq7Hfix
KxEeV6yv3h9Epuxe/STzOQW3FqMYH3gLi4OK/bvyyOwDNKrN9vb7cVRgWSF+egWv
qLLK+c8Y7/xNH6XG14bBBdncyKg73WFD4SWthL3zx/whX3/XZsGYnv1TvOfKw2R8
UVVq96gam6sEN+GbvYiqARqm5m6QScr88TmXF3fKF+qGrHQ6Xtr3fb1hqsuu1yhr
xChacX4zIZy0TrNHpB/UjdyajrV+gHhJeCRtMe8T/W9nY5Y5jeav8NL8/PFdb2Ja
EWCTnuE6N/jg92qEDuwFbSFEme+qHLP8Gf18s1F2zgzz2VLiv7F+PqtodBTT9/Zf
5ad40MsYU0doHs0B369AwK+M8iG/tB0YjLSp87192ScoYCm62Sz6wlX8LkoylGJB
o3vKxvf8TRXhPnz2rOyz27GNGb3wvBj2+xaiZ+Ueoid+6pICPXCo6w/2Jvu9vz+R
DpbspKPrOHpohmMiCz2XeMxOMs4fslMSVwyaS3SNbdETRvA2NM33XO1u4SwMZsrd
vHa5cXETkUUW4nCu9zcPjzRiN7ZkusIqWVk587TnL3iDzgQAmsAJslRoKTjoHyAy
puBO6JCFDOwOyEjE1ksF
=4lr5
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
