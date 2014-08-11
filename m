Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaHKB5j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 21:57:39 -0400
Received: from ozlabs.org ([103.22.144.67]:34622 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbaHKB5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 21:57:37 -0400
Date: Mon, 11 Aug 2014 11:57:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>, Lee Jones <lee.jones@linaro.org>
Subject: linux-next: build failure after merge of the pm tree
Message-ID: <20140811115726.0bcf3b66@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/+JDUwDarNoGtzkfUjWIyaKJ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+JDUwDarNoGtzkfUjWIyaKJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

After merging the pm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/mfd/sec-core.c: In function 'sec_pmic_suspend':
drivers/mfd/sec-core.c:438:29: error: 'PM_SUSPEND_MEM' undeclared (first us=
e in this function)
   regulator_suspend_prepare(PM_SUSPEND_MEM);
                             ^

Caused by commit bb3274b6442d ("PM / sleep: Rename symbols, functions
and variables related to sleep") interacting with commit b7cde7078d23
("mfd: sec-core: Prepare regulators for suspend state to reduce
power-consumption") from Linus' tree.

I applied the following merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 11 Aug 2014 11:55:23 +1000
Subject: [PATCH] PM / sleep: fix for Rename symbols, functions and variable=
s related to sleep

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/mfd/sec-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index dba7e2b6f8e9..d289dc5fef66 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -435,7 +435,7 @@ static int sec_pmic_suspend(struct device *dev)
 	switch (sec_pmic->device_type) {
 	case S2MPS14X:
 	case S2MPU02:
-		regulator_suspend_prepare(PM_SUSPEND_MEM);
+		regulator_suspend_prepare(PM_SUSPEND_DEEP);
 		break;
 	default:
 		break;
--=20
2.1.0.rc1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/+JDUwDarNoGtzkfUjWIyaKJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT6CMNAAoJEMDTa8Ir7ZwV/2QP/Ryv/JmpI/Xr/N5XEPCGM9gG
tznjYnCPqyYmRenQWeesyCrXAhd7B7whJGpokayyiwn442Ibuuw0egnq1KCkbxio
52ZVm4OKDrHrBldyelb0nrXz6Ci1ePk1NJ3wF/mwCbor/q14sayBt10PHgmHYlBL
JUrtl+1Hbj7HURwy3vF5Q0SnhOPw3iSRDqyaRbdqJl1wIfugevy5BEi884pW6AFP
iXKC4f6yE8mCec32AAbATelTgpeNgGEt+GhEaZJ96WgpYhAdmpKBKt0Gmec08MBQ
HWfqIbQ0u4lWSr9Qe8EaGgEOpRYs14mjy4wrYE4Y31R8yBlBaLZHdizEA+9SUGoH
9U/xYafHwD8W+84I/HayDWyXAmVPOXcpeZrwUtjATEieMB7RD7ddjKclO83UM4US
SlfVWUVWXgj0b0iqPnvf/45R0KcBzR3fGxH33o5DH5qpZR7q8x4VN4qq/IDh99UL
i8mtITAY1RLQ8rMw9vV0Y9hmG0klcCak/AIUeeXd3DpkyYO45g+f3Gpb9mhoeltR
+xlvgJ4gLO0ryz2PlqIvyjy8HLocTEcashJwPmnzbs2lCcvVA/xs3iT4LzXySkW8
gfbEknAbOulXLDKR3MbiQSPGnJw9FKoIoivjPvVHWT6SLALomopQPfyP+d8gtYhR
Q92rO4j3Ji52GVRVG9+J
=f7e9
-----END PGP SIGNATURE-----

--Sig_/+JDUwDarNoGtzkfUjWIyaKJ--
