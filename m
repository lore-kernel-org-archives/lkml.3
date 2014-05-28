Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbaE1JAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:00:23 -0400
Received: from ozlabs.org ([103.22.144.67]:46300 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707AbaE1JAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:00:18 -0400
Date: Wed, 28 May 2014 19:00:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Welling <mwelling@ieee.org>, Michael Stickel <ms@mycable.de>
Subject: linux-next: manual merge of the gpio tree with Linus' tree
Message-ID: <20140528190011.302a2e52@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/TPwkKhNGZJT+1fBOMj5nWa/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TPwkKhNGZJT+1fBOMj5nWa/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the gpio tree got a conflict in
drivers/gpio/gpio-mcp23s08.c between commit 99e4b98dbe3a ("gpio:
mcp23s08: Bug fix of SPI device tree registration") from Linus' tree
and commit 3e3bed913e8b ("gpio: mcp23s08: fixed count variable for
devicetree probing") from the gpio tree.

I fixed it up (one way - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpio/gpio-mcp23s08.c
index 3d53fd6880d1,00fbb30b9b10..000000000000
--- a/drivers/gpio/gpio-mcp23s08.c
+++ b/drivers/gpio/gpio-mcp23s08.c
@@@ -894,11 -894,14 +894,12 @@@ static int mcp23s08_probe(struct spi_de
  			dev_err(&spi->dev, "invalid spi-present-mask\n");
  			return -ENODEV;
  		}
+=20
  		for (addr =3D 0; addr < ARRAY_SIZE(pdata->chip); addr++) {
- 			if ((spi_present_mask & (1 << addr)))
- 				chips++;
  			pullups[addr] =3D 0;
+ 			if (spi_present_mask & (1 << addr))
+ 				chips++;
  		}
 -		if (!chips)
 -			return -ENODEV;
  	} else {
  		type =3D spi_get_device_id(spi)->driver_data;
  		pdata =3D dev_get_platdata(&spi->dev);

--Sig_/TPwkKhNGZJT+1fBOMj5nWa/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJThaWfAAoJEMDTa8Ir7ZwV0UEQAIBo6nZspFPtG7jMR8swlkL9
kKZcam2RgJ4Q0RGu+M4BOuQA2aUEmyqLOlY0xVy8eZT9e/HETfxbFBnS8bTd+ZxG
g/7VjZaM2OSuJxrcvfRRVjCy8IXm0tK/HUjLLwntmk79U4nK/kUTadNOUYD60BxU
jwmSKAyoiDliOo4IeBsllYn0fbsQvl5vnESfTG4t8v8gEOoBbxnSEqPgq5XAp5fn
vRRqmM7uPFr5ijep2D+AcpxOQeJywM0qtesgtvoJRp5FElERQQMNbvzrZHcPpDEF
EchQECEF8zBPP5pqDKjLnPZBI5qkbBKC5yBy5hHqRYEm3asFlOfdqgZhes7t0M/U
Tw1lf+CK60tZg9PjKTkSsesYSjbq+wv/d5GJvm1Lc6taUNyiXwaQjZGz7jv7f9sC
P9oUFxZGwRWlxeXlWsJ9rTGOF6uyo40x1CPDLvu2DO/DKaly5FIbwXDHmf7jEgzD
zPVcBjGVbsepuOLZG0Vmo8jlnQ0Uuc0hcjdwpiOUJR0IzIUtz40phnuerRmHyJZk
hpVRjg8zMgLYXde8CSIpZBBydu+eqOymM+c9mxnrEr+xv/tKEFOYXj2z5g7W5jDN
XtgdpxMlLNXJHC1bfWtdtnrtGWRHhjR0HhD8pH7J0+hzmpdrOuYnwjn0awEmM6n9
QYwR9Ri+BNSj/vWAAZ+V
=tc7a
-----END PGP SIGNATURE-----

--Sig_/TPwkKhNGZJT+1fBOMj5nWa/--
