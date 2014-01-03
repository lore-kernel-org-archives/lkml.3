Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbaACUDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:03:44 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45995 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbaACUDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:03:42 -0500
Date: Fri, 3 Jan 2014 14:02:26 -0600
From: Felipe Balbi <balbi@ti.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: <akpm@linux-foundation.org>, USB list <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>
Subject: Re: mmotm 2014-01-02-14-35 uploaded (musb)
Message-ID: <20140103200226.GD18722@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140102223649.D8FB931C206@corp2gmr1-1.hot.corp.google.com>
 <52C6FA1E.4030607@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PyMzGVE0NRonI6bs"
Content-Disposition: inline
In-Reply-To: <52C6FA1E.4030607@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PyMzGVE0NRonI6bs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 03, 2014 at 09:57:50AM -0800, Randy Dunlap wrote:
> On 01/02/14 14:36, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2014-01-02-14-35 has been uploaded to
> >=20
> >    http://www.ozlabs.org/~akpm/mmotm/
> >=20
> > mmotm-readme.txt says
> >=20
> > README for mm-of-the-moment:
> >=20
> > http://www.ozlabs.org/~akpm/mmotm/
> >=20
> > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> > more than once a week.
>=20
> on x86_64:
>=20
> when CONFIG_USB is not enabled:
>=20
> drivers/built-in.o: In function `musb_init':
> musb_core.c:(.init.text+0x45fc): undefined reference to `usb_disabled'

already have a patch for that. Waiting for Greg to merge ;-)

commit 89f836a8c56bfea6585a09f7afff7094968a4fd0
Author: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Date:   Thu Dec 26 09:24:52 2013 -0300

    usb: musb: Remove usb_disable() check in module_init()
   =20
    Removing the check to usb_disable() before registering the platform
    driver allows to build this driver when !USB && USB_GADGET, to be
    used in gadget-only mode.
   =20
    Also, use module_platform_driver() to register the platform driver.
   =20
    Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Signed-off-by: Felipe Balbi <balbi@ti.com>

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 0e7f4a0..5942f00 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2325,19 +2325,4 @@ static struct platform_driver musb_driver =3D {
 	.shutdown	=3D musb_shutdown,
 };
=20
-/*------------------------------------------------------------------------=
-*/
-
-static int __init musb_init(void)
-{
-	if (usb_disabled())
-		return 0;
-
-	return platform_driver_register(&musb_driver);
-}
-module_init(musb_init);
-
-static void __exit musb_cleanup(void)
-{
-	platform_driver_unregister(&musb_driver);
-}
-module_exit(musb_cleanup);
+module_platform_driver(musb_driver);

--=20
balbi

--PyMzGVE0NRonI6bs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSxxdSAAoJEIaOsuA1yqREQawP/iJjjmuYGymOGJKsYYbZ61JF
9UH/j/3n74I5D14PUUj+bxEdG0+kNbrtP5lyKbzJNncUiJdYlyRcLDM8dEuMGIkw
nLm43bpPaw1XsndyiJ72zdIEdUmXQ6HyHSjVntkaXESU9bnLFW8e1Vb11nK7NwAP
qYTFB22yL0i2+QzRW7onk4gK9VbFW5pBXFquCmzWRbtX7MX4SNoYn0TCphngSTC6
Yj+3GTi6utz+b/FS75NcnPJFE3j7YneuxYwP1W2IRH5L1xp53QFqKV4aLQyMakqi
X4xqLw4vyJtn3kG0+SB/ULAdSYJcIeqE2Q02+LJImq8ttlQ5wWFWm6o5auIHyuHh
lXlRjWLV/5qUVbme9u8QCetyRa+RCnFqfmbOECUCpGBGbK6Kxv/nxinJlhjiTd1Z
JuXjLbChpG1hlrTMHdL7N111II28mY8VNTNzwi53CcWncDtPXciZ5jCOSbHcH4Sm
Yw1iEsQLqVv1C4dB1oJRGqbccGXCxjbrOlcpPGCfWXSZXblzeA6+V1Ka5EYZCg2E
30qoXiKY9mcacJm2G+4lieRsumCedwOTNELPzfgTt9oDhgUS9fBSg2WDfhmFvdSz
XUFBLLru7Zv1Mc5FfdnFVlnSuJZIhlFEi64DOx4u4k6bBb0Ty5JlI386jkcq+6Ae
koip7daN6BBDm8ZCAY5w
=PmLm
-----END PGP SIGNATURE-----

--PyMzGVE0NRonI6bs--
