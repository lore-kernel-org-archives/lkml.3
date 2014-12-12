Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbaLLGM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:12:27 -0500
Received: from ozlabs.org ([103.22.144.67]:52759 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbaLLGM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:12:26 -0500
Date: Fri, 12 Dec 2014 17:12:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pranith Kumar <bobby.prani@gmail.com>
Subject: linux-next: build failure after merge of the rcu tree
Message-ID: <20141212171215.6beff7b4@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/p5gVPHcnmOPEjtcXlFwOON7"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/p5gVPHcnmOPEjtcXlFwOON7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the rcu tree, today's linux-next build (powerpc64
allnoconfig) failed like this:

In file included from arch/powerpc/include/asm/kvm_ppc.h:30:0,
                 from arch/powerpc/kernel/setup_64.c:68:
include/linux/kvm_host.h:366:21: error: field 'srcu' has incomplete type
  struct srcu_struct srcu;
                     ^
include/linux/kvm_host.h:367:21: error: field 'irq_srcu' has incomplete type
  struct srcu_struct irq_srcu;
                     ^

I am sure we have seen this before :-(

Caused by commit 31a78b1b598a ("srcu: Isolate srcu sections using
CONFIG_SRCU") as it was before (I do wonder why this came back).

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/p5gVPHcnmOPEjtcXlFwOON7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUiodFAAoJEMDTa8Ir7ZwVHD0P/26MlLHyqoQmN6+NJGYBmG3b
/918gSa9raq1vvwWRT06YzVDOQNm0DahKhPmhgQZQbErwdS30GCt+Fz5kYo7Bffv
UcV8NNzdmvXOOTkIS6hQGUgAP7gJezofkAxMJBx3BM18ceL9b59rHSr45BBzMHkO
GZj+pWlXw/+/XNuqv/I6ypMPZcNI5T00URK1uJyF0KrS851AoYVU24CfmOiTp465
Y38MMTbG2CnqdCwldhzIBicD0pJoK+msjkYGVWuTquVmeRE3EOi0NcFrO4atUrim
tu9dLH/f1Yahf4DcjBvkeVXYqPodUPuu/y+RnyeRoIOZObcNBQdtPQea/JlqUqAD
qNqU3a5ZaWodn8ptQ8/CMUnvCxwsicljU7TtV1CR4sDO4YZDk8SFVpHOVJsKqdbu
NhYcNcBGlreEOsPOvNOWCM5493mrmPwm+CvJ2hH443N0M4/FvWTFtUnitq/hT/iJ
A8lojhm96svHOayWpl3fYkFVh8V+BqWz+89dKTO2DvdFjHIWd3xKYHlvNS8YQ6SK
0tB6XtGodllPuXPvvYVQtvg60Bj4hs9m+wr5CBl6CQGcF+ncoI+K7DuwWORipARs
+q7jzOUPM5ezH1DnWnYIoSoZNlEfQz+r3jWKWUByO0Ekh8UFf6g28aAHwmZEgpWy
khD0jk63RB/V9CUi8Km1
=De2g
-----END PGP SIGNATURE-----

--Sig_/p5gVPHcnmOPEjtcXlFwOON7--
