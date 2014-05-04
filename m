Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaEDA01 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 20:26:27 -0400
Received: from mout.gmx.net ([212.227.17.20]:52584 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbaEDA00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 20:26:26 -0400
Date: Sun, 4 May 2014 02:26:09 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: hsweeten@visionengravers.com, abbotti@mev.co.uk,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: ii_pci20kc: fix usage of uninit scalar in
 ii20k_attach()
Message-ID: <20140504022609.7b1ba9c1@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/QN5/LXd_PcS_ohjq1hTDny="; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:Fd9/JdGfvLXsHiXsoeRh4zCnwZ9p4rubtODrgLU7aFXC+Vhb51k
 zOab3ZTLYHc3K2YZww3xUHVrn0AKoey+4NDGOJTKT4GYdCn6HSsojKzqTQeaZ7UedPBjDuy
 6pHEZX/10I7ArvWkpRypxwGulMgbaiRoxxFzGOIHueWp9QNpuyxJGorlpA0uQnvxNRaU215
 pCqqJA19Uzid5cXnmXVTw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/QN5/LXd_PcS_ohjq1hTDny=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

This driver supports the PCI-20001C-1a and PCI-20001C-2a carrier boards.
The -2a version has 32 on-board DIO channels. In case this variant is
detected, local variable 'has_dio' is set accordingly. Otherwise it is
left uninitialized and the following subdevice instantiation depends on
the stack. Detected by Coverity - CID 1077830.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/comedi/drivers/ii_pci20kc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/drivers/ii_pci20kc.c b/drivers/staging/=
comedi/drivers/ii_pci20kc.c
index 3558ab3..2516ce8 100644
--- a/drivers/staging/comedi/drivers/ii_pci20kc.c
+++ b/drivers/staging/comedi/drivers/ii_pci20kc.c
@@ -461,6 +461,7 @@ static int ii20k_attach(struct comedi_device *dev,
 	id =3D readb(devpriv->ioaddr + II20K_ID_REG);
 	switch (id & II20K_ID_MASK) {
 	case II20K_ID_PCI20001C_1A:
+		has_dio =3D false;
 		break;
 	case II20K_ID_PCI20001C_2A:
 		has_dio =3D true;
--=20
1.9.1

--Sig_/QN5/LXd_PcS_ohjq1hTDny=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTZYkhAAoJEKssnEpaPQKEdJgP/0dmDajPrHKo8GEUDls8Xey5
N77nbdtpDt33tmWcuKdklmn26ei7hAxYLzM3ykhoNCkD+Jq8yXoG7Gm1iHNxHD/M
D+j24Fpe/BTbW98O7s8c7bNfoWc4LiH/subaMZsP00LojBMj1SQcZAWx2V3lmkGF
Whr/v74A73e0tomHpvdcfBuBAsEobnFOdG5XAImKrG3/Ag8f3lq2QNNMllSbIiYm
dLNqPyMkeU/g74Mo0kUnlpP8ufDR7Pq59aY6qeUAR/2XPzWpaTLdEeMCU6Hfl476
c+g8Mf8xqoMRc+M8bOqNdfeLf6i892V7m5y+KWWgD78Q8fsSOW6rRU4/rFGLO35S
auiP2LEmZ0+TCkLf47JPFSEnvZQzTYrwuM+0Y6BpJnjlieItUc5bW4u4KHw2v63v
0mRgx93wPKWd1cNozDWZzY0eKvlZxiFWy+GfHlB8jVk0pbX8Mc2maNdax2kkg4y3
g2dxJ5DNgnpVb90Z3xnzjRypuq55+hTDewUs9Y0CoUWdN8MUg1YhXCG/3D65AP5r
4j+Xs9itw/1jyBmXfskRv2lwlqoeTw7qKslqrxefiHzBFQQaZ4VPpkaxv6n/37w5
yKN9+4u/dBabxJTQf6stkRnXBbunfUlIwsn0YcjVBRlZfM9E13yhItkZYo6yxlWw
23SMFAE2d9r3s/4CltBm
=vcUW
-----END PGP SIGNATURE-----

--Sig_/QN5/LXd_PcS_ohjq1hTDny=--
