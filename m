Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaKFEzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:55:01 -0500
Received: from ozlabs.org ([103.22.144.67]:51907 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbaKFEy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:54:58 -0500
Date: Thu, 6 Nov 2014 15:54:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tapasweni Pathak <tapaswenipathak@gmail.com>,
        Amber Thrall <amber.rose.thrall@gmail.com>
Subject: linux-next: manual merge of the y2038 tree with the v4l-dvb tree
Message-ID: <20141106155450.002a6b2b@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ZvCwrgtVVp_.YiJOOXGuEwM"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ZvCwrgtVVp_.YiJOOXGuEwM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the y2038 tree got a conflict in
drivers/staging/media/lirc/lirc_sasem.c between commit f3a75505ab5f
("[media] Staging: media: lirc: cleaned up packet dump in 2 files")
from the v4l-dvb tree and commit db77d73bffbc ("staging: media: lirc:
Replace timeval with ktime_t in lirc_sasem.c") from the y2038 tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/media/lirc/lirc_sasem.c
index 196f2a7f5bb3,dfd5668656e2..000000000000
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@@ -571,8 -572,9 +572,8 @@@ static void incoming_packet(struct sase
  {
  	int len =3D urb->actual_length;
  	unsigned char *buf =3D urb->transfer_buffer;
- 	long ms;
- 	struct timeval tv;
+ 	u64 ns;
+ 	ktime_t kt;
 -	int i;
 =20
  	if (len !=3D 8) {
  		dev_warn(&context->dev->dev,

--Sig_/ZvCwrgtVVp_.YiJOOXGuEwM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUWv8eAAoJEMDTa8Ir7ZwVHzYP/3dEfzojyBRzrrcZ3LRwDkYy
Oxa8MhCkLto3URp6vPvr7sZ3JRcnG2a/A/OT5LoJq3y6oojrLrXEqi6HPOtwjzyv
gE3V3DLu5NSJJ5h+v1Kd2cSa+8wT2CtycmwzIBLrQ9IpD37daUunxHEmsv6LdqkQ
ObSM8Cx8D6uc1ZnbEOGQo81fLERfqNYFpTWL6xAO0TtVJBi71v8B+mUio6nvlVro
xE61+qwxfdPdp8hBL6p5/dsSMANNhmdEo6g58uFPGOiOPDfCgDa6rLmmBoeHpSLJ
6tUVtPikTQeDXizCpZjFqTCRmhcQDvWvzJ+sm/I201B0jGELJo8C/I+RrlrLmVMu
aQd7ECyU3YIPKk02ydsgYWNn1HoLMkZarwe7WOBeyC7rhMaiRy2G3sXQi68PYf9L
h98L+2DizxSQzX+LywRLkMYNAASrqwi3xfD5na8PFh1s7xWKCUDGJ86elnl0JFyI
2Neavadcq0tGf1xMdpkP1zofaXH2bWKtGg5h4it7rgabmOn2Uetz1PKPjZ0GRakN
Bgg7H9bJTjSiYdcXQDs2TEKiEr0yLuggjpkHJQ80dSEvh1tJHiEK3fVbz0zZhMIR
YXZ2fLAZ6TCsgodOg6he7X5NhM83vIooBp6Wftj2ImOVjJcK9D5pTwBUywCMSfLj
wAdMgnm0XR40WlJo/Mow
=H1/Q
-----END PGP SIGNATURE-----

--Sig_/ZvCwrgtVVp_.YiJOOXGuEwM--
