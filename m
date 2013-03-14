Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539Ab3CNCbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 22:31:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42444 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932968Ab3CNCbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 22:31:43 -0400
Date: Thu, 14 Mar 2013 13:31:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: linux-next: manual merge of the cgroup tree with Linus' tree
Message-Id: <20130314133134.7b41b67f8ebc566af5c3cfd8@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__14_Mar_2013_13_31_34_+1100_7v8Ka.i9nz7_Gsyq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_Mar_2013_13_31_34_+1100_7v8Ka.i9nz7_Gsyq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the cgroup tree got a conflict in
include/linux/res_counter.h between commit ebf47beb660e
("include/linux/res_counter.h needs errno.h") from Linus' tree and commit
9259826ccb81 ("res_counter: remove include of cgroup.h from
res_counter.h") from the cgroup tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/res_counter.h
index c230994,a83a849..0000000
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@@ -13,8 -13,7 +13,8 @@@
   * info about what this counter is.
   */
 =20
- #include <linux/cgroup.h>
 +#include <linux/errno.h>
+ #include <linux/spinlock.h>
 =20
  /*
   * The core object. the cgroup that wishes to account for some

--Signature=_Thu__14_Mar_2013_13_31_34_+1100_7v8Ka.i9nz7_Gsyq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRQTaGAAoJEECxmPOUX5FE6X8P/R9E9rks8eOb/QpmuigY5cSn
GXRvoFa+yvBC1/9K174OPXiXcHOPG4n4zDD9qGlUYBsInMkIkLMdoTOdN1r2pDw2
jvdHixO5iGeWm3qoqa42LBSJgw0FBA9bNf1vQvPnAXn/MIdZd5wegizSrTo07wLm
AGofaqmTwlZeUtcgEJJhe+b9Kvabeo1sf7bkZCprC+opdFvNNCRbVOlFtykA5y5N
ptO50yBIkwkJk1UzFnZsdk5AlMo7MOUiTtSBrJ+DBAlIPrJ92ARrKXWwuL0dgzEN
JwHkzsnqchuPprqvZrBtwX1VcPGxnYUisNJE8Ysq0xniYHWGBacgN98qRBW0vGUG
aruky/NMWEA3PDOWkocv8tkHCCYzPJC3SRtzGlcPousAK9zBiJcsr/FgdRHVwZX8
6CBNtLOFNAtRWY0nYacyGeulsZYngF7+DtxsUrEUcTeNVtHzECATEDOlaGD03L0Z
r0WW84HORkDvoRZrt647zvmfL4W+HDtX2NO5V1D7zFpnmIcch1ydGPvMmtPyJJxk
JmQiNM4lRQ6dGqXYr/ztHdNc7NUso0R/6lD1rhjJ3lnV0QTZ3OMOQ9vloFw6gJ7k
3/k88Cfool3gn7/dQ3QI0V3c9/1rQDycXW63cclD01XODkKLAOEZv/Htm/2buYSj
+qNUV0nOMAA1qxWJzHvc
=1sNY
-----END PGP SIGNATURE-----

--Signature=_Thu__14_Mar_2013_13_31_34_+1100_7v8Ka.i9nz7_Gsyq--
