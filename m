Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab3LTJ3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:29:25 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:56214 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab3LTJ3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:29:22 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: David Daney <david.daney@cavium.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH] microblaze: extable: Sort the exception table at build time
Date: Fri, 20 Dec 2013 10:29:18 +0100
Message-Id: <3e05730caf4d945ac510b4657c4c4cf6f2e1b6f4.1387531751.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-17448-1387531758-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-17448-1387531758-0001

Sort the exception table at build-time rather than during boot.

Microblaze is the same case as AARCH64 that's why
EM_MICROBLAZE conditional check was added to allow
cross-compilation on machines which are not running
the latest libc-dev.

Inspired by AARCH64 commit:
"arm64: extable: sort the exception table at build time"
(sha1: adace89562c7a9645b8dc84f6e1ac7ba8756094e)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/microblaze/Kconfig | 1 +
 scripts/sortextable.c   | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index e23cccd..8d581ab 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -30,6 +30,7 @@ config MICROBLAZE
 	select MODULES_USE_ELF_RELA
 	select CLONE_BACKWARDS3
 	select CLKSRC_OF
+	select BUILDTIME_EXTABLE_SORT

 config SWAP
 	def_bool n
diff --git a/scripts/sortextable.c b/scripts/sortextable.c
index 7941fbd..cc49062 100644
--- a/scripts/sortextable.c
+++ b/scripts/sortextable.c
@@ -39,6 +39,10 @@
 #define EM_AARCH64	183
 #endif

+#ifndef EM_MICROBLAZE
+#define EM_MICROBLAZE	189
+#endif
+
 static int fd_map;	/* File descriptor for file being modified. */
 static int mmap_failed; /* Boolean flag. */
 static void *ehdr_curr; /* current ElfXX_Ehdr *  for resource cleanup */
@@ -275,6 +279,7 @@ do_file(char const *const fname)
 	case EM_ARCOMPACT:
 	case EM_ARM:
 	case EM_AARCH64:
+	case EM_MICROBLAZE:
 	case EM_MIPS:
 		break;
 	}  /* end switch */
--
1.8.2.3


--=_mimegpg-monstr-desktop-17448-1387531758-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlK0De4ACgkQykllyylKDCE/fwCgmGHyCX/9gS4AIkmRf6tL+y9b
t6UAn3uk4t29+Xn94j5xGxCL/heebcbm
=lgq1
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-17448-1387531758-0001--
