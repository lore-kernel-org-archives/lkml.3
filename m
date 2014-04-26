Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaDZOEo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 10:04:44 -0400
Received: from mout.gmx.net ([212.227.15.15]:63218 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaDZOEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 10:04:42 -0400
Date: Sat, 26 Apr 2014 16:04:29 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, chase.southwood@yahoo.com,
        unixed@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: remove duplicate pointer assignments in
 attach functions
Message-ID: <20140426160429.4883f678@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/hRNlLFw4Bw0kDlSW77xo7nY"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:ZosP8MLCruHCnTroqU6eUuuLyDQS1QdxC8zRJpe8K+JL2YQnoPE
 3RvyAKqM+pwJPfxhQXHS21IXtfV/nxQ57+kcZMgsqr4r98tok+8eFdMCnZkos2cWQrTauCs
 +IA+VKK+2fp+oYDL1p2Zmu1Ht93wVTqQZYEAK14ggRhXVk+3c41tetWN10iN/BYmuR27Co+
 PNMjzNdW8H5qdIjNSD+Fw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hRNlLFw4Bw0kDlSW77xo7nY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Some board pointer are assigned twice via comedi_board() in the comedi low
level driver attach functions. Remove the duplicate assignment from the
variable definition where the pointer is not used anyway until assigned lat=
er
in the function when dev->board_ptr, that comedi_board() relies on, is setup
correctly.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested and applies against v3.15-rc2 as well as branch staging-next
of tree git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/comedi/drivers/das1800.c     | 2 +-
 drivers/staging/comedi/drivers/das800.c      | 2 +-
 drivers/staging/comedi/drivers/dt2801.c      | 2 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/com=
edi/drivers/das1800.c
index d581029..0335a70 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -1479,7 +1479,7 @@ static int das1800_probe(struct comedi_device *dev)
 static int das1800_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
-	const struct das1800_board *thisboard =3D comedi_board(dev);
+	const struct das1800_board *thisboard;
 	struct das1800_private *devpriv;
 	struct comedi_subdevice *s;
 	unsigned int irq =3D it->options[1];
diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/come=
di/drivers/das800.c
index b23a12c..e2dc43d 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -683,7 +683,7 @@ static int das800_probe(struct comedi_device *dev)
=20
 static int das800_attach(struct comedi_device *dev, struct comedi_devconfi=
g *it)
 {
-	const struct das800_board *thisboard =3D comedi_board(dev);
+	const struct das800_board *thisboard;
 	struct das800_private *devpriv;
 	struct comedi_subdevice *s;
 	unsigned int irq =3D it->options[1];
diff --git a/drivers/staging/comedi/drivers/dt2801.c b/drivers/staging/come=
di/drivers/dt2801.c
index d4d4e4b..4263014 100644
--- a/drivers/staging/comedi/drivers/dt2801.c
+++ b/drivers/staging/comedi/drivers/dt2801.c
@@ -545,7 +545,7 @@ static int dt2801_dio_insn_config(struct comedi_device =
*dev,
 */
 static int dt2801_attach(struct comedi_device *dev, struct comedi_devconfi=
g *it)
 {
-	const struct dt2801_board *board =3D comedi_board(dev);
+	const struct dt2801_board *board;
 	struct dt2801_private *devpriv;
 	struct comedi_subdevice *s;
 	int board_code, type;
diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging=
/comedi/drivers/ni_at_a2150.c
index afbf251..fefd97e 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -695,7 +695,7 @@ static int a2150_probe(struct comedi_device *dev)
=20
 static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig=
 *it)
 {
-	const struct a2150_board *thisboard =3D comedi_board(dev);
+	const struct a2150_board *thisboard;
 	struct a2150_private *devpriv;
 	struct comedi_subdevice *s;
 	unsigned int irq =3D it->options[1];
--=20
1.9.1

--Sig_/hRNlLFw4Bw0kDlSW77xo7nY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTW7ztAAoJEKssnEpaPQKEKlMQAJ9ZgVPKg8eVyZs+tz9Su3K1
D/2Z4QU/vbU0GZEce6eb9etfmVi5Q5W2vz9D7nh0AbErxUXgHM26sYAnsC4g+7d4
6J1brhcDlj6WsJ5q4u07s0uDbV9S2UQHDA8gWT5zt+xSmKoiF2QnWqjS2GwrKELa
7j/rREt0/TpUvWNckQpS43BouL21zvqTvSOPnKPI77RQh7rbM8WOUjBVTY4Qgt+u
lz3CDjW7yk4qnTsRkCoMjjp4HLS12FwVm2B0AgKrokRgwOsP9XtvWql8K8wy4p3K
ESo6goZIiUOPoC8Cub6nBvlHFaDzoRG3ZGPc0wc+6n/Jfve7aQVPn4CUBLLpjCBq
iKdDxLcnvH3SRxnZjn+qif9EpQXfx6bXZoFUi6+SjgYrqHCD1NIj1WlCa5mSaPt9
fUB4OKe6jzdtEs3srS2YTGefLsLNgFKPjvuK9yNGnAWFWwSvBbukwRXgaxtj2cA3
ZwGQ5PdNDoZIJAnWM/3DUl60pXCKL6lh7sI9Yx+78DGngiut/iBDZhhFt1PtteU9
p9x+TelEyhaAdDz7z1ut8msrpJvz12dSr7+ICtPoP1WmsxIAFFmRZZHIRbGHBp8T
G0we7uTf3HbQjJdmTydqxVALR5DIrRHe1FNtW8ceoRkc1oQh+y/Xts4kKi3rK+hP
Jd3jZNvvOWsIrkcMEQvO
=3fzR
-----END PGP SIGNATURE-----

--Sig_/hRNlLFw4Bw0kDlSW77xo7nY--
