Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab3IAWyL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 18:54:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60319 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754761Ab3IAWyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 18:54:10 -0400
Message-ID: <1378076037.25743.54.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH] hwrng: via-rng: Add MODULE_DEVICE_TABLE
From: Ben Hutchings <ben@decadent.org.uk>
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Sun, 01 Sep 2013 23:53:57 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-VzaWfbhyiV2/Mj60VVTS"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VzaWfbhyiV2/Mj60VVTS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

via-rng currently isn't auto-loaded if built as a module.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
Compile-tested only.

Ben.

 drivers/char/hw_random/via-rng.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-=
rng.c
index d0387a8..e737772 100644
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -29,6 +29,7 @@
 #include <linux/kernel.h>
 #include <linux/hw_random.h>
 #include <linux/delay.h>
+#include <asm/cpu_device_id.h>
 #include <asm/io.h>
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
@@ -220,5 +221,11 @@ static void __exit mod_exit(void)
 module_init(mod_init);
 module_exit(mod_exit);
=20
+static struct x86_cpu_id via_rng_cpu_id[] =3D {
+	X86_FEATURE_MATCH(X86_FEATURE_XSTORE),
+	{}
+};
+
 MODULE_DESCRIPTION("H/W RNG driver for VIA CPU with PadLock");
 MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(x86cpu, via_rng_cpu_id);


--=-VzaWfbhyiV2/Mj60VVTS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUiPFhee/yOyVhhEJAQrwnBAAjx5xX5xj6n8IIDL+o8ENcCBxNDKX6oHC
Orm5jlxft/CDlKSRkbFQmxbpOCJ/EOoLpXLeuure1aAVwBYsmUkkxkKVBPLNQLdr
SvfdYmL6AtyjrPqAxkYUgk+XxF89n1qDU4C8bZMPA0kMgUDzpQ6u0Hc8Y79PpBHX
3BK8P35aYGp7LHZvVekVrH/QSH8d/aG82p6nnE8DtrfEodFsGmoNnuXVQ5yDIkLN
S5oxtWF8UJAqp225talyXCEaVs+0ikmJTptCaehZQCgBm+SWT/Ah7UmigCw41XBK
AM2GvVmb9Z6c/uXbl76NlyGelBLBx9nielqM8mUyTH3Uab81ITlIpIjdEp/TB9V2
Iy7dzuAcAPzZKNCKk4xBPZUSNBfZQ/wsyFAqjHYtXT4ejMfMS6TtgqgaN8PuI5Ay
7X/jmYwGjtR8iYztaRUaJOd+y1AhyODi2j4YXbWxp7Tz0YAuTZcbBkaKM3dS/Ko+
9pL9sxQ+0we7jkOJ5U6OgDcoxSlgtMGkt5vQmJyABaT8xkUDiurAfl7nHO/5IgjH
iiWKWAddlz8PbOO1cIctD1LWTb4fwobmwIiIvYRI+VBmxwuWUMG6a7cLTISTFLgb
QKUnWtsDrWhBvdDhVErlm88ElA+N6tvbwdRF3dqOgPVvd8R1oe88q9F3Jq4CUiPQ
z23vfRS8w+w=
=iFNU
-----END PGP SIGNATURE-----

--=-VzaWfbhyiV2/Mj60VVTS--
