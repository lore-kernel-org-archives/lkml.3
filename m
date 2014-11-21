Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbaKUHcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 02:32:25 -0500
Received: from ozlabs.org ([103.22.144.67]:34891 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaKUHcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 02:32:24 -0500
Date: Fri, 21 Nov 2014 18:32:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the ftrace tree
Message-ID: <20141121183215.01ba539c@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/=l/SYqixE/14n+ZYwuCFLgB"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=l/SYqixE/14n+ZYwuCFLgB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Steven,

After merging the ftrace tree, today's linux-next build (powerpc
allnoconfig) failed like this:

In file included from include/asm-generic/percpu.h:6:0,
                 from arch/powerpc/include/asm/percpu.h:19,
                 from include/linux/percpu.h:11,
                 from include/linux/sched.h:41,
                 from arch/powerpc/kernel/asm-offsets.c:17:
include/linux/percpu.h:138:17: error: 'printk_func_t' undeclared here (not =
in a function)
 DECLARE_PER_CPU(printk_func_t, printk_func);
                 ^
include/linux/percpu-defs.h:101:38: note: in definition of macro 'DECLARE_P=
ER_CPU_SECTION'
  extern __PCPU_ATTRS(sec) __typeof__(type) name
                                      ^
include/linux/percpu.h:138:1: note: in expansion of macro 'DECLARE_PER_CPU'
 DECLARE_PER_CPU(printk_func_t, printk_func);
 ^

Caused by commit afdc34a3d3b8 ("printk: Add per_cpu printk func to
allow printk to be diverted").  See Rule 1 in
Documentation/SubmitChecklist.

I reverted that commit (and the following one (a9edc8809328 "x86/nmi:
Perform a safe NMI stack trace on all CPUs" in case it depended in it)
for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/=l/SYqixE/14n+ZYwuCFLgB
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUbuqEAAoJEMDTa8Ir7ZwVw98P/RKPazRd2D+pGrcBbRLO3Qt3
+4D8FKw6lehjmLT5q0jAMkN9LGwKN1fCclrwCVpAOrLT6gf0x3El7Z2z6LrDkulZ
vcQzTDqAQ4n2Xq6JjCU/gJR5qqdq42exP+Dn0qmYU8Zc+qICoqE8AjKKGIhILljQ
oOhDwthN6ZYKs6VNxikj3CxogMLf9ZUPtP/qNu51sdQ0P1Mi+rxnA9WdiF1YT0fZ
VhEMu+O7xQGUPA64UwhA0cpjAOp/8v36OjjnvEKhS8Ivg0PUML9mkCntlCQ7kdXP
/8pbcUXovdlAbU0iJwCJ6lqj4mj9E0zN//U6PS6S13tV4hhCFnVZ4rBmKptXVtO5
t5CgRieTss9kouPd0YskwQUiIoHWWLki3E6fUpNML59i9Ud32+5J0ilo6D/xGe++
yRv2DdLBPEGi92uFF7E3CfyWK8U+Yg/Ao7jSZwrZCAUJdRH7th6nfWs70uQfdFH+
05N492BLS/TYR6yqQKFdZZ+rSyjQ6SVDEZUWk3AEPnZJ2lacQg4NUH6SboZr7lhr
NO+LBEH+Dy9OcnFRBVsPt8497CjLljFYaaAxuib969Mf6hTk5/yMmCSn6bWXqMTm
5NJbC6uUQ8yn8ylboQBNiZC0f1WTlckWrECnVjkXCsf1vlKlfz8QQE2h7fOAr6Uv
eCJiKycPuS9/ia/uMafS
=Qf0V
-----END PGP SIGNATURE-----

--Sig_/=l/SYqixE/14n+ZYwuCFLgB--
