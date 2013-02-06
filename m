Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab3BFHau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 02:30:50 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53107 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab3BFHas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 02:30:48 -0500
Date: Wed, 6 Feb 2013 18:30:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20130206183040.ea07a2cd64200b6d37868036@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__6_Feb_2013_18_30_40_+1100_O0U2ALC5WZCNNn0p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Feb_2013_18_30_40_+1100_O0U2ALC5WZCNNn0p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc defconfig)
failed like this:

arch/sparc/kernel/kgdb_32.c: In function 'sleeping_thread_to_gdb_regs':
arch/sparc/kernel/kgdb_32.c:46:9: error: implicit declaration of function '=
task_thread_info' [-Werror=3Dimplicit-function-declaration]
arch/sparc/kernel/kgdb_32.c:46:26: error: initialization makes pointer from=
 integer without a cast [-Werror]

I can only imagine that the implicit include of linux/sched.h got removed
in one of our include file changes. :-(

I have added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 6 Feb 2013 18:26:51 +1100
Subject: [PATCH] sparc: explicitly include sched.h to get task_thread_info =
declaration

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/kernel/kgdb_32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/kernel/kgdb_32.c b/arch/sparc/kernel/kgdb_32.c
index 2e424a5..dcf2108 100644
--- a/arch/sparc/kernel/kgdb_32.c
+++ b/arch/sparc/kernel/kgdb_32.c
@@ -5,6 +5,7 @@
=20
 #include <linux/kgdb.h>
 #include <linux/kdebug.h>
+#include <linux/sched.h>
=20
 #include <asm/kdebug.h>
 #include <asm/ptrace.h>
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__6_Feb_2013_18_30_40_+1100_O0U2ALC5WZCNNn0p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJREgagAAoJEECxmPOUX5FE+pkQAIIzJTAL4SKsFPqIV7BGy3aP
WK11j886CumZOOx6SpL3s2bZLTXCg2qbeBRBBjT5cNivv6aQ+dGgLvRiDdn7zcT2
0zcItNygurTisYZqooUGTnv3VEt1ivrtvDAjQZmacAsEwa//BZi5XHEGzHJ070/t
h7FoLdwfd6qcafd/8SGQ5MyaLSLdqKahdKsyNCLT+FhFeqpwW/t4NauKoTiq+f1L
V4b4v8TGiRhHSCJdkrVIpzMu6Z0obFhxTLMJilDzM+qKLF4b3wqiHlswWljYmTOZ
PRU/r9oFY0+q7xmRxB/4GlXO8JXKsk0/gHdWWuagztqw98lJWAVW4o533JeSBLTP
lJ8sf+EL97FYA4PJcpiFs/bOgqzpS5tc5WDMn8BeIGDXRUnIvKiC0bi2ocA4DEB0
KcS9JGhAMf7+dmWzq63fnncJAYMWIZ13wncszmarHAF/TBaDwRzu4m3jp4L8LlUV
b2JmZjf+HVwnucczT9p4ahMPhjD7ruR0XAPZshuesB6czS40OtZVgnzFRfs+beHu
cu/bYs1MTf8396EdN56JAi9UQh4LMO767dDaP05B51tij3WrK/BZS0ytgS9S2GG4
w4bjqYO0UXTWbCm3w9d9s3TxBYMSLhrl8wdIgQRgz8j+I6NVaCQKjMPFHswfDK5B
fGTeEsuPMjDXBXzAJYU5
=6WJK
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Feb_2013_18_30_40_+1100_O0U2ALC5WZCNNn0p--
