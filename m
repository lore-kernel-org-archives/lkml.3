Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab3BGDUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 22:20:16 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46624 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3BGDUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 22:20:14 -0500
Date: Thu, 7 Feb 2013 14:20:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the kvm tree with Linus' tree
Message-Id: <20130207142005.2cc57245bec91614a8ae0a55@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Feb_2013_14_20_05_+1100_CqRJbs+DW27mFyKL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Feb_2013_14_20_05_+1100_CqRJbs+DW27mFyKL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in
arch/x86/include/asm/vmx.h between commit af170c5061dd ("UAPI: (Scripted)
Disintegrate arch/x86/include/asm") from Linus' tree (v3.8-rc1) and commit
b0da5bec30ec ("KVM: VMX: add missing exit names to VMX_EXIT_REASONS
array") from the kvm tree.

The section modified by the latter has been moved to
arch/x86/include/uapi/asm/vmx.h, so my fix up patch for that file now is
below and can carry the fix as necessary (no action is required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 7 Feb 2013 14:15:07 +1100
Subject: [PATCH] x86, apicv: merge fixup for uapi include file split

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/include/uapi/asm/vmx.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vm=
x.h
index 979d03b..2871fcc 100644
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
@@ -103,7 +105,12 @@
 	{ EXIT_REASON_APIC_ACCESS,           "APIC_ACCESS" }, \
 	{ EXIT_REASON_EPT_VIOLATION,         "EPT_VIOLATION" }, \
 	{ EXIT_REASON_EPT_MISCONFIG,         "EPT_MISCONFIG" }, \
-	{ EXIT_REASON_WBINVD,                "WBINVD" }
+	{ EXIT_REASON_WBINVD,                "WBINVD" }, \
+	{ EXIT_REASON_APIC_WRITE,            "APIC_WRITE" }, \
+	{ EXIT_REASON_EOI_INDUCED,           "EOI_INDUCED" }, \
+	{ EXIT_REASON_INVALID_STATE,         "INVALID_STATE" }, \
+	{ EXIT_REASON_INVD,                  "INVD" }, \
+	{ EXIT_REASON_INVPCID,               "INVPCID" }
=20
=20
 #endif /* _UAPIVMX_H */
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__7_Feb_2013_14_20_05_+1100_CqRJbs+DW27mFyKL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJREx1lAAoJEECxmPOUX5FEblUP/3rqCUWmfxKeW1pav/N0BBXd
9f862wptd5AzR58LjQB6AvJ4+rMBP+kcM7l1Qt2/1O4q7OGHMMqAp2ZkrBqqEiX5
2Z8VADHtNsZGszY0WSY9cNzG7biTA+S5inQ27SqR3pQXnfKlL+UKXXuKWHVYVWao
Wk/ztgoVJVSp7uUGeOnzkD3fMJizWDVtT1Mk/aAgVYVxh6rEW2LhmhMEG7Fle5sI
GxSS8HibqvxT1JjdAR/HVJPj0hE+s4rSXOR7rqt2h9bKOHpQmponBbIrJUIxrZq8
Dbb3j4F0cYH7HLSCB0POXwZ3VqZKY4TZQlT1vh/SRO00LQ02tAIuWREYOycsykh/
JcAUN8HVQ5MM45X5dL+GtdOxsrTAnT3wESBZ78x0Xwin6hCyI+8Ll7w5Ft8HbB3p
BDvaBQObIhsE3EZPxLsbR6aYJkWWJC7aYB15GrGryJWHq2vuo4U445fqb83CEWBh
hJxSSjDvWcbC785YvP/2EbpLwZze0FN9vAwGXUk7I819Nsiqxybj4JhjIPBgGESM
2tMLa+r6xjfL28KBe6wDKhFIoIZtglf6sl8C9MAPJVwaKZ26/+kUto8n+Elf6i5+
2WVO/U5dZrl2o+Rve3jZz7XPyQHbsKH4adRmjmEf4jUfLfPHO4hIrLefak3/WnRk
6o7TdtTPsHY0B+DicAHR
=4PFO
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Feb_2013_14_20_05_+1100_CqRJbs+DW27mFyKL--
