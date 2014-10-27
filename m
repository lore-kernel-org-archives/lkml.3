Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113AbaJ0EbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 00:31:08 -0400
Received: from ozlabs.org ([103.22.144.67]:47067 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbaJ0EbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 00:31:06 -0400
Date: Mon, 27 Oct 2014 15:30:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20141027153057.791696a8@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.0 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/geKQCoCh2OQJq8hKyjrmm2C"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/geKQCoCh2OQJq8hKyjrmm2C
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

mm/cma.c: In function 'cma_declare_contiguous':
mm/cma.c:288:4: error: implicit declaration of function 'phys_to_virt' [-We=
rror=3Dimplicit-function-declaration]
    kmemleak_ignore(phys_to_virt(addr));
    ^

Caused by commit 2a70e5a78672 ("mm/cma: ake kmemleak ignore CMA regions").

I added the following fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 27 Oct 2014 15:25:09 +1100
Subject: [PATCH] mm/cma: include linux/io.h for phys_to_virt()

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/cma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/cma.c b/mm/cma.c
index 471fcfef043b..c22d7a8e0e3b 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -33,6 +33,7 @@
 #include <linux/log2.h>
 #include <linux/cma.h>
 #include <linux/highmem.h>
+#include <linux/io.h>
=20
 struct cma {
 	unsigned long	base_pfn;

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/geKQCoCh2OQJq8hKyjrmm2C
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUTcqGAAoJEMDTa8Ir7ZwVr4gQAIx97MMuyZrSOg8ZRrAYj4zp
eeJ1F7pafdD6BU4RbOXvu7MbajstxXGoQAMuSi2pnG0lUYF4a9ngXtTAjaRrxqGd
GuJT80Rd3I6uCe13o36X++Jg7OftKdkh74raMbFUcYDvj5MRap3jrMsHV6Sxrw8D
tYniv8Jo/cCvnRoD4nDgtwcnWI8R6tJfTf1XHvnfY5wrBHIyFpD2KhLqfHHOcflA
O3O0JB9ojavj0ShgHud+ZlO7VGzsEXuPrVakEmT1skRhIHILPLbsD/H0asI3CCR7
be3K/dmiZx4vYAmBGxgt/ff/n8Ylb90BAhAH3D/OYoLb6W4MVfZEDIKHgfhJeva1
DL/My9M98YzbMqpCyxKrTG4d9nBZ83DpT2Sw2ePHSNjq0fQTU8tmoFdt/dTRZ11W
i4iykNSCUBFW6JokLJ1W7haJIo4wnClafk3rBC8BBGk4PF4mQ1ZgbwbmpaaATdDG
0fB3suFaVo2ckbYz1tadEaLPxipfsaibmgAAoWZsMxUewPe2k2APH+X6N6nvQECk
Qv+MLop/Jc+/wj6ARpDhwO0UiALcsD/Tta/uyzOLRTQb5hz+07B6/Z9AGIEvBf+6
dpRzS/hWF86rs1B3SlOoYDp7FAbzR6xt28zHXwVKn8yhctcw2EUaBfR61+9dCw95
qqJcrbfSUMopCXxUEq62
=irr1
-----END PGP SIGNATURE-----

--Sig_/geKQCoCh2OQJq8hKyjrmm2C--
