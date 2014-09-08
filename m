Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaIHGEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 02:04:43 -0400
Received: from ozlabs.org ([103.22.144.67]:45017 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbaIHGEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 02:04:42 -0400
Date: Mon, 8 Sep 2014 16:04:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will.deacon@arm.com>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20140908160430.21c67797@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/bLm3+CVE_0St3Gb_0CUmdIV"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/bLm3+CVE_0St3Gb_0CUmdIV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in
arch/arm64/include/asm/kvm_host.h between commit 656473003bc7 ("KVM:
forward declare structs in kvm_types.h") from the kvm tree and commit
6951e48bff0b ("KVM: ARM/arm64: fix non-const declaration of function
returning const") from the kvm-arm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm64/include/asm/kvm_host.h
index be9970a59497,50431d36732b..000000000000
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@@ -43,7 -41,8 +43,7 @@@
 =20
  #define KVM_VCPU_MAX_FEATURES 3
 =20
- int kvm_target_cpu(void);
 -struct kvm_vcpu;
+ int __attribute_const__ kvm_target_cpu(void);
  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
  int kvm_arch_dev_ioctl_check_extension(long ext);
 =20

--Sig_/bLm3+CVE_0St3Gb_0CUmdIV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDUbyAAoJEMDTa8Ir7ZwVsekP/0JQvJ9ukYyxEf7XwAhquII8
DwjMpUcztJn6Y0Mlk3nm4R4nFqmyFauVUVJbVg69f91p7x/GOYRL92uAw1LXItw1
boVByzGj8ybct6nwKF+GHy/UDpdVvxw55QzulGHgYBGAyFO2C9U/eu4OoknnaCCy
qXlJps5iZda/Qn1CWApCqoHXJWysSFeJmCDkNoM2WFYpy03Rz5m6WEelP6BuzYSg
AmVzqekzkiQA0L+AuqyMgN3OnNiL85S0yvq0tT6RsOZSV+Cg4DhQQ0t6qdVT0P0R
5/DvYwz4tQkoO90pTb90F98KUGjs5Hw92Lr28ifjUVXHqdtZ2AXyFZ/9qPHj9hDo
M/Q6CIvEclBhx/T+0x78f7mc7c4A8B6ww1xLCM/qsdhSaNrf+PWaVkTRacHGqnBe
v5ELk9EEQWE6ddtWZTagMzCvr8TN9IM8eQysB9lgzh3kIz794hypSrdTjxDOVGKN
HE8P/AijTWf8wBPniRz13vnX8St6PE30rO4jJmq6LrFBiFPwfrl0ylHv4CsYYoIw
S8wT+XP1W/5Aylmopl/Aaxv6bSABiEo9eKalVebdN+bRJGvbdCacpMNo3gY4O+iX
hlAU7KwTojJoy6rS2lDXUBWYM4vEUMnnVSfhLrOE6CFDkHxYVUq8Kg5caT5WQtfJ
4z7ytjRFA3PsKm1Bi7MM
=AufA
-----END PGP SIGNATURE-----

--Sig_/bLm3+CVE_0St3Gb_0CUmdIV--
