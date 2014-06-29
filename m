Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbaF2POE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 11:14:04 -0400
Received: from mout.web.de ([212.227.17.11]:62779 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbaF2POC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 11:14:02 -0400
Message-ID: <53B02CEB.7010607@web.de>
Date: Sun, 29 Jun 2014 17:12:43 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Gleb Natapov <gleb@kernel.org>, Borislav Petkov <bp@alien8.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org,
        =?ISO-8859-1?Q?J=F6rg_R=F6?= =?ISO-8859-1?Q?del?= 
	<joro@8bytes.org>
Subject: [PATCH] KVM: SVM: Fix CPL export via SS.DPL
References: <53AFE2B3.5080300@web.de> <20140629102403.GE18167@minantech.com> <53AFEB16.5040608@web.de> <20140629105339.GF18167@minantech.com> <53AFF192.7020801@web.de> <20140629115143.GA4362@pd.tnic> <53B0050B.90104@web.de> <20140629131443.GA5199@pd.tnic> <20140629134247.GG18167@minantech.com> <20140629140104.GB12528@pd.tnic> <20140629142722.GH18167@minantech.com> <53B02395.8030505@web.de> <53B027E0.7040003@web.de>
In-Reply-To: <53B027E0.7040003@web.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="IGoXGexsE5R7fB2CkxVvD7HxMFkosi12H"
X-Provags-ID: V03:K0:NkMPp48rAOHexvlJuYP8t2mhe/6Hd9sEQIkLbqYl0vp6u+FmxPH
 kj4K35TO+dfLGX8n4AN6+28pihfd1HuGHGmuwjPukg2fYqORT8B/39N57LFmo9WHoCfH8IM
 DJoDD7sjatc2GRrH2Mv8xpNTiAFP17JhLwkd+RBKBySzsDn1MtkFBoplFQ2XMoOgcucopSc
 EQ8h7H6TFlNaJbs/Tvlxw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IGoXGexsE5R7fB2CkxVvD7HxMFkosi12H
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

From: Jan Kiszka <jan.kiszka@siemens.com>

We import the CPL via SS.DPL since ae9fedc793. However, we fail to
export it this way so far. This caused spurious guest crashes, e.g. of
Linux when accessing the vmport from guest user space which triggered
register saving/restoring to/from host user space.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---

Just in time for the next match :D

 arch/x86/kvm/svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ec8366c..b5e994a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1462,6 +1462,7 @@ static void svm_get_segment(struct kvm_vcpu *vcpu,
 		 */
 		if (var->unusable)
 			var->db =3D 0;
+		var->dpl =3D to_svm(vcpu)->vmcb->save.cpl;
 		break;
 	}
 }
--=20
1.8.4.5


--IGoXGexsE5R7fB2CkxVvD7HxMFkosi12H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOwLOwACgkQitSsb3rl5xQ8LACgnwzKz8jjfgaWHnvkvvx2zyJk
OMMAn1l+Q5Q76G/GMKzFN77c4jVKLpbE
=FFAN
-----END PGP SIGNATURE-----

--IGoXGexsE5R7fB2CkxVvD7HxMFkosi12H--
