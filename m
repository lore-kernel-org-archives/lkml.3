Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaHDETC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 00:19:02 -0400
Received: from ozlabs.org ([103.22.144.67]:52121 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbaHDETA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 00:19:00 -0400
Date: Mon, 4 Aug 2014 14:18:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?U3TDqXBoYW5l?= Marchesin <marcheu@chromium.org>
Subject: linux-next: build failure after merge of the drm-tegra tree
Message-ID: <20140804141832.442adee8@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/GQ4OTh+virfOB6rSznuJe7F"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/GQ4OTh+virfOB6rSznuJe7F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Thierry,

After merging the drm-tegra tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

In file included from include/asm-generic/bug.h:13:0,
                 from arch/arm/include/asm/bug.h:61,
                 from include/linux/bug.h:4,
                 from include/linux/scatterlist.h:5,
                 from include/linux/dma-buf.h:29,
                 from drivers/gpu/drm/tegra/gem.c:16:
drivers/gpu/drm/tegra/gem.c: In function 'tegra_bo_dumb_create':
drivers/gpu/drm/tegra/gem.c:265:39: error: dereferencing pointer to incompl=
ete type
  min_pitch =3D round_up(min_pitch, tegra->pitch_align);
                                       ^
include/linux/kernel.h:62:46: note: in definition of macro '__round_mask'
 #define __round_mask(x, y) ((__typeof__(x))((y)-1))
                                              ^
drivers/gpu/drm/tegra/gem.c:265:14: note: in expansion of macro 'round_up'
  min_pitch =3D round_up(min_pitch, tegra->pitch_align);
              ^
drivers/gpu/drm/tegra/dc.c: In function 'tegra_dc_init':
drivers/gpu/drm/tegra/dc.c:1300:29: error: 'tegra' undeclared (first use in=
 this function)
  if (dc->soc->pitch_align > tegra->pitch_align)
                             ^
drivers/gpu/drm/tegra/dc.c:1300:29: note: each undeclared identifier is rep=
orted only once for each function it appears in

Caused by commit 26861f43da4e ("drm/tegra: Properly align stride for
framebuffers").

I have used the drm-tegra tree from next-20140801 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/GQ4OTh+virfOB6rSznuJe7F
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT3wmxAAoJEMDTa8Ir7ZwVeLMP/1ta9lVyiKm9RLeOzo8lTFuq
5H/uXsq7/ehVPz7K2Vf3c/udmI+enGYa80E28jLC6c480RkHhJNEtLIY5mzG94D6
HBd1jKR1fZIL/Ryojt0POokDrefCUeGqsTlUVnQjYaxSW+r7EkznBJLjCXiiQg/W
1+LJahXt93iyCR+YJW73lfN5gSJQg6SBu3riMHK/yYQdgDKeTtVKxb1ew4KQid8Q
xy7XPS+ZOLYzdSMXiwt99vyIn3Yhk1RkqvKEH1GvA08/vEhlWGTnm+QZvhrOXfbb
CLF8gld2a8EH4BR1MhcOlF9rVaMOZM57jGAIJX1Mt6nKPE/phXVBIRZsWfo+iZQD
sx/x1L/d/zzcKUFjZiz09HKM+i4MMePU0MO2Z66qOAq0lmomAd4gzfXR+ZyNc7fY
MaaHhKhDEa7gR0sl5m0KhR8pTl90/s8Pga4vUJ+csDmnrdc4uxAGq9WG/QxXBHhv
XkJI1lhIcCN68dXpGB/qoYnH+2kRICRb5QrsrmxzLbjozl77sH7jCakRfUwNzuIf
OoWG7ygjaYu40+nygpC0nEwkYDBTN8K/ftPLnDayFB9qyP/etC2yFDZopL3EIpdv
ld+VZwSKI+Wyf1pIQF4QsAG3Z5Pbd3+aTQdPR/IMSZnIs3AG0tKvyShBdT3AzS7n
0uSnIe1EXXsGLPqa3fTD
=WZXb
-----END PGP SIGNATURE-----

--Sig_/GQ4OTh+virfOB6rSznuJe7F--
