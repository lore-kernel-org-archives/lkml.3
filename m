Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761418Ab3LITXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:23:18 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:32835 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823Ab3LITXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:23:15 -0500
Date: Mon, 9 Dec 2013 13:21:57 -0600
From: Felipe Balbi <balbi@ti.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: USB list <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] gadget: make USB_CONFIGFS_MASS_STORAGE depend on BLOCK
Message-ID: <20131209192157.GA28441@saruman.home>
Reply-To: <balbi@ti.com>
References: <52A61781.6070708@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <52A61781.6070708@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 09, 2013 at 11:18:25AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>=20
> Make USB_CONFIGFS_MASS_STORAGE depend on BLOCK just like the other
> gadget MASS_STORAGE options do.  This fixes the following build errors
> that occur when BLOCK is not enabled:
>=20
> drivers/usb/gadget/storage_common.c: In function 'fsg_lun_open':
> drivers/usb/gadget/storage_common.c:241:3: error: implicit declaration of=
 function 'bdev_logical_block_size' [-Werror=3Dimplicit-function-declaratio=
n]
> drivers/usb/gadget/storage_common.c:242:3: error: implicit declaration of=
 function 'blksize_bits' [-Werror=3Dimplicit-function-declaration]
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Cc: Felipe Balbi <balbi@ti.com>

Already have a patch for that

commit bc912b0d237c1d376214616ae0c9d12b7d542ab4
Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Date:   Mon Nov 4 13:46:17 2013 +0100

    usb: gadget: f_mass_storage: fix mass storage dependency
   =20
    Legacy gadgets supporting mass storage (g_mass_storage, g_acm_ms, g_mul=
ti)
    all depend on BLOCK.
   =20
    Make the standalone compilation of f_mass_storage (without any legacy
    gadget) dependent no BLOCK, too.
   =20
    Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
    Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
    Signed-off-by: Felipe Balbi <balbi@ti.com>

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index a91e642..f66d96a 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -682,6 +682,7 @@ config USB_CONFIGFS_PHONET
 config USB_CONFIGFS_MASS_STORAGE
 	boolean "Mass storage"
 	depends on USB_CONFIGFS
+	depends on BLOCK
 	select USB_F_MASS_STORAGE
 	help
 	  The Mass Storage Gadget acts as a USB Mass Storage disk drive.

--=20
balbi

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSphhVAAoJEIaOsuA1yqRE4CUP/AnEjtg7gtp1a7eTbEH5dh5T
zA56JRWInZ+djD4ijB3TZZuCel8zuoSArs7sR5FDG6XgGQagRNm++usdEsumyfB6
OFnPY5f+ija/ND1WpZ90D1sUEyozn52wXF3a2bV6aOw08eo/LqU6+IXmT1HQJSuz
E8kuBc8aq8P+iGZfsOPLa7FoHZk7WPIQ649vjRm9e1xUwBz8afTXPyHbF/h6Bu5G
n1SrsMlcqAMDtqeSd+PBu08RZfuZPv/xBXg977G6xuf1a119AMwDVsdOEete19T7
AtSDsHEHtZ9z/KhjUH6u8JKYJFLaInoEmfS+P2facgcxDdzsWvu2xna08o2Ripzw
uT0zY6F/kRCenXkhwxG2RHkUrmcVRBp6GtcOeji+7Q3V/cyfNYeqAmZ7uGjAFLaN
2MUI/zdCYgo3p9zWtUA8q6zr5tod+Mb0RoUL7RDlqNj14vQ6IWibKFWOdIfWur3c
8aKiHUmjve2W7M140bloou2/8PATAywX9uKjHCNRDGfqYGH6FYWzvWyhI4ekzBFc
DjhcqQ4YcQn9go7fdwSQd5HOofoW6VtzjBj6nrL4gRGmBnp97EyZK+HFLLJI9M7e
7APgWAAj0EgebPjhcNGEMxC9KzZJFt3lgJk235pYzo5AGE9aXRxMXQ8TKvEmnLcM
dbIfQl/MuhrOqfWXeGAo
=kLFc
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
