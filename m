Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbaCKUJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 16:09:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59714 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbaCKUJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:09:24 -0400
Date: Tue, 11 Mar 2014 20:09:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Konstantin Weitz <konstantin.weitz@gmail.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140311200914.2cf12d61480eca0044691007@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__11_Mar_2014_20_09_14_+0000_Z1fvsEVAky95t/Qb"
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: manual merge of the kvm tree with the  tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Mar_2014_20_09_14_+0000_Z1fvsEVAky95t/Qb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in arch/s390/includ=
e/asm/kvm_host.h between commit b31288fa83b2b ("s390/kvm: support collabora=
tive memory management") from the  tree and commit 672550fb682e993 ("KVM: s=
390: Provide access to program parameter") from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

diff --cc arch/s390/include/asm/kvm_host.h
index 9bf95bb30f1a,734d302ba389..000000000000
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@@ -106,9 -107,9 +107,11 @@@ struct kvm_s390_sie_block=20
        __u64   gbea;                   /* 0x0180 */
        __u8    reserved188[24];        /* 0x0188 */
        __u32   fac;                    /* 0x01a0 */
 -      __u8    reserved1a4[58];        /* 0x01a4 */
 +      __u8    reserved1a4[20];        /* 0x01a4 */
 +      __u64   cbrlo;                  /* 0x01b8 */
-       __u8    reserved1c0[40];        /* 0x01c0 */
++      __u8    reserved1c0[30];        /* 0x01c0 */
+       __u64   pp;                     /* 0x01de */
+       __u8    reserved1e6[2];         /* 0x01e6 */
        __u64   itdba;                  /* 0x01e8 */
        __u8    reserved1f0[16];        /* 0x01f0 */
  } __attribute__((packed));


--Signature=_Tue__11_Mar_2014_20_09_14_+0000_Z1fvsEVAky95t/Qb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTH21qAAoJELSic+t+oim9ByAP/iXEtSV4XWigbtd5hUCNxOF/
K1sfOQAsxmi1agDS7KP5y2I9qRAiJokKWEJON5dkh/0A5SiyisEiPnjmhE3SMtuG
0K8Vq7yLCpK1n4YgvMIOVfzAgUwzXUhJlb30iAwfvJtrn82hgKJeLf+cV7N+LmiV
7Szbq4X4Z8iYUJfB42cWTxfHLjV1hlVxI1m1jexboOnZpL1BJ4xRB0uI4H1ZFprb
X91w6r9pskXZKIIqjUCskbUtBCA2bXPhlil+o+utxKNARIuDrZv4Wu6eTxbRbmTq
NGSVqo1EDj0d4eQBe6Bqg/JIJfR+aMPN+gYAUbVak4Z0hAHjZOlytJ7srxwgbbqq
hUuqbF0OQYNmZg4g9EJ61fdh7bC8Sr8r9efVQT0vXkL1jDHYHFfCn1sAYAwSFEQm
YZ6s0d9ihlNpj2lVee79sfdtbrT5vACf3L9LSUDX2+gwrQwsG4MoJ24JvtV062ry
Jve+x/JaX/TfIxoUIm43o0XJEIHxUEhr+iecG9N0PmFyKTLUdxVg3T+7fmK7B3Pt
xkdQ79XsoCHK9NublENnJl0Y1yZ5ALWf6nnApCVpn8JmgWJOvwUpyUM+aZCOmmGD
4GxPTaoDLA5q58bsKauxfFd4FROkjqkfwdi9bxmBor84PftgCFf513mjWHgLQTsG
L1zbCh2ryqERJwZoUdJZ
=TVtZ
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Mar_2014_20_09_14_+0000_Z1fvsEVAky95t/Qb--
