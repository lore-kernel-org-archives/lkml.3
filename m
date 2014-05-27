Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaE0Gxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 02:53:47 -0400
Received: from ozlabs.org ([103.22.144.67]:55071 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbaE0Gxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 02:53:45 -0400
Date: Tue, 27 May 2014 16:53:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Finn Thain <fthain@telegraphics.com.au>, Rob Herring <robh@kernel.org>
Subject: linux-next: manual merge of the tty tree with the m68k tree
Message-ID: <20140527165337.5c7d4fa4@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/7BpmMSANPORTr6BvVQpx_f3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7BpmMSANPORTr6BvVQpx_f3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
Documentation/kernel-parameters.txt between commit d5ebf7cc86a7 ("m68k:
Multi-platform EARLY_PRINTK") from the m68k tree and commit
0d3c673e7881 ("tty/serial: pl011: add generic earlycon support") from
the tty tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).  Thanks Geert for the heads up.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/kernel-parameters.txt
index 73368ca1339c,4946d8e58d53..000000000000
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@@ -910,7 -893,15 +911,15 @@@ bytes respectively. Such letter suffixe
  			(mmio) or 32-bit (mmio32).
  			The options are the same as for ttyS, above.
 =20
+ 		pl011,<addr>
+ 			Start an early, polled-mode console on a pl011 serial
+ 			port at the specified address. The pl011 serial port
+ 			must already be setup and configured. Options are not
+ 			yet supported.
+=20
+ 		smh	Use ARM semihosting calls for early console.
+=20
 -	earlyprintk=3D	[X86,SH,BLACKFIN,ARM]
 +	earlyprintk=3D	[X86,SH,BLACKFIN,ARM,M68k]
  			earlyprintk=3Dvga
  			earlyprintk=3Defi
  			earlyprintk=3Dxen

--Sig_/7BpmMSANPORTr6BvVQpx_f3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJThDZ1AAoJEMDTa8Ir7ZwVeiYP/i1ysWXmRzJGfteasnyhaDap
mJRZQTL7j8EGbx7Ii2Wj3Ta98wAmnEqNAjDquL0tt4bdoGnWjB+yEKdwO6xWnuYd
QZbAEX73cn4nEJUTiLFH1nQQJ3YekmDhNEdQf4I8tsV35eypMOPn/s9Z+qO7Op6N
Dqh5zx9aPMLP7nBsvZQSE3PN0dP/TNhKbtqbGSSFB6b/K9c+IEdHOwPUYzbQb4zi
AAkw4+7uJ8/su1Eph2pMe0ooU5uFtI1cgQLphf2eaRaLWG0htkG8yS2EqiATv5QU
psNw77TH7FMJ/UPDmJTxRadPMMA8o+CfiEU2Uu9bvmbiR3vFQLOP/AOJYX/RY2j9
InOiKPsFVvU6x2KGC3Qdu86f7HIy0/ketVvQwq2e2VmtSIBQrmDtb0z1KEXpsEAr
y08OHMsobiwueok1ee1+a18NXzAxWHCrlVthB9V7Mu64/N5Yf8ZlLq3+4PWwY4MC
MZzq0RkSB9TtLa+Zcgm3+7afENZX3w/UbbgN+/4eeNzCdp7XoOGMMiJkaZnRYiwo
s/cy3teLN4wef3oEK/+gzfLGRVQL40/ScC9apNinzpHKXGrEGIvNU0y5kxvSQ5C8
XsSFbaWhUExr08cGwifW2KWLmZkYqkd7HHFq5NBuew45OFc/6BWMQOIkJSmZ68ZL
IoAC0NCfh5caPd5cE0+y
=K01c
-----END PGP SIGNATURE-----

--Sig_/7BpmMSANPORTr6BvVQpx_f3--
