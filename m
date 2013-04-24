Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab3DXGyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 02:54:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49278 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab3DXGyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 02:54:35 -0400
Date: Wed, 24 Apr 2013 16:54:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the arm-soc tree with the pm tree
Message-Id: <20130424165417.5e2b74a01728d307e454750f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__24_Apr_2013_16_54_17_+1000_UA1H24tUC++inY5o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Apr_2013_16_54_17_+1000_UA1H24tUC++inY5o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-exynos/cpuidle.c between commit 554c06ba3ee2 ("cpuidle:
remove en_core_tk_irqen flag") from the pm tree and commit 2eb89f893e44
("ARM: EXYNOS: factor out the idle states") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos/cpuidle.c
index 498a7a2,e2689d1..0000000
--- a/arch/arm/mach-exynos/cpuidle.c
+++ b/arch/arm/mach-exynos/cpuidle.c
@@@ -58,6 -46,20 +46,19 @@@ static DEFINE_PER_CPU(struct cpuidle_de
  static struct cpuidle_driver exynos4_idle_driver =3D {
  	.name			=3D "exynos4_idle",
  	.owner			=3D THIS_MODULE,
 -	.en_core_tk_irqen	=3D 1,
+ 	.states =3D {
+ 		[0] =3D ARM_CPUIDLE_WFI_STATE,
+ 		[1] =3D {
+ 			.enter			=3D exynos4_enter_lowpower,
+ 			.exit_latency		=3D 300,
+ 			.target_residency	=3D 100000,
+ 			.flags			=3D CPUIDLE_FLAG_TIME_VALID,
+ 			.name			=3D "C1",
+ 			.desc			=3D "ARM power down",
+ 		},
+ 	},
+ 	.state_count =3D 2,
+ 	.safe_state_index =3D 0,
  };
 =20
  /* Ext-GIC nIRQ/nFIQ is the only wakeup source in AFTR */

--Signature=_Wed__24_Apr_2013_16_54_17_+1000_UA1H24tUC++inY5o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRd4GaAAoJEECxmPOUX5FEG9sP/ioBSdWL5rRbODMUJYOgin83
PZe5KJyxe/g0ETkye92U8y62Z2QxhsTnFPXb7vEe8FrErHHC//6TihKZcGFEQLrt
9nd8Ymg3uKY4u7fnMEnUF8oVy16IXzrsFBrlZcUnrgwVsNVGnFwG56tgKcycxkhU
vg/hxe57YTGLNs9x5ZW0wbdbmAIqIST8IJ5BBmUgMcE5UQmulMJiqHC41KYrzHoy
E0Ct5NrxlQ0VEVB+4JVhdV6wKLIhIu/vWowD5spMqCeOJPj5NoZsvmGSu6xt0r9R
sHdI1GyVAh2fdWuNjhZa+fc8VFpXPUslkpunTDt57do3Yptpal6fj9/VrBZWt6n4
hNhqh4+G3z8DC180MIkqM12VOrRQS4rKLZUnJcNkWovrIezvK9bUXs/rWcVdinDB
mT1yb23GLjWLM9u9+6+7PpdR+++QyjER5T26LbeDG95Y+fZshAWgpqiO2+SkO0FQ
z/HVMQD+y8we8U8FLzU7NoMa5OXdfUBV178mA03QcyIMUS1Ausb++MY7chj7DhaN
x9DHcL8SnpCGi7r1mzNFZRtF6PqGOoY0A5VVk9eGvUTA+E/9D7cdb2n3z5T+ssJQ
ZHr+eXh6fqDBi4tggI9eMakDDV+UQkivqb3W9KCEu4Ds/EHYReM8pKT5gHsES4IO
MSRABVN87AdJWCpWd3jq
=5r28
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Apr_2013_16_54_17_+1000_UA1H24tUC++inY5o--
