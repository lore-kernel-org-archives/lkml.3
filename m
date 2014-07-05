Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760660AbaGEHsG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 03:48:06 -0400
Received: from mout.web.de ([212.227.15.14]:49655 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681AbaGEHsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 03:48:04 -0400
Message-ID: <53B7ADAA.9030101@web.de>
Date: Sat, 05 Jul 2014 09:47:54 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: kvm <kvm@vger.kernel.org>
Subject: [PATCH] x86: Make x2APIC support depend on interrupt remapping or
 guest support
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="L4d9CPwlM73RErRFrTnDBeJpWND7iUuV4"
X-Provags-ID: V03:K0:RzN5VS8clHj9kZvmRRrp3Fpg56EFN97r++kbM51MprdVNasQhQz
 RXWY9xsILHPxagR7UUz5B36iqWNYXpIsg+q6WGexHiQsyFUys1GJyBkW8l+57R1vpXqKsHL
 T7PJggVjP9p/xMvVUPCQlFx7jzN7Ct0EMAFsxtaoGaEgZTrQCweDSTVxtjCN/CJcz1wtJCE
 IZ0Ia3/kezPUJHN35qzAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--L4d9CPwlM73RErRFrTnDBeJpWND7iUuV4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

From: Jan Kiszka <jan.kiszka@siemens.com>

We are able to use x2APIC mode in the absence of interrupt remapping on
certain hypervisors. So it if fine to disable IRQ_REMAP without having
to give up x2APIC support.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a8f749e..30a9987 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -310,7 +310,7 @@ config SMP
=20
 config X86_X2APIC
 	bool "Support x2apic"
-	depends on X86_LOCAL_APIC && X86_64 && IRQ_REMAP
+	depends on X86_LOCAL_APIC && X86_64 && (IRQ_REMAP || HYPERVISOR_GUEST)
 	---help---
 	  This enables x2apic support on CPUs that have this feature.
=20



--L4d9CPwlM73RErRFrTnDBeJpWND7iUuV4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlO3raoACgkQitSsb3rl5xQ/HwCeM3X6wc7QGzLsQePFkPhXZ3y9
9HEAnRd5kYJfkftMltEH8BLkCGJ3l6hG
=zU68
-----END PGP SIGNATURE-----

--L4d9CPwlM73RErRFrTnDBeJpWND7iUuV4--
