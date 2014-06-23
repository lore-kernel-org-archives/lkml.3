Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264AbaFWEdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 00:33:15 -0400
Received: from ozlabs.org ([103.22.144.67]:51069 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaFWEdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 00:33:14 -0400
Date: Mon, 23 Jun 2014 14:33:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Levente Kurusa <levex@linux.com>
Subject: linux-next: manual merge of the akpm tree with the char-misc tree
Message-ID: <20140623143304.79917bfa@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/V3aXV9NSoR2GCvlIGzg/WSM"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/V3aXV9NSoR2GCvlIGzg/WSM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/w1/w1_int.c between commit fdc9167a7853 ("w1: use pr_* instead
of printk") from the char-misc tree and commit "drivers/w1/w1_int.c:
call put_device if device_register fails" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/w1/w1_int.c
index 47249a30eae3,ec3fc9335f0d..000000000000
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@@ -90,10 -91,9 +90,9 @@@ static struct w1_master *w1_alloc_dev(u
 =20
  	err =3D device_register(&dev->dev);
  	if (err) {
 -		printk(KERN_ERR "Failed to register master device. err=3D%d\n", err);
 +		pr_err("Failed to register master device. err=3D%d\n", err);
- 		memset(dev, 0, sizeof(struct w1_master));
- 		kfree(dev);
- 		dev =3D NULL;
+ 		put_device(&dev->dev);
+ 		return NULL;
  	}
 =20
  	return dev;

--Sig_/V3aXV9NSoR2GCvlIGzg/WSM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTp64HAAoJEMDTa8Ir7ZwVgy4P/1qoOZZA9b8ieU8q7VXMG5gL
cCis0pW5+m5SPRQ5QKW/e2xwMMgNWwPA6Pdk3fPxL2y1Gh+1sa28O32B767yau/5
FWk1tgsJ1WmgZzAoFlfcCbexTZczDFB1IQwm79mGfuqDzZ+OT+8ckY9kC+30yyiA
lv/JPjIAtIjP3URsfpXN7WyEqWtLnPa5c9vQTEeuoubOfet4eJDhbJq/FDSuKNOM
Qo4+kam46PAyPGHm2olYiuiBKthjH3JW0ukrxT7f7M7Lm6Nf9/YSzUxWMt7rFAuz
yY5A8gyL97nQG6WeXBhw/Nqzfkl2nn2JbnVgeBGWKmy7C16oAhVI7zvUm53WXLvN
Q2m7LrE7i9ubQod8sU+y1hsMSUyEKsXBh37bELq8MA82SmrOkYLp/t5SNOKcNP9s
5B1f3zRYH9mWqiveG7o9I5vW3IfDysx7mYOUctJIYL3H8rkun2PqsmGXKqtSDlLp
yE4HLJB7NWmcMuxOyjMUQNOvnztyXpT7hlkHOWljB65r+mey/ebg1jnttlbkcjxR
ifbzj942BvueIBCenufk8EJ2qV9xRiXDdy6XLyYULkfYTLNFtgWMeYz8fkyYck3i
pa5t5IiHK9nnRjofE8XXv44Ya22AOCfy5DGcocd/9bWv+XUmvsV7tKs4EDmabmm6
XoY5XmsLxAQEjR0+WU40
=l3kP
-----END PGP SIGNATURE-----

--Sig_/V3aXV9NSoR2GCvlIGzg/WSM--
