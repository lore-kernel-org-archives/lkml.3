Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaLUHfS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 02:35:18 -0500
Received: from ozlabs.org ([103.22.144.67]:47887 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbaLUHfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 02:35:16 -0500
Date: Sun, 21 Dec 2014 18:35:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: linux-next: manual merge of the idle tree with Linus' tree
Message-ID: <20141221183507.185b5b15@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/SaP2d4_1QrkW6a9oX6zFqDW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/SaP2d4_1QrkW6a9oX6zFqDW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Len,

Today's linux-next merge of the idle tree got a conflict in
arch/x86/include/uapi/asm/msr-index.h between commit 2f86dc4cddcb
("intel_pstate: Add support for HWP") from Linus' tree and commit
a8b65b07d753 ("tools/power turbostat: decode MSR_*_PERF_LIMIT_REASONS")
from the idle tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/include/uapi/asm/msr-index.h
index c8aa65d56027,1277934b0d5e..000000000000
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@@ -152,45 -152,10 +152,49 @@@
  #define MSR_CC6_DEMOTION_POLICY_CONFIG	0x00000668
  #define MSR_MC6_DEMOTION_POLICY_CONFIG	0x00000669
 =20
 +/* Hardware P state interface */
 +#define MSR_PPERF			0x0000064e
 +#define MSR_PERF_LIMIT_REASONS		0x0000064f
 +#define MSR_PM_ENABLE			0x00000770
 +#define MSR_HWP_CAPABILITIES		0x00000771
 +#define MSR_HWP_REQUEST_PKG		0x00000772
 +#define MSR_HWP_INTERRUPT		0x00000773
 +#define MSR_HWP_REQUEST 		0x00000774
 +#define MSR_HWP_STATUS			0x00000777
 +
 +/* CPUID.6.EAX */
 +#define HWP_BASE_BIT			(1<<7)
 +#define HWP_NOTIFICATIONS_BIT		(1<<8)
 +#define HWP_ACTIVITY_WINDOW_BIT		(1<<9)
 +#define HWP_ENERGY_PERF_PREFERENCE_BIT	(1<<10)
 +#define HWP_PACKAGE_LEVEL_REQUEST_BIT	(1<<11)
 +
 +/* IA32_HWP_CAPABILITIES */
 +#define HWP_HIGHEST_PERF(x)		(x & 0xff)
 +#define HWP_GUARANTEED_PERF(x)		((x & (0xff << 8)) >>8)
 +#define HWP_MOSTEFFICIENT_PERF(x)	((x & (0xff << 16)) >>16)
 +#define HWP_LOWEST_PERF(x)		((x & (0xff << 24)) >>24)
 +
 +/* IA32_HWP_REQUEST */
 +#define HWP_MIN_PERF(x) 		(x & 0xff)
 +#define HWP_MAX_PERF(x) 		((x & 0xff) << 8)
 +#define HWP_DESIRED_PERF(x)		((x & 0xff) << 16)
 +#define HWP_ENERGY_PERF_PREFERENCE(x)	((x & 0xff) << 24)
 +#define HWP_ACTIVITY_WINDOW(x)		((x & 0xff3) << 32)
 +#define HWP_PACKAGE_CONTROL(x)		((x & 0x1) << 42)
 +
 +/* IA32_HWP_STATUS */
 +#define HWP_GUARANTEED_CHANGE(x)	(x & 0x1)
 +#define HWP_EXCURSION_TO_MINIMUM(x)	(x & 0x4)
 +
 +/* IA32_HWP_INTERRUPT */
 +#define HWP_CHANGE_TO_GUARANTEED_INT(x)	(x & 0x1)
 +#define HWP_EXCURSION_TO_MINIMUM_INT(x)	(x & 0x2)
 +
+ #define MSR_CORE_PERF_LIMIT_REASONS	0x00000690
+ #define MSR_GFX_PERF_LIMIT_REASONS	0x000006B0
+ #define MSR_RING_PERF_LIMIT_REASONS	0x000006B1
+=20
  #define MSR_AMD64_MC0_MASK		0xc0010044
 =20
  #define MSR_IA32_MCx_CTL(x)		(MSR_IA32_MC0_CTL + 4*(x))

--Sig_/SaP2d4_1QrkW6a9oX6zFqDW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUlngwAAoJEMDTa8Ir7ZwV6+8P/2QZYH7nfWGHegnvzdeaMtXC
g+uSfgZKlTJA0nACxBs1McJu1IUSxHWcUptquKmvNvwtFsTKm9QqOeT/ZJ3NZ1X0
UrOsXF4wENIA9n+XkKSb0HDR6+tBjbcgdRRuSfVwFDOEgHSG6dFiazlGPY81Pe/i
wHXf0LaUm8TGYO8ULJRnoQzWDOWiVOcm0hytOK/Kc44rtQaYmA/DLNZayiyNd+Bh
Z2ww+y0dp7hkAP+Z33wSNrv08OfWxp6nl0wEpIyc5rieSqUlLV97loPTiDlr1cHs
G+rGYm6mZ61r0/5LfyhEOOgGghSGoVzQYus/+zf+dQot0/2lvyTHvLvzSzU3imTV
TTOahei5pOkxtw/NYyvYErayosQGTrzCEA+syhZpDkyw4Bk6PhsbOiIWhjYl/kWs
JOV/TFRosCXyd86Z7NZh9w2cDxZdqbyzQk00aTrgcETH/usDvqCQwRTpGQLv1Z/O
lchejPIR7MtkG4sZYpttfIn/hUTMQ7kPl6lbiqCPKaYZvC/TEobKQOFEEZU2TrQA
S6Xv6ScRG1MshrF7oYmBoF1+qZDolQ/TKpza9CufvIybbAJvHdEdIrxKcfzirNgC
Cn1ux3d70gjeAaNiw0d0B2K17PXy2MYy8Ft8kPSXDK7aypAAzoZMeXH/PQeup3k8
V7cvmVogjCcAmKai0i9T
=a+uQ
-----END PGP SIGNATURE-----

--Sig_/SaP2d4_1QrkW6a9oX6zFqDW--
