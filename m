Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaL2IFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 03:05:40 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46504 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbaL2IFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 03:05:38 -0500
Message-ID: <54A10B1E.7030800@ti.com>
Date: Mon, 29 Dec 2014 10:04:46 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>, Pavel Machek <pavel@ucw.cz>
CC: =?windows-1252?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Nishanth Menon <nm@ti.com>, linux-omap <linux-omap@vger.kernel.org>,
        <sre@debian.org>, Tony Lindgren <tony@atomide.com>, <sre@ring0.de>,
        <ivo.g.dimitrov.75@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: v3.19-rc1 regression(?) on N900
References: <549B44E2.6080202@ti.com> <201412250932.40403@pali> <20141225091121.GA20355@amd> <20141225222122.GB582@fuloong-minipc.musicnaut.iki.fi>
In-Reply-To: <20141225222122.GB582@fuloong-minipc.musicnaut.iki.fi>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="PlKCKNe25GcJQ9FIDt4TT7oE5U7qXfVW5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PlKCKNe25GcJQ9FIDt4TT7oE5U7qXfVW5
Content-Type: multipart/mixed;
 boundary="------------070708010705000405090003"

This is a multi-part message in MIME format.
--------------070708010705000405090003
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi,

On 26/12/14 00:21, Aaro Koskinen wrote:

> ...however, I can confirm that framebuffer is broken:
>=20
> [    8.230743] omapfb omapfb: no displays
> [    8.255584] omapfb omapfb: failed to setup omapfb
> [    8.260620] platform omapfb: Driver omapfb requests probe deferral
> [    8.284118] of_get_named_gpiod_flags: parsed 'reset-gpios' property =
of node
> '/ocp/spi@48098000/acx565akm@2[0]' - status (0)
> [    8.284271] acx565akm spi1.2: failed to find video source
> [    8.290069] spi spi1.2: Driver acx565akm requests probe deferral
>=20
> I bisected it to ef691ff48bc8 (OMAPDSS: DT: Get source endpoint
> by matching reg-id). When I revert that, also FB works with 3.19-rc1.

I've attached a patch for this. Only hack-tested on OMAP3 beagle, so
please report if it works.

 Tomi


--------------070708010705000405090003
Content-Type: text/x-patch;
 name="0001-OMAPDSS-SDI-fix-output-port_num.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-OMAPDSS-SDI-fix-output-port_num.patch"

=46rom fe3e8dde8eae80541a3f3b39c421428ebd02955f Mon Sep 17 00:00:00 2001
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Date: Mon, 29 Dec 2014 09:57:11 +0200
Subject: [PATCH] OMAPDSS: SDI: fix output port_num

After the commit ef691ff48bc8 (OMAPDSS: DT: Get source endpoint by
matching reg-id) we look for the SDI output using the port number.
However, the SDI driver doesn't set the port number, which causes the
SDI display to not initialize.

Fix this by setting the SDI port number to 1. We use a hardcoded value,
as SDI was used only on OMAP3 and it's always port number 1 there.

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reported-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/video/fbdev/omap2/dss/sdi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/omap2/dss/sdi.c b/drivers/video/fbdev/om=
ap2/dss/sdi.c
index d51a983075bc..5c2ccab5a958 100644
--- a/drivers/video/fbdev/omap2/dss/sdi.c
+++ b/drivers/video/fbdev/omap2/dss/sdi.c
@@ -342,6 +342,8 @@ static void sdi_init_output(struct platform_device *p=
dev)
 	out->output_type =3D OMAP_DISPLAY_TYPE_SDI;
 	out->name =3D "sdi.0";
 	out->dispc_channel =3D OMAP_DSS_CHANNEL_LCD;
+	/* We have SDI only on OMAP3, where it's on port 1 */
+	out->port_num =3D 1;
 	out->ops.sdi =3D &sdi_ops;
 	out->owner =3D THIS_MODULE;
=20
--=20
2.2.1


--------------070708010705000405090003--

--PlKCKNe25GcJQ9FIDt4TT7oE5U7qXfVW5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUoQseAAoJEPo9qoy8lh71LXwP+gI6VeCP40rzldPbxV9x7bez
ImxlAT/NUuKLlPncW5Iz36VMo5rYKn9DRvQnfY1Ha0QtD5VQ50/3Lg8/DekS6T2i
4VDljIXu/pPN2BWaB7NBoS7Fm/K/KJwnjx1LXWhDOdX1m6vir0tgYgr2Tiqp6Oll
s/Jg8iAoYBTrecBYJpRWQ8FgU76evjP4R8qD3b2rFWVbhWW/Slp3jJGrs0HlfkPN
TP+AJFYzwyBjDzY0joFG+fz7UhlTeZv6PSaTX3dVbOTC47REAvcBFeWY3OABi9Mk
WCKrm0ngxsKRPk6CLSlfBkkZseqiFPGFMcb2rUi+xTVO1kd1Ji0HYoV3+Nz43J7A
eWg5T9ZJGCbLqdJ7larC+xBr9dSE4arcP4rv3UV8N2n5IZTBqcbwCSTUta2AlE7S
zGxttn0+6vW4PAnRnECcUpvoP1KXcjGIEc6q7I6d43irNHCFfQmCHSCb7Sgk12ww
dRjSX1vM5mE3O/5QE5GXFoeixdhUXuA7waEgpPjYfNfBRbfDIUbDTfOIM2kyDQ+Q
1MoEXF7ikmN5vRrZ5+juBedBhmPqNm7gVopXBqK/B4DAQU5Q+hYMoGunuiP3MU7p
bxxQi9uBEIuGCkLYnyzw0J6F99hrQn+Zegpj2Am4sMO7Ep7rGQizu65GfIPB7vP6
Ectyj3HHdA0Cz3av1Jy8
=/NFK
-----END PGP SIGNATURE-----

--PlKCKNe25GcJQ9FIDt4TT7oE5U7qXfVW5--
