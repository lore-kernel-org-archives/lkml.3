Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3AWEMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 23:12:34 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48557 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab3AWEMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 23:12:33 -0500
Date: Wed, 23 Jan 2013 15:12:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>
Subject: linux-next: build failure after merge of the leds tree
Message-Id: <20130123151223.01bb155bb06a2e30446900c2@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Jan_2013_15_12_23_+1100_F5XXZChprYLv6vsv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jan_2013_15_12_23_+1100_F5XXZChprYLv6vsv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bryan,

After merging the leds tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/built-in.o: In function `lp55xx_unregister_leds':
(.text+0x161dab): undefined reference to `led_classdev_unregister'

Caused by commit 14732b162d34 ("leds-lp55xx: use lp55xx_unregister_leds()").

drivers/built-in.o: In function `lp55xx_init_led':
leds-lp55xx-common.c:(.text+0x161f23): undefined reference to `led_classdev=
_register'
leds-lp55xx-common.c:(.text+0x161f9f): undefined reference to `led_classdev=
_unregister'

Caused by commit b5370ff365fa ("eds-lp55xx: use lp55xx_init_led() common fu=
nction").

drivers/built-in.o: In function `lp55xx_read':
(.text+0x1621b3): undefined reference to `i2c_smbus_read_byte_data'
drivers/built-in.o: In function `lp55xx_init_device':
(.text+0x1622f0): undefined reference to `i2c_smbus_write_byte_data'
drivers/built-in.o: In function `lp55xx_init_device':
(.text+0x162331): undefined reference to `i2c_smbus_write_byte_data'
drivers/built-in.o: In function `lp55xx_update_bits':
(.text+0x162492): undefined reference to `i2c_smbus_write_byte_data'
drivers/built-in.o: In function `lp55xx_write':
(.text+0x1624c5): undefined reference to `i2c_smbus_write_byte_data'

Caused by commit 597eb710be87 ("leds-lp55xx: add new common driver for
lp5521/5523").

I have used the leds tree from next-20130122 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__23_Jan_2013_15_12_23_+1100_F5XXZChprYLv6vsv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/2MnAAoJEECxmPOUX5FEC98P/0pNiYd4nn0d7wNi76fLNDj0
TcB/Bc4FgNXkrbWcj+0Wty7F9QDhvuzj78We9AQ7JCjDoxYhYi6fISS78FD/o1rW
uf51HkUl+ZX1U7aQTkQDDNP5mKxp/4D6miMA+HiR/n4nJazpNLbCaCAh1/j7BXz0
FDuzQ1z5sDoJnNIqTiHerBeOeA3yYeV0Ys7NZAH5JQrlySBqCBKmJlggu9dmII1B
REm2vmkd8SLdlkf0VlOnndlDtMX5U8lU4LFTqkTHRTDp7SjSguD72/aI9bzyeUwk
biD5W8GXiF7YuTVqtxG9ZbM98yDXSTGKLBUc5y5+tfRX/R+CoxIh8Ek5ZzE3FTm8
SyPPDfiNWq4AYQw6cgKSPiVz08c7jDRxRlrCwT4h1tD15OMikCFdMV1gRX6fh+Gd
Z9gmMB/xc70YSeX77YSv/L6xXSD42p0t//Y0Ng2JVhKRx09ceU8gnTIXvk9i6xrx
6asfZdT0UPG7CuJn94mnxlj1I7akmbBdiMaWYmSepZoAQJUee0Y9rELpUs0RLEsL
QrEOpeWHNGUYkipReB5lUl1AZHUuvcuBEGTLcxYaaPFRG7cHKPFqz86XPnssvmjo
xTer0nHmXfWglPqmOkX/vT9XMQZNwdfzefsTIfYkmWYJaGJeubhJNcqMCADHDdXZ
hG10IrRv79SzB+mbs7XF
=zNGl
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jan_2013_15_12_23_+1100_F5XXZChprYLv6vsv--
