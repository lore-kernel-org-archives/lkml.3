Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab3BBFwH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 00:52:07 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44523 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3BBFwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 00:52:04 -0500
Date: Sat, 2 Feb 2013 16:52:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Yang Zhang <yang.z.zhang@intel.com>, Kevin Tian <kevin.tian@intel.com>
Subject: linux-next: manual merge of the kvm tree with Linus' tree
Message-Id: <20130202165201.4b6930c2b0022354c8f12063@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__2_Feb_2013_16_52_01_+1100_m.QOZ=fRnCqNfjby"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Feb_2013_16_52_01_+1100_m.QOZ=fRnCqNfjby
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in
arch/x86/include/asm/vmx.h between commit af170c5061dd ("UAPI: (Scripted)
Disintegrate arch/x86/include/asm") from Linus' tree and commits
83d4c286931c ("x86, apicv: add APICv register virtualization support")
and c7c9c56ca26f ("x86, apicv: add virtual interrupt delivery support")
from the kvm tree.

I fixed it up (by applying the merge fix patch below) and can carry the
fix as necessary (no action is required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Sat, 2 Feb 2013 16:43:02 +1100
Subject: [PATCH] x86, apicv: merge fixup for uapi include file split

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/include/uapi/asm/vmx.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vm=
x.h
index 979d03b..9a74505 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -62,10 +62,12 @@
 #define EXIT_REASON_MCE_DURING_VMENTRY  41
 #define EXIT_REASON_TPR_BELOW_THRESHOLD 43
 #define EXIT_REASON_APIC_ACCESS         44
+#define EXIT_REASON_EOI_INDUCED         45
 #define EXIT_REASON_EPT_VIOLATION       48
 #define EXIT_REASON_EPT_MISCONFIG       49
 #define EXIT_REASON_WBINVD              54
 #define EXIT_REASON_XSETBV              55
+#define EXIT_REASON_APIC_WRITE          56
 #define EXIT_REASON_INVPCID             58
=20
 #define VMX_EXIT_REASONS \
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__2_Feb_2013_16_52_01_+1100_m.QOZ=fRnCqNfjby
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRDKmBAAoJEECxmPOUX5FEAIwP/3E94t37spkrLZjpKpX1rDfe
SCTXxojqXfMWCkYrHQ1TLG9Ac65jcDVdYHuvzxLPZ3SWP7QtxQxPjm6Q0INyX7/O
g/V12ig4nIETYznrCT0L9fgmjHuohIkx1QzrUOQaS9z3XjJIQQkJBXRmRu/uTKKq
PCznLk1g3UlvdcMqwcmnt0GW4CVWY1gmwOcHBL7kdfr8uA3hQc9mu58EktvF/K6m
kwTmZ5hU/lpg9VC4HaRY1NUwHH9W5dzO5tp0JZGginl3EFanwTk+FpkrJh2bPDBH
6yrL+O2Xjnw0sUxZmdVFP8RXGos/+OUGNIgMvwRj+C4W3JHwYWL75+8UH15k0PAd
+mkmgGzDe7YXYfYj4Mw95uO/a844otM3e+UCWFyTYdwLW4yIKFQ8WGQIAiBjny4e
o089zFTQ9jEAYtfn9xn/hJRKXK6alLi+/hQCe2sveYb+YIMXKdrWnxzAwCjqi8RD
dJ7Pzn0WjmMqViUJ3LuzFtPcXyJgWQ7jLx+gvwWwoAp/P8QYRCY4fVwvEiIf8+wE
4vPv0YXXd4wvjDiMYlKIwGHTGHBJqNsOPLilhD34zn9dIb1cWmXeelbtv/iX6RI/
k6XJsorDcPEkZENlayBXNEncD278VPe5v44DmgkmWR/9b+A2ggYV4MtNj37ckDkN
Fd+jQ3Ml65oqaWKYsA+2
=xdMn
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Feb_2013_16_52_01_+1100_m.QOZ=fRnCqNfjby--
