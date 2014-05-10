Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaEJHYo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 03:24:44 -0400
Received: from mout.web.de ([212.227.15.14]:55108 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaEJHYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 03:24:42 -0400
Message-ID: <536DD432.30809@web.de>
Date: Sat, 10 May 2014 09:24:34 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>, pbonzini@redhat.com
CC: Nadav Amit <namit@cs.technion.ac.il>, gleb@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Fix CR3 reserved bits check in long mode
References: <1397777591-6147-1-git-send-email-namit@cs.technion.ac.il> <1397781312-6885-1-git-send-email-namit@cs.technion.ac.il> <1397781312-6885-2-git-send-email-namit@cs.technion.ac.il> <536DD1AC.9070605@web.de>
In-Reply-To: <536DD1AC.9070605@web.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="6cVpu5c3dAkwrImlH1Qt3WELfb2b4NoX0"
X-Provags-ID: V03:K0:WBz3ZZI+ZF3fXnfWz+nS40KT8UnJ1fSGLlPiLbMdrn366NCKEiL
 y97q6mTeCvLGiDn+IebN1vdw6Lu8Jn5bJjMY3whSGxzmOeNU4U/2yb3CY7VZyHa03CG65Fx
 H0lM9FIzO43sJOYfUFa2QKEis13LSeZKeBLWPVmD4VCKoU7/2v6xUJOlAR324GkXALNWaPN
 bDw6f2DUQ3VoDilbjsBLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6cVpu5c3dAkwrImlH1Qt3WELfb2b4NoX0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

From: Jan Kiszka <jan.kiszka@siemens.com>

Regression of 346874c9: PAE is set in long mode, but that does not mean
we have valid PDPTRs.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 arch/x86/kvm/x86.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c5582c3..198aac8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -701,10 +701,11 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned lon=
g cr3)
 		return 0;
 	}
=20
-	if (is_long_mode(vcpu) && (cr3 & CR3_L_MODE_RESERVED_BITS))
-		return 1;
-	if (is_pae(vcpu) && is_paging(vcpu) &&
-	    !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
+	if (is_long_mode(vcpu)) {
+		if (cr3 & CR3_L_MODE_RESERVED_BITS)
+			return 1;
+	} else if (is_pae(vcpu) && is_paging(vcpu) &&
+		   !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
 		return 1;
=20
 	vcpu->arch.cr3 =3D cr3;
--=20
1.8.1.1.298.ge7eed54


--6cVpu5c3dAkwrImlH1Qt3WELfb2b4NoX0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNt1DMACgkQitSsb3rl5xTRHwCfQDOXl6v5pk4LT4SkWN3tOHYc
4BgAoJxyTGZ1/gpAtxyyhkHdHcp/2/8C
=rvJ8
-----END PGP SIGNATURE-----

--6cVpu5c3dAkwrImlH1Qt3WELfb2b4NoX0--
