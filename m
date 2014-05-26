Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbaEZEHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 00:07:45 -0400
Received: from ozlabs.org ([103.22.144.67]:33393 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbaEZEHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 00:07:44 -0400
Date: Mon, 26 May 2014 14:07:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <chris@printf.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: linux-next: build failure after merge of the mmc tree
Message-ID: <20140526140735.3f405672@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/KzmGYHm9LCcuIKJ4PfNygRs"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/KzmGYHm9LCcuIKJ4PfNygRs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Chris,

After merging the mmc tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

drivers/mmc/host/sdhci-s3c.c: In function 'sdhci_s3c_notify_change':
drivers/mmc/host/sdhci-s3c.c:402:25: error: 'struct sdhci_host' has no memb=
er named 'card_tasklet'

Caused by commit 3560db8e247a ("mmc: sdhci: push card_tasklet into
threaded irq handler").  This is the second left over one I found.
Please check for any more (grep is your friend).

I have used the mmc tree from next-20140522 again for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/KzmGYHm9LCcuIKJ4PfNygRs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTgr4MAAoJEMDTa8Ir7ZwVXwIP/2dwyMqvpTqE6d/LXO7kIdeX
UnvPA7SP9Z6MVDbphQlfzB2n98dFK0cl30100Nn9kJGQs5IHrDEYoeHGdTfUPASM
4pjr2BXFJe3/lEgLFb84TIBI+Pjb/v3sUtTAjFACKl9FChTLfM4qIu1WBVTAl5/D
ksmFRjsId5OdYChoMCEeiQOGR+kSTVJbvjHOC5++AIGnJ5fNMmGsOhsSMxBYl9al
fxTN4Y8JiFAW2LaRDOtDDviM8llQwxMZbN590SbSUDTmCIHxHIlE1R8OBXb9jMtX
x3/F3TFMyYbdSs4WJfwgnODAHyHDNp1VCN7Dp5mQ0uAZh9qOOCK3obQ5wu0sAXvH
z6z2FcHijzEEvVihBe8oP8HMn/ICUbcQPQuTmAKJU0E7VqGTSfJ0ZQjwGxlNEzy3
WuuOyZwOIN+vfjQSUfXUzHgf+rWP16brqRHk+NdTvu+7WAEeSg3t4xu9yYOs5txh
w1Hn2JjVHSXDciOETa2l1W2q2gLdlCLjRn1OVCthu2AJnRnoW7eaMTGaVyhyoc5O
liHThXyp+tNQfgDMDr1f53fIGCZj+CM6TnsUGf/31qkTBmZ05jZuylOgKLmtubzI
jhpQIdopx0kvEr80DjycigJQgXualM2otBEJVwh3hE1Kb4hHYTlhmIAM6ip9iKcK
oeFl/r1yhoPqSRPAex9A
=dbTR
-----END PGP SIGNATURE-----

--Sig_/KzmGYHm9LCcuIKJ4PfNygRs--
