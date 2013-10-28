Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab3J1OMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:12:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44248 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab3J1OMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:12:36 -0400
Date: Tue, 29 Oct 2013 01:12:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: linux-next: build failure after merge of the final tree (gpio tree
 related)
Message-Id: <20131029011223.58b51e529acced32d6dae82a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Oct_2013_01_12_23_+1100_sUeUiK0B.aBzesoh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Oct_2013_01_12_23_+1100_sUeUiK0B.aBzesoh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

In file included from include/asm-generic/gpio.h:13:0,
                 from include/linux/gpio.h:51,
                 from include/linux/of_gpio.h:20,
                 from arch/powerpc/sysdev/ppc4xx_gpio.c:29:
include/linux/gpio/driver.h:85:14: error: 'struct seq_file' declared inside=
 parameter list [-Werror]
include/linux/gpio/driver.h:85:14: error: its scope is only this definition=
 or declaration, which is probably not what you want [-Werror]

Caused by commit 79a9becda894 ("gpiolib: export descriptor-based GPIO
interface") from the gpio tree.

I have applied this fix up patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 29 Oct 2013 01:06:23 +1100
Subject: [PATCH] gpiolib: provide a declaration of seq_file in gpio/driver.h

Fixes this build error:

In file included from include/asm-generic/gpio.h:13:0,
                 from include/linux/gpio.h:51,
                 from include/linux/of_gpio.h:20,
                 from arch/powerpc/sysdev/ppc4xx_gpio.c:29:
include/linux/gpio/driver.h:85:14: error: 'struct seq_file' declared inside=
 parameter list [-Werror]
include/linux/gpio/driver.h:85:14: error: its scope is only this definition=
 or declaration, which is probably not what you want [-Werror]

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/gpio/driver.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index cd9da3885d79..656a27efb2c8 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -5,6 +5,7 @@
=20
 struct device;
 struct gpio_desc;
+struct seq_file;
=20
 /**
  * struct gpio_chip - abstract a GPIO controller
--=20
1.8.4.rc3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__29_Oct_2013_01_12_23_+1100_sUeUiK0B.aBzesoh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSbnDOAAoJEMDTa8Ir7ZwVO1MQAIV7oeJkUNoJKppfFAIHxtB7
iy7upH9LxUyutAV0ZD4yUODh6H2X4ZA3XAikADps3PkCh3MYi0htaBrmhKiJ4Lkh
jP2lvYMEkGbjTh/84uSRWsfU9rhe5IlZfJe5SaWwVX9nZsE2PKQ0MKdCNpnT8mQr
De0HIC1wyA33WgJe5yU+K5gfeo+3trbBQurEi4IzSFrlWvuK7z32y3bnaO2HLa0z
1YOgrrv5YrKGQo0OYaPD++9VuEF59gkfj2sc4/Xw6w3H8Fx4dAKTjHqzCK/qREPT
+8bxkIxhJsNkZmzRAjQHtnf1NLoSQtBnzYK91gcxmYLJGgPh7U/LIe/WXDEVXT2R
zZJXHgQuqE9dfrcVxrDFgSjY089+2/t2tetHaasCvlWvUGDDbgolB/d0b8Uc2aEu
tGaBJb2PkM6t6kH+juKQ+MR8ZWpFSMS3RPdsBmwh/7LLQsbIGtNj3WnYPyrHJOcs
QEk0D2ZvgHG0nzyMfMtnLZ/6DNfobz1d6nPdh7LdXbGB/OuMKUpHC+/sKuB0+HGj
F1Zm4ia5tpTZJ9MPvbDBUer38NkY1yDgZ3RT+BPpiMaywh96udrD0EytyMt0gVNj
7SXx8ZNLXDysDT2DNRBe5yf79QM3EXOZG5pFT+Z8fhGYeqynWzojl3HRA6OkPxY5
bQUHqJ92ymrWQ156U+71
=oj3X
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Oct_2013_01_12_23_+1100_sUeUiK0B.aBzesoh--
