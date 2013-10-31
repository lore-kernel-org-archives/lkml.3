Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab3JaGXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:23:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46258 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3JaGXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:23:08 -0400
Date: Thu, 31 Oct 2013 17:22:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Ruchika Gupta <ruchika.gupta@freescale.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: linux-next: manual merge of the devicetree tree with the crypto
 tree
Message-Id: <20131031172253.fc313254e18e3242fa2cd540@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_Oct_2013_17_22_53_+1100_w6Sow2tsXdubDudt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_Oct_2013_17_22_53_+1100_w6Sow2tsXdubDudt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the devicetree tree got a conflict in
drivers/crypto/caam/jr.c between commit 313ea293e9c4 ("crypto: caam - Add
Platform driver for Job Ring") from the crypto tree and commit
f7578496a671 ("of/irq: Use irq_of_parse_and_map()") from the devicetree
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/crypto/caam/jr.c
index 636bb53125ab,517a16d87e4b..000000000000
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@@ -480,7 -403,7 +480,7 @@@ static int caam_jr_probe(struct platfor
  		dma_set_mask(jrdev, DMA_BIT_MASK(32));
 =20
  	/* Identify the interrupt */
- 	jrpriv->irq =3D of_irq_to_resource(nprop, 0, NULL);
 -	jrpriv->irq =3D irq_of_parse_and_map(np, 0);
++	jrpriv->irq =3D irq_of_parse_and_map(nprop, 0);
 =20
  	/* Now do the platform independent part */
  	error =3D caam_jr_init(jrdev); /* now turn on hardware */

--Signature=_Thu__31_Oct_2013_17_22_53_+1100_w6Sow2tsXdubDudt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJScfdGAAoJEMDTa8Ir7ZwVt+AP/0k+HwP83ZOyktDVxuoFshQC
F8KPtZ0w4YgUoUaTw73RAEyzg47sWRZzLbXwwusAqwfFfVk5kUR67f1q+yUWBz1e
L2Ql6/Ywb7vkFfCUM+zJREgQHeodPZC01vaUQ7BPLGmx08lSmR0ETEwLPnESxp6X
9lWuC3PoryL9S/p2H7huG9iH1wV9fLDB0GFVfnTIdmg8tji6dXl43oe2BpwOjvOB
XJ42ykxbY3zB0CgEcTclMDGCBrDcNc9hiHTfLIlufRa23ErBExJl8wmJqX+AH5sm
jnM03iWSZaofy03DLukFj4VB/3i/E8oE6Nno3LpRRTLznAp+HFwa/lTKDFFHVCNH
Q7fvIDte2n9YRLcqM0aIRYfdIlAAG8QycPEj6lbYbrxaAsZut4Bq5ULjQI5pyKOz
n4t9tbV7sdZ4gzO5pAZKfY4FRp28vVe0j8iavC7mRs4PoMm7c4iqL+PmB5HIrnz1
YFMQc5ZGMs9TG6VqDE77i4CvfXRCL+jjPkMjFJCPZITVz5yYsmzHwMhdYnADFJz6
mNqmoJ/6cPLBypDbD22xDaNfjI28xIhUo48AhWf2kYvek/02MHsrtv96WZ/mWxGj
ZKLyBc+yb8AmXsBPjoqhuMq6z/zGsSf6+/JC4gGvdRuA7FcjnRCn+73b1YbtEcH/
/wjIdloiZaQ99kNwmrWk
=zsZX
-----END PGP SIGNATURE-----

--Signature=_Thu__31_Oct_2013_17_22_53_+1100_w6Sow2tsXdubDudt--
