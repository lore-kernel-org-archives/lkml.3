Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaLOGa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 01:30:57 -0500
Received: from ozlabs.org ([103.22.144.67]:33450 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbaLOGaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 01:30:55 -0500
Date: Mon, 15 Dec 2014 17:30:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Linus <torvalds@linux-foundation.org>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20141215173047.1b2fe0d1@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/+qy1dGjZ5PESo=7KOq.9QNQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+qy1dGjZ5PESo=7KOq.9QNQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

mm/oom_kill.c:257:20: error: redefinition of 'task_will_free_mem'
 static inline bool task_will_free_mem(struct task_struct *task)
                    ^
In file included from /scratch/sfr/next/mm/oom_kill.c:20:0:
include/linux/oom.h:90:20: note: previous definition of 'task_will_free_mem=
' was here
 static inline bool task_will_free_mem(struct task_struct *task)
                    ^

Caused by commit 4bf284e597a4 ("oom: don't assume that a coredumping
thread will exit soon") from the akpm-current tree interacting with the
version that finally went into Linus' tree (commit d003f371b270 ("oom:
don't assume that a coredumping thread will exit soon")).

I removed the definition of task_will_free_mem() from the akpm-current
tree version.

Andrew: this sort of thing could be avoided if the actual set of
patches that you send to Linus were present in linux-next (even for a
day). :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/+qy1dGjZ5PESo=7KOq.9QNQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUjoAcAAoJEMDTa8Ir7ZwVm1AP/jnx9TaJ2r34O3AOxrdoBbJG
2X52LwLytHJwuE5Qs4Wr/lA2SZooEvL/bmdqtUQ1p5bjA0UOxL6e7ZoApuujMbn3
NqC+Q5srM1dp1qIXJk9W+CzC+Rur8JtaY4R3WhDLaUr8SH65IMe+X2PsWaZacC/I
gk+ryn2rSsZsoYfTxXOT1xdKcPN2JqKVARzvzpsr7r1pPgOIB70qBVGq3ZG0SIeG
+oOh93bGzjbcjNbCHwrSUF07Rs+aC+uKtCXJDfgLU3HDKIJty3fX6XJsX0n83Ffk
FBE12gQZmaVdLNTUxcnyeu3DuDTbVHd2dsz02ajN+bCCUXCD42X1JldnlkKyuuaC
bE/07HGZUZdBNDO9tzJoCT5bZ1kbS4XHWjZ8xGdC7Rvr0/BzwAd7KprSe1e1DPrQ
+5p8rg2yqRdjnEWgtKyeBa2V15gipCcP644wANVbs1Ht6KXDWyENoLoA75h9/5bA
dyxQUguXzipFCFnRCAE97MoVMhWLYwOElT+s3/vxKgM5n5/T6PY7Rkw5YvcdRqzN
IVBhoH/87tn2nMN8Oay+TL5PjmOVU8Tav/Sr0Re/1hbmybxhabIxJ1/YuTzDAMEF
obFP4W3B8eeaYgHDQguAebE+9wQ8W8K5PcZBkPrTWqPo0I5EKUT+eyzpbXHr2p1y
rCF5bDMrULpRCCjYOo5j
=Zn24
-----END PGP SIGNATURE-----

--Sig_/+qy1dGjZ5PESo=7KOq.9QNQ--
