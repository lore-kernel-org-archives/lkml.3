Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaKQByx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 20:54:53 -0500
Received: from ozlabs.org ([103.22.144.67]:46934 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbaKQByw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 20:54:52 -0500
Date: Mon, 17 Nov 2014 12:54:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: linux-next: manual merge of the idle tree with the pm tree
Message-ID: <20141117125445.110f0321@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/NYqV+6DOkIGiGNDMxWMXGmI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/NYqV+6DOkIGiGNDMxWMXGmI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Len,

Today's linux-next merge of the idle tree got a conflict in
arch/x86/include/uapi/asm/msr-index.h between commit 2f86dc4cddcb
("intel_pstate: Add support for HWP") from the pm tree and commit
a8b65b07d753 ("tools/power turbostat: decode MSR_*_PERF_LIMIT_REASONS")
from the idle tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/include/uapi/asm/msr-index.h
index 62838e54947d,c1cb18be540e..000000000000
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@@ -149,48 -149,10 +149,52 @@@
 =20
  #define MSR_CORE_C1_RES			0x00000660
 =20
 +#define MSR_CC6_DEMOTION_POLICY_CONFIG	0x00000668
 +#define MSR_MC6_DEMOTION_POLICY_CONFIG	0x00000669
 +
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

--Sig_/NYqV+6DOkIGiGNDMxWMXGmI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUaVVpAAoJEMDTa8Ir7ZwVD0cQAIK7+yjhPNBZjiQ9bd9OCrN/
qRlCSNEJNUhyoZb7WVfy+2yML/fVhJG2CFARZ1c8zNX+X0kLjf+XwQe8i7i9lTCC
uJKhGa0MDw1vOJqdBM0eYu8b2k4WN53aivUFfs1cp8p7zFeC17wcew50vRe2f2Yr
6bwvWNva2qJkImwk92AVcUIiUbdjUDDeXTUUP2m2WGJSiVZ8JZbdjQWex5V4p6LQ
cjBc93Ypqt5BtVNjpQ02Cis2ujWjkmDc3aVUgAlazur5/gXSpzpUlmwTwWXV3Vvv
PCY0qF91rExNUqjAus45IuLp9fQxmOMDePY89cwVQ6DoW7ITYeHBUv/IKycTqYcr
xnkWT3NlZBiK/coFzQaqhwlF0uOe06WZ5uBX9qySknvcwVtoOuAOA/kitVT/Y3h2
5yS0RTU0lPq0ZL5r/sf4lEePFE82wQHaPeRfOgYWWKf2hlshsbto8uUA+nkREE/M
OEBwJ8Gohh1XHuQ0p6vJP1mYfi2Us5OkmAcIZzdsY1lGw+84oBvWXrL4e8L3UoD8
2YITjOpxaT4i8l3BavV+EAeAvdByqtK+7Aq7zN4jei9xFLexQOLKgW4ESvMDPqI8
xzSy5epap47ujVc5s8w1WezJdrz8YMsuDAMRDFdttZ3IMXKEp+JY0HdptMnmJyOQ
b040PWH1VARDIFC+ZDpz
=ICtC
-----END PGP SIGNATURE-----

--Sig_/NYqV+6DOkIGiGNDMxWMXGmI--
