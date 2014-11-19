Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbaKSDEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:04:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747AbaKSDE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:04:29 -0500
Date: Wed, 19 Nov 2014 14:04:20 +1100
From: NeilBrown <neilb@suse.de>
To: greg kh <gregkh@linuxfoundation.org>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
        GTA04 owners <gta04-owner@goldelico.com>
Subject: [PATCH] w1: support auto-load of w1_bq27000 module.
Message-ID: <20141119140420.304db886@notabene.brown>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/t_M9F/QC/zFcGNKW8wvu3rR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/t_M9F/QC/zFcGNKW8wvu3rR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



1/ change request_module call to zero-pad single digit
   family numbers.  This appears to be the intention of
   the code, but not what it actually does.

   This means that the alias created for W1_FAMILY_SMEM_01
   might actually be useful.

2/ Define a family name for the BQ27000 battery charge monitor.
   Unfortunately this is the same number as W1_FAMILY_SMEM_01
   so if both a compiled on a system, one module might need to
   be blacklisted.

3/ Add a MODULE_ALIAS for the bq27000.

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: NeilBrown <neilb@suse.de>

---
Hi Greg,
 appreciate it if you could queue this up for whenever.

Thanks,
NeilBrown


diff --git a/drivers/w1/slaves/w1_bq27000.c b/drivers/w1/slaves/w1_bq27000.c
index afbefed5f2c9..caafb1722783 100644
--- a/drivers/w1/slaves/w1_bq27000.c
+++ b/drivers/w1/slaves/w1_bq27000.c
@@ -88,7 +88,7 @@ static struct w1_family_ops w1_bq27000_fops =3D {
 };
=20
 static struct w1_family w1_bq27000_family =3D {
-	.fid =3D 1,
+	.fid =3D W1_FAMILY_BQ27000,
 	.fops =3D &w1_bq27000_fops,
 };
=20
@@ -111,7 +111,7 @@ module_exit(w1_bq27000_exit);
=20
 module_param(F_ID, int, S_IRUSR);
 MODULE_PARM_DESC(F_ID, "1-wire slave FID for BQ device");
-
+MODULE_ALIAS("w1-family-" __stringify(W1_FAMILY_BQ27000));
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Texas Instruments Ltd");
 MODULE_DESCRIPTION("HDQ/1-wire slave driver bq27000 battery monitor chip");
diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 592f7edc671e..181f41cb960b 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -727,7 +727,7 @@ int w1_attach_slave_device(struct w1_master *dev, struc=
t w1_reg_num *rn)
=20
 	/* slave modules need to be loaded in a context with unlocked mutex */
 	mutex_unlock(&dev->mutex);
-	request_module("w1-family-0x%0x", rn->family);
+	request_module("w1-family-0x%02x", rn->family);
 	mutex_lock(&dev->mutex);
=20
 	spin_lock(&w1_flock);
diff --git a/drivers/w1/w1_family.h b/drivers/w1/w1_family.h
index 0d18365b61ad..ed5dcb80a1f7 100644
--- a/drivers/w1/w1_family.h
+++ b/drivers/w1/w1_family.h
@@ -27,6 +27,7 @@
 #include <linux/atomic.h>
=20
 #define W1_FAMILY_DEFAULT	0
+#define W1_FAMILY_BQ27000	0x01
 #define W1_FAMILY_SMEM_01	0x01
 #define W1_FAMILY_SMEM_81	0x81
 #define W1_THERM_DS18S20 	0x10

--Sig_/t_M9F/QC/zFcGNKW8wvu3rR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVGwItDnsnt1WYoG5AQKmLBAAlCEW/4bl4MrNVD/bX/9wCeSygx9JVBym
3L8FMZiQNelNcwqjCcsceIvYRjzsbqlZNyn1jAymcrbM3R2m7gLNqYRFYseRYlma
Vew9PXB1XV+sLrEIOssZPF7plpre5hdxeUJ2VKiZ8UVkHi37UBRKymBEbizPRSfT
me/uY0lOgxXKzIIp3OTlcqU8h4ks8ohnyr5pX9FCT/aLXFvQ8MH/IHFNTO8L0EVW
l/43nktm1uWHia8pVl1AYYdKGx++M5Y8xGn31Xq6V5AzFlerPoMcj+vYC7wmaz5q
n2tEmzVc67TOw3lFQMM1EVJTd2Y9sdMid/iBbVmoREvv2TCECmq1N0KabFsYUBhl
VrWXrne6gwq148Er/Eq3i8Qfb+tp2O2Z/rQuOr45nCk2CGeddC8TlNJD2fGAd2wD
x09PdVgwHNjWLpjOYGpzLbcXZhChgi3kdFtskMwBT5XQHTcz6lAmBnciGO2IcXdp
qSTLHA9j9pzNzb/3ihrWECIp72lMOp5ImjSUXEZ1r61pdfnJ5pqjyW0fTVFTjAv0
XV2AIsUlsCDWpjRLD8eAiCgdNTYqsrWsm+ZKPPQ3vUYfB5H2ySFuS87/969Vk3Pq
rG8Ozw0muxcHlCSFnQE5a9oBwUSrFaqkGtbKCjoMNzRvhshfJExbQSOFlxZLllLa
K8l/RaSWaN8=
=NtfF
-----END PGP SIGNATURE-----

--Sig_/t_M9F/QC/zFcGNKW8wvu3rR--
