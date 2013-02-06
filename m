Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab3BFEny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 23:43:54 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44060 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab3BFEnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 23:43:52 -0500
Date: Wed, 6 Feb 2013 15:43:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Christoffer Dall <c.dall@virtualopensystems.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Alexander Graf <agraf@suse.de>
Subject: linux-next: manual merge of the kvm tree with the arm tree
Message-Id: <20130206154340.18fc2dc41e4278ea1edbbba6@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__6_Feb_2013_15_43_40_+1100_COZuW8vyyrQw4aCG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Feb_2013_15_43_40_+1100_COZuW8vyyrQw4aCG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in
include/uapi/linux/kvm.h between commit aa024c2f35a0 ("KVM: ARM: Power
State Coordination Interface implementation") from the arm tree and
commits fa6b7fe9928d ("KVM: s390: Add support for channel I/O
instructions") and 1c810636556c ("KVM: PPC: BookE: Implement EPR exit")
from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/uapi/linux/kvm.h
index 7f2360a,9a2db57..0000000
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@@ -636,7 -660,8 +661,9 @@@ struct kvm_ppc_smmu_info=20
  #define KVM_CAP_IRQFD_RESAMPLE 82
  #define KVM_CAP_PPC_BOOKE_WATCHDOG 83
  #define KVM_CAP_PPC_HTAB_FD 84
+ #define KVM_CAP_S390_CSS_SUPPORT 85
+ #define KVM_CAP_PPC_EPR 86
 +#define KVM_CAP_ARM_PSCI 87
 =20
  #ifdef KVM_CAP_IRQ_ROUTING
 =20

--Signature=_Wed__6_Feb_2013_15_43_40_+1100_COZuW8vyyrQw4aCG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJREd98AAoJEECxmPOUX5FEZhsP/25RF4ykAZt4xyhRXPUDfxGF
9MOfWl70WuXYLcqbu7c9eBFOFDVMRcYvht11IEUku1MZ+XN5kTdFd1OUNaYkwWEa
h0DawutISpdOHDQ5rnhwsoT0NocZlEiX2IE418iZwd8ABAIy58PnR3UfzYESuEt2
vzQUYcyvRBWhlJwRlHaNXRC0VJvGKUwuymw/OhHb8IClwMjckkdZ5ejbP1fSWNpC
0ZGQ6uzK74tnIUS1VH+B89SOUy26DMlG4q/g56dsN8w+Xyn5pDgeGXHK40wouX+7
8v52TE8V2r+xUzgntfL1BrcQtnlTFnnXXUsO3YHIwdBo10qdElWg/MUyKrYnAbu2
v16MKDMsInd//nQK1VaEMLpsTYxekunlo7c7NyHzefuLenyxR3UcrH+WP+MZq+fJ
QO6B0RV4cjjdLCK3yy+TPW9Ap8oIptVtGHU3AvvRXB02N0laagQWbqb+HV/Tqpf0
w/HzAdORHF4+x+KONrZLmwcjsQu07PG9O2dZJip5ixfxuDLo3R4MUvanKFAwak4P
iaV/iFEZ/5FE+HgH2yNAtnetfWCAYT8VoZmybR5NOjJd5qGWDd0JcLzvZiONm3Tu
bA6//F2aMBoLMWeMiabdi5piYgryfKpB7q6BKrnFPJIkhx954UmFa4alOyjc/Wea
qANKNUEm92wgpRB42eUk
=7Ad/
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Feb_2013_15_43_40_+1100_COZuW8vyyrQw4aCG--
