Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaCLV1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 17:27:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57635 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaCLV1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 17:27:49 -0400
Date: Wed, 12 Mar 2014 21:27:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Eric Paris <eparis@redhat.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140312212739.b160142e6f75e4e9f23640ab@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__12_Mar_2014_21_27_39_+0000_RUw3e.UgtGNScMrd"
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: manual merge of the audit tree with arch trees
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Mar_2014_21_27_39_+0000_RUw3e.UgtGNScMrd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the audit tree got conflicts between context ch=
anges in various arch trees and commit b4df597ae51f820 ("audit: Add CONFIG_=
HAVE_ARCH_AUDITSYSCALL") from the audit tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

diff --cc arch/powerpc/Kconfig
index 957d3e5aff9e,96627d67bd67..000000000000
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@@ -140,7 -139,7 +140,8 @@@ config PP
        select OLD_SIGACTION if PPC32
        select HAVE_DEBUG_STACKOVERFLOW
        select HAVE_IRQ_EXIT_ON_IRQ_STACK
 +      select ARCH_USE_CMPXCHG_LOCKREF if PPC64
+       select HAVE_ARCH_AUDITSYSCALL
 =20
  config GENERIC_CSUM
        def_bool CPU_LITTLE_ENDIAN
diff --cc arch/x86/Kconfig
index 0af5250d914f,56f47caf6fa0..000000000000
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@@ -126,7 -125,7 +126,8 @@@ config X8
        select RTC_LIB
        select HAVE_DEBUG_STACKOVERFLOW
        select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
 +      select HAVE_CC_STACKPROTECTOR
+       select HAVE_ARCH_AUDITSYSCALL
 =20
  config INSTRUCTION_DECODER
        def_bool y

--Signature=_Wed__12_Mar_2014_21_27_39_+0000_RUw3e.UgtGNScMrd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTINFLAAoJELSic+t+oim9bb0P/2u/uzMTp3kQECGrLVRHWivu
3LAnA9n2xlUdIlRoJfT/Jrl3rqziWFxVSvMiE5fg/B0nbtB+/u6v+XYS/TQsSGpO
Y6VdWUdPWHZMG373f8yIjJc9lx+RvwEdpcEf1SUl9lHN0u2BS1uiIVpSAJp5yLxQ
/TITeKsA3FSGuE7aNj9xW1isuOETXQ6fvY95oYYJNpdQFZ7ZPCcVKvGs2+t/RdTf
VdOkZZKN5BERTiG5TKr0HyayvkZVgPjazg+v2CyStq29KnlJR+WZsyMJySjHKmqN
zqUgcKgoOuefJ0Us9z9wrvIoBfJQBqKdh3AcHqDUpO9Yw2MN6CqBaVkaf4kIeadg
sNE65twt/8+Xm48Jbd1pEffRkenBuEc1Vjd6oYlFnHunvFQVtCl5KjIgh+7CE4Tr
HWZ27CNpM+Y2XtGLy9DKzOQOhJU8Srvd5U7YFtusaOCIQ38aFEd75c0hxJzyYGXE
3qMH0elFNBrl2Jspy5nQnbdfXrW+DY4SW2BVjlrUIKcnyNh2l5ww/0tfrI/HAN0g
YMsZAGnUCxfDcTC299YkJIOQ7LO2BDO0CVZ6EipMXfUFpXUtTX1cotbEjIh1f0Ht
eNV9jqsQzMCuTZg/LQKhxfpf/YvgvU9iJCb1TmsnBOMASGkThwwTSyn5SpJct95s
W2B5KFyfUvRopYs3uQ0V
=6eqW
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Mar_2014_21_27_39_+0000_RUw3e.UgtGNScMrd--
