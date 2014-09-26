Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbaIZKRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:17:20 -0400
Received: from ozlabs.org ([103.22.144.67]:59633 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969AbaIZKRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:17:15 -0400
Date: Fri, 26 Sep 2014 20:17:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Oleg Nesterov <oleg@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140926201704.1e2a62c3@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/gMG+g90X5iFQ3IQMXiDcGKk"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/gMG+g90X5iFQ3IQMXiDcGKk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from arch/powerpc/kernel/asm-offsets.c:16:0:
include/linux/signal.h: In function 'sigisemptyset':
include/linux/signal.h:79:3: error: implicit declaration of function 'BUILD=
_BUG' [-Werror=3Dimplicit-function-declaration]
   BUILD_BUG();
   ^

Caused by commit 7e52cdba7e69 ("signal: use BUILD_BUG() instead of
_NSIG_WORDS_is_unsupported_size()").

See Rule 1 in Documentation/SubmitChecklist.

Thanks to Guenter for the heads up.

I have added the following patch for today (hopefully it does not cause
more problems).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 26 Sep 2014 20:08:12 +1000
Subject: [PATCH] signal.h: using BUILD_BUG requires including bug.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/signal.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/signal.h b/include/linux/signal.h
index 14acfd59ed1b..ab1e0392b5ac 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -2,6 +2,7 @@
 #define _LINUX_SIGNAL_H
=20
 #include <linux/list.h>
+#include <linux/bug.h>
 #include <uapi/linux/signal.h>
=20
 struct task_struct;
--=20
2.1.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/gMG+g90X5iFQ3IQMXiDcGKk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJT0pAAoJEMDTa8Ir7ZwVDqkP/AtQ+pkeMzbTrSqgo2zRtUHz
fLxQQzxY6QEDmsLYGjOXWaeU/WzDDx1B6SSatbkgB7uyYfrfVJ+JjwAnC0yqaOXN
MxOCZT0QTHVdoMeY/7Rc62liAoJnfGRiwwjgbKMTeQEG7jJnJQQ+q4IL+AX3BLvw
509L+QZmVrEpLSmdZ0vU4CjZCi0LJlGifBN3HjjQhR4SD63XMQj74s0lNElMZa2J
ksLhmaSKHTGzYiY5XuPIPxQ2QqY5xnAompaqFsKN2nczItIE5Cuabf4qYQb3yYKb
H4aW9OwkY5dZakk6zqusa3814eJD4UhdUbYsD5UkTQf27YEi3CwerKWP58gGqGmp
LrWR5ZVEMGh1Lpptm4vvHDxUjQfVfZNzHop9EQ2LJU1c62TDAckIEKp7lwhR54WX
FnArErzH/Gd+EGhjoadbY7IAgK5/Kda/oOqLwBluqJOeNp2QcwAWLERAtciTcJHg
K9p3SnyU1o1fI53KMvsgtB84Y14zyqjGQxDWGwYlB5XE74ha78h4I18LwkmJfyvB
/99ItvOAr4A6vz+MGVg9wxutW3THhUSlYsRsNts2zrwgMH3ye23IEPr+nbSURbNI
A8ZbbsP7T7aGeOsgexJxnLRjoEy0+GnyPWHCKMxHqeK3x4IP3fd1aN75UgwCQ4A/
eYmhSSOff8UC29W68dQG
=K6DH
-----END PGP SIGNATURE-----

--Sig_/gMG+g90X5iFQ3IQMXiDcGKk--
