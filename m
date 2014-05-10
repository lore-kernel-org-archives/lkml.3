Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbaEJMCZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 08:02:25 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48361 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411AbaEJMCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 08:02:23 -0400
Message-ID: <536E1543.3090107@aurabindo.in>
Date: Sat, 10 May 2014 17:32:11 +0530
From: Jay Aurabind <mail@aurabindo.in>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Trivial Monkey <trivial@rustcorp.com.au>
Subject: [PATCH] mfd: abx500-core: Fix compiler warning larger stack frame
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jdjHPS7Ci9wsCSTffEkMcLwTNITK1cN5w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jdjHPS7Ci9wsCSTffEkMcLwTNITK1cN5w
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

=46rom 95f6ac368dbe352af0dfa2097b7d58b416447be5 Mon Sep 17 00:00:00 2001
From: Aurabindo J <mail@aurabindo.in>
Date: Sat, 10 May 2014 15:16:58 +0530
Subject: [PATCH] mfd: abx500-core: Fix compiler warning larger stack fram=
e

On systems with CONFIG_FRAME_WARN=3D1024, compiler warns the allocation o=
f
an object of struct device on stack. Make the allocation dynamically to
fix the warning.

drivers/mfd/abx500-core.c: In function =91abx500_dump_all_banks=92:
drivers/mfd/abx500-core.c:167:1: warning: the frame size of 1032 bytes
is larger than 1024 bytes [-Wframe-larger-than=3D]

Signed-off-by: Aurabindo J <mail@aurabindo.in>
---
 drivers/mfd/abx500-core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/abx500-core.c b/drivers/mfd/abx500-core.c
index f3a15aa..87d80c3 100644
--- a/drivers/mfd/abx500-core.c
+++ b/drivers/mfd/abx500-core.c
@@ -154,16 +154,19 @@ EXPORT_SYMBOL(abx500_startup_irq_enabled);
 void abx500_dump_all_banks(void)
 {
 	struct abx500_ops *ops;
-	struct device dummy_child =3D {NULL};
+	struct device *dummy_child;
 	struct abx500_device_entry *dev_entry;

+	dummy_child =3D kzalloc(sizeof(struct device), GFP_KERNEL);
+
 	list_for_each_entry(dev_entry, &abx500_list, list) {
-		dummy_child.parent =3D dev_entry->dev;
+		dummy_child->parent =3D dev_entry->dev;
 		ops =3D &dev_entry->ops;

 		if ((ops !=3D NULL) && (ops->dump_all_banks !=3D NULL))
-			ops->dump_all_banks(&dummy_child);
+			ops->dump_all_banks(dummy_child);
 	}
+	kfree(dummy_child);
 }
 EXPORT_SYMBOL(abx500_dump_all_banks);

--=20
1.9.1




--jdjHPS7Ci9wsCSTffEkMcLwTNITK1cN5w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlNuFUkACgkQq5pl9aLRKAVdVwD/Vhxtly0IebSlpvb9HZDc15AO
/hn+ci8dOTXvn6N5vRQA/AzrHQwy9oNbb1zJTHzC4wWd+KdXIUjOCWbrdH6oYXh1
=aIXK
-----END PGP SIGNATURE-----

--jdjHPS7Ci9wsCSTffEkMcLwTNITK1cN5w--
