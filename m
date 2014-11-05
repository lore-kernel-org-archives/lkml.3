Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaKEE3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 23:29:20 -0500
Received: from ozlabs.org ([103.22.144.67]:48032 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbaKEE3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 23:29:18 -0500
Date: Wed, 5 Nov 2014 15:29:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amber Thrall <amber.rose.thrall@gmail.com>,
        Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
Subject: linux-next: manual merge of the staging tree with the v4l-dvb tree
Message-ID: <20141105152911.69bd1a14@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/kcyJMDlk.GrKCGudnEiYIG="; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/kcyJMDlk.GrKCGudnEiYIG=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/media/lirc/lirc_imon.c between commit f3a75505ab5f
("[media] Staging: media: lirc: cleaned up packet dump in 2 files")
from the v4l-dvb tree and commit 732ba199ab07 ("staging: media: lirc:
lirc_imon.c: replace printk by dev_dbg") from the staging tree.

I fixed it up (the staging tree patch was not complete, so I did the
below) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/media/lirc/lirc_imon.c
index 232edd5b1742,f98418cd2305..000000000000
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@@ -619,8 -597,13 +596,9 @@@ static void imon_incoming_packet(struc
  		return;
  	}
 =20
 -	if (debug) {
 -		dev_info(dev, "raw packet: ");
 -		for (i =3D 0; i < len; ++i)
 -			dev_dbg(dev, "%02x ", buf[i]);
 -		dev_dbg(dev, "\n");
 -	}
 +	if (debug)
- 		dev_info(dev, "raw packet: %*ph\n", len, buf);
++		dev_dbg(dev, "raw packet: %*ph\n", len, buf);
+=20
  	/*
  	 * Translate received data to pulse and space lengths.
  	 * Received data is active low, i.e. pulses are 0 and

--Sig_/kcyJMDlk.GrKCGudnEiYIG=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUWaebAAoJEMDTa8Ir7ZwV/PQP/0A4I4l9kPeJmOaGPKFNF1xS
wtO1c3jW8a8uL1c/Y6q3PQX9T3rXt/G0O0ukVezaW1/ixSMZKPXJcSQKgPXN0g4p
MH3+wyz3pRYB3nG0g6GvDbhlsax7xKmGuLamvXCn6vR38QEYFunr7Z7ZvqSC5TCv
8HE+IlBY/NUdB9BBQz/TQLDipKsjefdiqFxFEnWSbbGONWCb3uEuEW8RYR6Os47J
Nfk/uV5ibVIg2RKU2NXrmoMFe4+kWvZJrIjCAwWavynM2NkZuFG5KuFBCLu2gOEq
qIVZn98nWRd8r1toJ2YRohqcZX0PWZRmhePKJIm4pPC/NSsF8WYEy92pldHjOkpB
9RaJps54aPXnaYJPdTu2G69BoSLarAX0lQU9zhOv67dMYGiTf2Q8HotGdhRaZntw
uK0Z/4VcKmSXD0DBNoTMRfUyqdcj9zIeq1HRK44f2h/czzUH0P/p8QLPpuZu9MtX
jqV1CHRACrsGLKEbHPpmC7UqXMZC+2Oy5ooRJYgc0NS7hoeTpOOXKviELcLW3ySC
vvIgqNeFag7bMJzn8zdex0Gk5cLgVsRw4+rbBu4RdEJxc8XC63s4Y7C+3lrbTcSO
BkBXZAEic6EwQdcpiQ4dQSFVeQdcMQi5qiAZlFq1HQRU/PADh/ZEjAeOo3p/yXWc
jk6eRs/R57c5bbwXDT0T
=J8jF
-----END PGP SIGNATURE-----

--Sig_/kcyJMDlk.GrKCGudnEiYIG=--
