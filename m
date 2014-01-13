Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbaAMD3v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 22:29:51 -0500
Received: from ozlabs.org ([203.10.76.45]:59606 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbaAMD3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 22:29:48 -0500
Date: Mon, 13 Jan 2014 14:29:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>, Borislav Petkov <bp@suse.de>
Subject: linux-next: manual merge of the tip tree with the pm tree
Message-Id: <20140113142939.402b0033cdbc43efe7382ac9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Jan_2014_14_29_39_+1100_qSrAFKQosROUC=uW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Jan_2014_14_29_39_+1100_qSrAFKQosROUC=uW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
drivers/acpi/apei/einj.c between commit 8b48463f8942 ("ACPI: Clean up
inclusions of ACPI header files") from the pm tree and commit
d3ab3edc029b ("ACPI, APEI: Cleanup alignment-aware accesses") from the
tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/acpi/apei/einj.c
index ca0c6d7ec0d4,7dcc8a824aae..000000000000
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@@ -33,6 -33,8 +33,7 @@@
  #include <linux/nmi.h>
  #include <linux/delay.h>
  #include <linux/mm.h>
 -#include <acpi/acpi.h>
+ #include <asm/unaligned.h>
 =20
  #include "apei-internal.h"
 =20

--Signature=_Mon__13_Jan_2014_14_29_39_+1100_qSrAFKQosROUC=uW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS012nAAoJEMDTa8Ir7ZwVHv4P/37HxlG45tsYJGqrf4jLzTrP
Mo+0THvYAVvgiOitY9SAN9ZaWpIf95YmB0tn0ZPc3925gliQif7g/76iXSSfir/6
v5XzobSuZM07/5mHd7wDhS033Yr4LoSny5vlRRakHMDAeEtDjeaebUKygSt8LxFc
jNgVLtSZwjvJnxM+S6Vw5tmecNRhZZZT9fGuxWCQYk2Jlr+/6NuZuccUdKbxcZR2
ufH5nP7cwMjGLWLv5IyTJ2cTM8dkDfZ6mcMiz0ecafh5hqwOKTL4Tyrl/TJCbTn3
3SqR16VgLuBnvxTlm0Yi/wAbGALiIikTnbY9q3OOO3MM5/BKfUHm6Cd8ytkqFASv
3KNgkqHR+Vw89BqHDCA9oY2zE1GK9JUDgJObhjAwIDWrD4CVtKu8KbGETZYc0dlL
5z8oEr1HuPYIHpvs8ngdUddErEcudtd4NJvcmhoagLQ0uc/9OideSZ/O/0SlFw67
fiSlTp7ICqlrhU8RqxuMLBzYHXbjk+/fAIOIE1QaiHvQS9ojs5SnkL8vj8Fe6cBI
Jkpp/FUH/+hK+77XwrvRmGWLSAl6lfFNiBGklZqyTtxNfT4648RYA1uDFhYFbgTq
qKiHsZP45BbM4HKYQfWpIkeILUN69SRTWXfJ7MH1NPBRIfDSXV1PSL/QIX5RMFd7
sJIn2XpH4rbBmdM+Q3fG
=eVOw
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Jan_2014_14_29_39_+1100_qSrAFKQosROUC=uW--
