Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab3J2JKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:10:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44659 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab3J2JKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:10:33 -0400
Date: Tue, 29 Oct 2013 20:10:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: linux-next: build failure after merge of the final tree (gpio tree
 related)
Message-Id: <20131029201013.cc93b7f5eca956bf6ff04e68@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Oct_2013_20_10_13_+1100_A+n2vQ00.otZShiP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Oct_2013_20_10_13_+1100_A+n2vQ00.otZShiP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
failed like this:

In file included from drivers/spi/spi.c:33:0:
include/linux/of_gpio.h: In function 'of_get_named_gpio_flags':
include/linux/of_gpio.h:93:3: error: implicit declaration of function 'desc=
_to_gpio' [-Werror=3Dimplicit-function-declaration]

Caused by commit af8b6375a829 ("gpiolib: port of_ functions to use
gpiod") from the gpio tree.

I have applied the following patch for today (it should go into the gpio
tree if it is considered correct):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 29 Oct 2013 20:05:12 +1100
Subject: [PATCH] gpiolib: include gpio/consumer.h in of_gpio.h for
 desc_to_gpio()

Fixes this build error on sparc:

In file included from drivers/spi/spi.c:33:0:
include/linux/of_gpio.h: In function 'of_get_named_gpio_flags':
include/linux/of_gpio.h:93:3: error: implicit declaration of function 'desc=
_to_gpio' [-Werror=3Dimplicit-function-declaration]

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/of_gpio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index d71f2cc141ae..f14123a5a9df 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -19,9 +19,9 @@
 #include <linux/errno.h>
 #include <linux/gpio.h>
 #include <linux/of.h>
+#include <linux/gpio/consumer.h>
=20
 struct device_node;
-struct gpio_desc;
=20
 /*
  * This is Linux-specific flags. By default controllers' and Linux' mapping
--=20
1.8.4.rc3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__29_Oct_2013_20_10_13_+1100_A+n2vQ00.otZShiP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSb3t6AAoJEMDTa8Ir7ZwVk+EP/RjA6TBts6xcve05dI8XNBk5
/3IrQk2KeClJTczJJJbJ5kNQ1/VYuW8Pk1rvqWFRAJ3CYH7wKGXAIwvQ+8y1nzag
W6uZJE1uJNGbjRl/cugkVfPdmWG0R5UGMd36LXS3jjuyy+LkUo6GRXcnXDe6nab1
1h0nZBT7NN3qtQ3YtFFdT+zkwozYTCIt3LR6BSbZj3S75tdpMECUPd/oQ84ALM+D
vxUYfTIW4VOYq559p1U7UQlLsKoUGEyT0AjhdOQ5lJ7rk9yy0JMmuJ+krqWmBpiB
0rAaEtCzawinv5vl1PtnoNAihLELberV/s4KmN97zDjBftu6EmCgy5kqP7NHsOsP
5UhGYL0FFCTvIyxHoxmOJqBqeJVtrob0VoyquKoOEryIGIuNwL8hnMpCb7AlVGZc
mEjFAbGrYijblvwoMhWlp6ded6nzNwbmFe4edb7YWpD8iVblznakeGSR8FU9JiJl
IsLRfLnumT/onq1hFp5mSyasgO9jTh3XoNAL7iotlwyRoUh/ZNAfgYMM1JvusdOH
bu5j7oDsWYmmht/luOECpAUGFcesOSYv2usBvp15w1yt4yTCcNR109PVIQzUs3F/
ADRx3VhvPKna+zJZXsEPGE+qQAxORW+l4ZBPh9+sgEM62KY1onwuLwVuc78wE6hq
YqnbQGjFw5wLVfOYw5lm
=2vcx
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Oct_2013_20_10_13_+1100_A+n2vQ00.otZShiP--
