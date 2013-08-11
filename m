Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab3HKH7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 03:59:36 -0400
Received: from mout.web.de ([212.227.15.14]:53898 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab3HKH7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 03:59:32 -0400
Message-ID: <52074461.5040105@web.de>
Date: Sun, 11 Aug 2013 09:59:29 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Subject: [PATCH] trace-cmd: Update VMX exit reasons in KVM plugin
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="SNJTAVVJNWiERK6UU55qHwmg45qThjfVD"
X-Provags-ID: V03:K0:l0okQEVtmzXd7iWyiU9ePaI7PLXYKA6FLaLt27CK7aoUFrn329O
 vtyGURa6sB3wafyg/By4y3r+VaOqTzzG69Vb6Qrp9U/x7DwrlpYFMLnRQsrBh9gj6dL+TS9
 njhFPTZtcMKLsvCuOJVyg4IU0GMUURWib/QuGOHJi4gE2sR8kWYibmfNemV4b6+PkyaW1Mz
 2Ye/U+TE+FDvutDGcts6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SNJTAVVJNWiERK6UU55qHwmg45qThjfVD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

From: Jan Kiszka <jan.kiszka@siemens.com>

Aligns us with latest arch/x86/include/uapi/asm/vmx.h.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 plugin_kvm.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/plugin_kvm.c b/plugin_kvm.c
index 9b376d8..8a25cf1 100644
--- a/plugin_kvm.c
+++ b/plugin_kvm.c
@@ -91,6 +91,7 @@ static const char *disassemble(unsigned char *insn, int=
 len, uint64_t rip,
 	_ER(TASK_SWITCH,	9)		\
 	_ER(CPUID,		10)		\
 	_ER(HLT,		12)		\
+	_ER(INVD,		13)		\
 	_ER(INVLPG,		14)		\
 	_ER(RDPMC,		15)		\
 	_ER(RDTSC,		16)		\
@@ -115,9 +116,15 @@ static const char *disassemble(unsigned char *insn, =
int len, uint64_t rip,
 	_ER(MCE_DURING_VMENTRY,	41)		\
 	_ER(TPR_BELOW_THRESHOLD,43)		\
 	_ER(APIC_ACCESS,	44)		\
+	_ER(EOI_INDUCED,	45)		\
 	_ER(EPT_VIOLATION,	48)		\
 	_ER(EPT_MISCONFIG,	49)		\
-	_ER(WBINVD,		54)
+	_ER(INVEPT,		50)		\
+	_ER(PREEMPTION_TIMER,	52)		\
+	_ER(WBINVD,		54)		\
+	_ER(XSETBV,		55)		\
+	_ER(APIC_WRITE,		56)		\
+	_ER(INVPCID,		58)
=20
 #define SVM_EXIT_REASONS \
 	_ER(EXIT_READ_CR0,	0x000)		\
--=20
1.7.3.4


--SNJTAVVJNWiERK6UU55qHwmg45qThjfVD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlIHRGIACgkQitSsb3rl5xQHVQCfVLdJWd2hABiOy8r8LBjZQygc
fUcAnjE7rOMSz7WD6m+5QGEYrhJx/Jih
=e3oQ
-----END PGP SIGNATURE-----

--SNJTAVVJNWiERK6UU55qHwmg45qThjfVD--
