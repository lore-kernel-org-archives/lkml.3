Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab3CMEy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 00:54:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56324 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3CMEyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 00:54:24 -0400
Date: Wed, 13 Mar 2013 15:54:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: linux-next: manual merge of the akpm tree with the rcu tree
Message-Id: <20130313155422.64fd0598621a53840479a6b5@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__13_Mar_2013_15_54_22_+1100_pkmaR_YFuaFzU5WT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Mar_2013_15_54_22_+1100_pkmaR_YFuaFzU5WT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
kernel/rcutree.c between commit 3c62110a0cd6 ("rcu: Tone down debugging
during boot-up and shutdown") from the rcu tree and commit "kernel/:
rename random32() to prandom_u32()" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/rcutree.c
index 2d5f94c,2f8530b..0000000
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@@ -1441,8 -1319,7 +1441,8 @@@ static int rcu_gp_init(struct rcu_stat
  					    rnp->grphi, rnp->qsmask);
  		raw_spin_unlock_irq(&rnp->lock);
  #ifdef CONFIG_PROVE_RCU_DELAY
- 		if ((random32() % (rcu_num_nodes * 8)) =3D=3D 0 &&
 -		if ((prandom_u32() % (rcu_num_nodes * 8)) =3D=3D 0)
++		if ((prandom_u32() % (rcu_num_nodes * 8)) =3D=3D 0 &&
 +		    system_state =3D=3D SYSTEM_RUNNING)
  			schedule_timeout_uninterruptible(2);
  #endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
  		cond_resched();

--Signature=_Wed__13_Mar_2013_15_54_22_+1100_pkmaR_YFuaFzU5WT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRQAZ+AAoJEECxmPOUX5FE0usQAIQ0Mmt6ZNekVk7TOr67hkV6
2TXAbPOMtsk/DCXFWUm6j/Bd5C7uUi86mGKynHjYr1+YoN2BBM2hCpEPjHjVZ9WW
1DI4rdRGJLXHWc1qQJ6aLq0WKdAN3GDs9WLNJz5D8R/MHewXAKgbcPPPw3dacO7r
Fvt8SW7iEJ1gKpNjgBS70YKlXUY9RXSvfro5EyYsp44dGbBU/UYHNQbuKek/0SNR
VuE9hglb3tggeTj2JhevOK7X3YLC0C9pUz4Lm3oYRJuIV6aiYyUhz4gwoTdVHo8b
9tNp7K3VreXSgpMbHbnUvxp/Tk1RSywWyhh160hCNVYR0xSCJLPPcVbyVJIzOsb5
jPjFHuq6R43PD48uMltSQn3lTluL0N6C/kHvnbJM/6N8bMCOoRM1AWlui6KoZnaM
+RHn0myi3SMNdizvvR/cjTphTG57Q+W9p7Z6rHegwDyMDjTe/tszf/Zug8fenDov
k3KplKK1YuQ4H3Leibs5VY29olkTD9lP2QxHu9GmsbCagODqLPF4l1GgUClbuzgq
QwB4vUco0HMi1aUqxRGWxoRevbzMhY9drtnrXbIBQo7KriwgVXnEEtRyTgv7mB9I
Tr3+aQATkdk4h38dBkE1cP4FIoTLeFt3UB2CKnrVPdqQNCDD+y5Pjl8x90RJcZnK
MCEguInd77IUmuVgBfxZ
=73GL
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Mar_2013_15_54_22_+1100_pkmaR_YFuaFzU5WT--
