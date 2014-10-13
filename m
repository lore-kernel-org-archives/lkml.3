Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaJMCrH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:47:07 -0400
Received: from ozlabs.org ([103.22.144.67]:35688 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881AbaJMCrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:47:03 -0400
Date: Mon, 13 Oct 2014 13:46:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bryan Wu <cooloney@gmail.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiubo Li <Li.Xiubo@freescale.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: linux-next: manual merge of the leds tree with the pm tree
Message-ID: <20141013134655.2407e8c5@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/LDtErMbhm8MvBZgUv4lLyOp"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/LDtErMbhm8MvBZgUv4lLyOp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Bryan,

Today's linux-next merge of the leds tree got a conflict in
drivers/leds/leds-gpio.c between commits 8b0d4dc3d449 ("leds:
leds-gpio: Add support for GPIO descriptors") and c108837ca096 ("leds:
leds-gpio: Make use of device property API") from the pm tree and
commits 4cc72346f05e ("led: gpio: Sort include headers alphabetically")
and a4c84e6aafda ("leds: gpio: cleanup the leds-gpio driver") from the
leds tree.

I fixed it up (see below - sorry I put one of the include in the wrong
place :-() and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/leds/leds-gpio.c
index 112c2a11c46d,b4518c8751c8..000000000000
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@@ -10,16 -10,17 +10,16 @@@
   * published by the Free Software Foundation.
   *
   */
- #include <linux/kernel.h>
- #include <linux/platform_device.h>
+ #include <linux/err.h>
  #include <linux/gpio.h>
- #include <linux/gpio/consumer.h>
+ #include <linux/kernel.h>
  #include <linux/leds.h>
- #include <linux/slab.h>
- #include <linux/workqueue.h>
  #include <linux/module.h>
- #include <linux/err.h>
 -#include <linux/of.h>
 -#include <linux/of_gpio.h>
 -#include <linux/of_platform.h>
++#include <linux/gpio/consumer.h>
+ #include <linux/platform_device.h>
 +#include <linux/property.h>
+ #include <linux/slab.h>
+ #include <linux/workqueue.h>
 =20
  struct gpio_led_data {
  	struct led_classdev cdev;

--Sig_/LDtErMbhm8MvBZgUv4lLyOp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUOz0jAAoJEMDTa8Ir7ZwVtosP/3fO010El1KQzDU2XukP+zZd
ZTtTwMWO8aytnwKeyJ113CS97Er9zkc/c1i4QLZK5MUhicJA6Sike7CiDFgVh1Mb
JBCkVtDJ+BBjnCf0cXhlbQwIJXZBQyhWFZwqxA3oyxucDqiKctGc2qDmAyBuf9lc
N4QfqVDZboy8oKB4/Vh6wWlA1wLgmh6TEb23BCcl2OrEkrEF84MveGp+felgDXi6
WhPPmBIc80nKYSqay8gxQi1Nr+2uu74taCjqD24e4Nh2RtoVX7BG9E+d7A7RRBlB
pb4t4qqD1TMbOVTmlpMcA9TZxS/YGVvor+/CBIHl0hEtX9gq10hGFgVNOpwcO6UM
7zd7/NqOxjY8UEJe5Is8FBus4S1w3GBj74JbDIxdMTsouFVOUoJ0Y8q+zVytm/IC
LFMUFLAI9H7tX8j2XdtWYJFkh4C8K3lGds9AXY1rNnFJ+lOJpS0uRRO7zJlyYsvH
Kzi3aGmxnTWCwTojzMBk3+9eJ9gt23uc/ElI0/vFf1ggMKG0Fdi0woa1n0xGa//l
K54MUqhQk7a2Wa4IdxlLiDOggQoZqdkOlMxWjd8RjMGQnpJNaTEtF5l4G+LP5u7s
9YEGqbIq2lgMjKcrxWSFyekr1hx5jBONIC0zwmry+Ql8k+qO3xz0LdcmBIZxGcH3
zxxbwdybt/zMzGa9TsEZ
=9K0h
-----END PGP SIGNATURE-----

--Sig_/LDtErMbhm8MvBZgUv4lLyOp--
