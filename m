Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaJ0IYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 04:24:55 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:48996 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaJ0IYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 04:24:53 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 3/3] microblaze: Wire up bpf syscall
Date: Mon, 27 Oct 2014 09:24:35 +0100
Message-Id: <802f4db7e2e75ed94f8e5b266c562755728a1423.1414398260.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <4cbbbb43d666468d87f99676cf05fb5154d1228b.1414398260.git.michal.simek@xilinx.com>
References: <4cbbbb43d666468d87f99676cf05fb5154d1228b.1414398260.git.michal.simek@xilinx.com>
In-Reply-To: <4cbbbb43d666468d87f99676cf05fb5154d1228b.1414398260.git.michal.simek@xilinx.com>
References: <4cbbbb43d666468d87f99676cf05fb5154d1228b.1414398260.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-25740-1414398288-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-25740-1414398288-0001

Add new bpf syscall.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/microblaze/include/asm/unistd.h      | 2 +-
 arch/microblaze/include/uapi/asm/unistd.h | 1 +
 arch/microblaze/kernel/syscall_table.S    | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/microblaze/include/asm/unistd.h b/arch/microblaze/include/asm/unistd.h
index ea4b233647c1..0a53362d5548 100644
--- a/arch/microblaze/include/asm/unistd.h
+++ b/arch/microblaze/include/asm/unistd.h
@@ -38,6 +38,6 @@

 #endif /* __ASSEMBLY__ */

-#define __NR_syscalls         387
+#define __NR_syscalls         388

 #endif /* _ASM_MICROBLAZE_UNISTD_H */
diff --git a/arch/microblaze/include/uapi/asm/unistd.h b/arch/microblaze/include/uapi/asm/unistd.h
index 1c2380bf8fe6..c712677f8a2a 100644
--- a/arch/microblaze/include/uapi/asm/unistd.h
+++ b/arch/microblaze/include/uapi/asm/unistd.h
@@ -402,5 +402,6 @@
 #define __NR_seccomp		384
 #define __NR_getrandom		385
 #define __NR_memfd_create	386
+#define __NR_bpf		387

 #endif /* _UAPI_ASM_MICROBLAZE_UNISTD_H */
diff --git a/arch/microblaze/kernel/syscall_table.S b/arch/microblaze/kernel/syscall_table.S
index de59ee1d7010..0166e890486c 100644
--- a/arch/microblaze/kernel/syscall_table.S
+++ b/arch/microblaze/kernel/syscall_table.S
@@ -387,3 +387,4 @@ ENTRY(sys_call_table)
 	.long sys_seccomp
 	.long sys_getrandom		/* 385 */
 	.long sys_memfd_create
+	.long sys_bpf
--
1.8.2.3


--=_mimegpg-monstr-desktop-25740-1414398288-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlROAVAACgkQykllyylKDCFoBgCginWc6/NDjsjEYFb+YOeu2BFp
t7cAoIPhJ5xQTyje3JMMC9CwmCpXHoUT
=THMX
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-25740-1414398288-0001--
