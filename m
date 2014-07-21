Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaGUBNd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 21:13:33 -0400
Received: from ozlabs.org ([103.22.144.67]:56966 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbaGUBNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 21:13:31 -0400
Date: Mon, 21 Jul 2014 11:13:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: linux-next: manual merge of the samsung tree with the arm-soc tree
Message-ID: <20140721111324.1f5ed9b2@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/MZS7jU.s6FxQpJ201sZ2Efu"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/MZS7jU.s6FxQpJ201sZ2Efu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/mach-exynos/pm.c between commit 7310d99ffcd1 ("ARM: EXYNOS:
Fix build breakge with PM_SLEEP=3Dn") from the arm-soc tree and commit
66df3ce29804 ("ARM: EXYNOS: Refactored code for using PMU address via
DT") from the samsung tree.

I fixed it up (the code modified by the latter was moved by the former,
so I applied the following patch to the new file) and can carry the fix
as necessary (no action is required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 21 Jul 2014 11:11:17 +1000
Subject: [PATCH] ARM: EXYNOS: fixup for code movement

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/mach-exynos/platsmp.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 8b66a9e02b87..1e43b53d23b7 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -43,7 +43,7 @@ extern void exynos4_secondary_startup(void);
  */
 void exynos_cpu_power_down(int cpu)
 {
-	__raw_writel(0, EXYNOS_ARM_CORE_CONFIGURATION(cpu));
+	pmu_raw_writel(0, EXYNOS_ARM_CORE_CONFIGURATION(cpu));
 }
=20
 /**
@@ -54,8 +54,8 @@ void exynos_cpu_power_down(int cpu)
  */
 void exynos_cpu_power_up(int cpu)
 {
-	__raw_writel(S5P_CORE_LOCAL_PWR_EN,
-		     EXYNOS_ARM_CORE_CONFIGURATION(cpu));
+	pmu_raw_writel(S5P_CORE_LOCAL_PWR_EN,
+		       EXYNOS_ARM_CORE_CONFIGURATION(cpu));
 }
=20
 /**
@@ -65,7 +65,7 @@ void exynos_cpu_power_up(int cpu)
  */
 int exynos_cpu_power_state(int cpu)
 {
-	return (__raw_readl(EXYNOS_ARM_CORE_STATUS(cpu)) &
+	return (pmu_raw_readl(EXYNOS_ARM_CORE_STATUS(cpu)) &
 			S5P_CORE_LOCAL_PWR_EN);
 }
=20
@@ -75,7 +75,7 @@ int exynos_cpu_power_state(int cpu)
  */
 void exynos_cluster_power_down(int cluster)
 {
-	__raw_writel(0, EXYNOS_COMMON_CONFIGURATION(cluster));
+	pmu_raw_writel(0, EXYNOS_COMMON_CONFIGURATION(cluster));
 }
=20
 /**
@@ -84,8 +84,8 @@ void exynos_cluster_power_down(int cluster)
  */
 void exynos_cluster_power_up(int cluster)
 {
-	__raw_writel(S5P_CORE_LOCAL_PWR_EN,
-		     EXYNOS_COMMON_CONFIGURATION(cluster));
+	pmu_raw_writel(S5P_CORE_LOCAL_PWR_EN,
+		       EXYNOS_COMMON_CONFIGURATION(cluster));
 }
=20
 /**
@@ -95,7 +95,7 @@ void exynos_cluster_power_up(int cluster)
  */
 int exynos_cluster_power_state(int cluster)
 {
-	return (__raw_readl(EXYNOS_COMMON_STATUS(cluster)) &
+	return (pmu_raw_readl(EXYNOS_COMMON_STATUS(cluster)) &
 			S5P_CORE_LOCAL_PWR_EN);
 }
=20
--=20
2.0.1


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/MZS7jU.s6FxQpJ201sZ2Efu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTzGk4AAoJEMDTa8Ir7ZwVUyQP/RoG1m65PgppU2Nu9mYXOVGj
m6y64H3ROROozhSRPmhQfK6Tv+00voKSViG8KQYhRBQxl9thsVFCxMbSAtJfJLGA
pf/+gHxnvwhum2k+vspo3RXN+0SxEE4p59/plH6Z7I4l/S2TlOBJhLMKps+SDvVW
NlZtuMGPvDD4ctC1Edu5Xar0riz7NjmJGm58uRNPCreXRxl9GN12MwEw/ZkmM86F
6R7xSRwRx18KI0F0QEGiGfsmEqWVRl8a0fQaH3uKCcQWOlmF6JUApV45gIXWe8y2
V98udjKxsFWwjerbcbc3SWypHqBG2KTp2jJEkWp7sgLaAgmBeHP5q8f2zxBcKeUf
zjgonW8tmWUpyPYOeBdKc5x6ZZtcGy3OZ7qDAfpWIJ+YfYkNHOOA8J3aSHzLLekS
316Ecs/IWmj2iXKZeJQmrTrv1XR3nr6CmBkdhMDu5HjiZPXuZOjnlUH3vgehf2Jh
TC2KhITqvNl/kFQJzUArGnbnZ2z5R1P0jtgQer9T1jvK9MofGxBPOLnSeRKOm9Pi
zyFm0pOUvz/PnVCV5DBOxPDsz+b4AOIGqnqXDJ0Rwx+OSzv0AU/OsaQNYx5kH7h9
NBI/eS4NfTQIlFqyCZCCX0eCbzr5+vcm7IwYfOQssGQzQC0A4v/sCoo+XynzHbYQ
3JyuJ1MLIJWXluMr1rYo
=m3EI
-----END PGP SIGNATURE-----

--Sig_/MZS7jU.s6FxQpJ201sZ2Efu--
