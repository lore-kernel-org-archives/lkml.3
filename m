Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406Ab3BRFBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:01:39 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45657 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3BRFBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:01:38 -0500
Date: Mon, 18 Feb 2013 16:01:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: linux-next: manual merge of the arm-soc tree with the input tree
Message-Id: <20130218160125.0afc414767b236bdfc6ee8df@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Feb_2013_16_01_25_+1100_Qt5lwnLLkg7+E71Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Feb_2013_16_01_25_+1100_Qt5lwnLLkg7+E71Q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/input/keyboard/tegra-kbc.c between commit 9eee07d39fa6 ("Input:
tegra-kbc - require CONFIG_OF, remove platform data") from the input tree
and commit 61fd290d213e ("ARM: tegra: migrate to new clock code") from
the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/input/keyboard/tegra-kbc.c
index d89e7d39,54ac1dc..0000000
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@@ -29,16 -29,9 +29,16 @@@
  #include <linux/of.h>
  #include <linux/clk.h>
  #include <linux/slab.h>
 -#include <linux/input/tegra_kbc.h>
 +#include <linux/input/matrix_keypad.h>
- #include <mach/clk.h>
+ #include <linux/clk/tegra.h>
 =20
 +#define KBC_MAX_GPIO	24
 +#define KBC_MAX_KPENT	8
 +
 +#define KBC_MAX_ROW	16
 +#define KBC_MAX_COL	8
 +#define KBC_MAX_KEY	(KBC_MAX_ROW * KBC_MAX_COL)
 +
  #define KBC_MAX_DEBOUNCE_CNT	0x3ffu
 =20
  /* KBC row scan time and delay for beginning the row scan. */

--Signature=_Mon__18_Feb_2013_16_01_25_+1100_Qt5lwnLLkg7+E71Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRIbWlAAoJEECxmPOUX5FEfYAP/0O5XGJ/gI98NIA90H8ENBNK
YlKd3vNumrmmhSn60plSqyobgkj5C8nMXt/+xhjJ9nxF3f810ul6v6Tn9yDlj6GJ
oaSm82PHorfgEn1uYQc10fR4W20mHRHhBjxHRJe2ivVoGel4uRkCKWE86I8fhWrX
hufgv59Xk2d0yVXqn8HFganTZmcxbUOFO4vKaBMmBeTPypAsgkoD/Y0a1iVZrGgQ
2K08YI18+h5C3Y4LeiqWY3AglyqkfqEUsNKvERSyvGZHLByPurJ9iapuqaFmXCRv
4jMGLrLqvhI2KpA9df58iUBYhRTzXOrXNr9JmH5Pig5tdeAKaMh57k2Mx+WaGbKP
l/eY0BEQ7WZwe46MmMXlI0woQxUC07a0rqgfxxEycAqLqNsxjgg9C5y+SxsNoP8Z
3bfm8yhuWPLVM5eOSPu5uN5tIJp6HN4rodqG99DL1kSZ2+klVcP4+eocoOtb46Ng
ahqpEQL6pODesdKJEU5wkJXWyIrrp6tVTJ8zbbUtyEWq0YvDZhFmnP9+309O0/XG
hJ8z6jcPbSNHswM+1IWZN3e9XBJ5XYRJ7QzYrez0Ukz8YwranC5gMU/Ewx6U1HNu
AyXDlmov5ySI8MVi2ZpF4+oKSK7yxYoU+NIssYeuNcBQpS8ppWAObqyrC+BplbnL
1xdZRSDuKO40H4Mgjf5G
=BdAx
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Feb_2013_16_01_25_+1100_Qt5lwnLLkg7+E71Q--
