Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab3BNCab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 21:30:31 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52024 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3BNCaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 21:30:30 -0500
Date: Thu, 14 Feb 2013 13:30:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Clark Williams <williams@redhat.com>
Subject: linux-next: build failure after merge of the tip tree
Message-Id: <20130214133016.94f67186e65534b58d81cbc4@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__14_Feb_2013_13_30_16_+1100_+tvQ6.723uTzUf+I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_Feb_2013_13_30_16_+1100_+tvQ6.723uTzUf+I
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/thermal/intel_powerclamp.c: In function 'clamp_thread':
drivers/thermal/intel_powerclamp.c:360:21: error: 'MAX_USER_RT_PRIO' undecl=
ared (first use in this function)

Caused by commit 8bd75c77b7c6 ("sched/rt: Move rt specific bits into new
header file") interacting with commit d6d71ee4a14a ("PM: Introduce Intel
PowerClamp Driver") from the thermal tree.

I applied this merge fix patch and can carry it as necessary:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 14 Feb 2013 13:26:22 +1100
Subject: [PATCH] sched/rt: fix PowerClamp Driver for define move

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/thermal/intel_powerclamp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_pow=
erclamp.c
index ab3ed90..b40b37c 100644
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -50,6 +50,7 @@
 #include <linux/tick.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/sched/rt.h>
=20
 #include <asm/nmi.h>
 #include <asm/msr.h>
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__14_Feb_2013_13_30_16_+1100_+tvQ6.723uTzUf+I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRHEw4AAoJEECxmPOUX5FETboP/R7bqRGwoGjhcgWG+5/UpbmG
mYqmlnYVacVwnbfjTzVTL2269aVzOnsiUNPcS1nNYtYO+22KUSTttz5wuke8EhR0
/ZC1aHrSYVrRRxqOTgTZ/lqBG8PnJwWQ6ArdahrHsfW4k5r9lHlqAgOVCMhlqsxb
4Jhe37O4aJJq24gBt5v4w44MoYXXQUhVDjw1QYhR0dmIN6Qd5/5g9MBVEeqWRQ+p
+QxZSI6rRU8ZWaIk1ifvKJHtB+bdjmvvKtFowW0WfhqRCat+M5Gdoge/Q9GFqarO
Dzh8VRwOchzxvlh/0HhfzWvDQQm+lF8CMn/pgsJveONed+w1rUwTsKyfXwTI1qQm
u3LboYOSthwAMEDLW/t4RkiOrgEtfK8WGf+CjDbZYguqo4Zj4sh6u2CJbYwxYFfb
mMikyQwfKNwsHbUkRO7q6eXCAteIPDaWmNR5No/Utoob2FHteaHp6hGwBbLcyINs
F0hOp8q/MncCsyIzdaDpArNCtBmnbFMQ98PMkD/3TjeW3LIta4QNpLmFz09NsNnO
blrul3hQR7eeoxNWkCPR1+vMkzexK/mwf/KYga8jkZWvOKzdSi4Ffw2PdqFuMQL/
Un5kpga7UeBEYjjJpABwagaXei+efbVvRHoy2Sbu0WmZtJxkQSXfR7dazTTInE8J
ZgZ65buLZgF4uU2w4X8g
=Dr6a
-----END PGP SIGNATURE-----

--Signature=_Thu__14_Feb_2013_13_30_16_+1100_+tvQ6.723uTzUf+I--
