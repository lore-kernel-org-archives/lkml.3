Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbaC1Duh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 23:50:37 -0400
Received: from ozlabs.org ([203.10.76.45]:55424 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242AbaC1Duf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 23:50:35 -0400
Date: Fri, 28 Mar 2014 14:50:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: linux-next: manual merge of the tip tree with the arm-soc tree
Message-Id: <20140328145027.fef73dc688be565c6a6e9210@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__28_Mar_2014_14_50_27_+1100_YUwt46VaipQ_Z1.M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Mar_2014_14_50_27_+1100_YUwt46VaipQ_Z1.M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/arm/mach-zynq/common.c between commit 016f4dcae81e ("ARM: zynq:
Split slcr in two parts") from the arm-soc tree and commit cd325295871f
("arm: zynq: Add support for cpufreq") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-zynq/common.c
index dca60d5ba756,a39be8e80856..000000000000
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@@ -73,8 -74,7 +75,9 @@@ static void __init zynq_init_machine(vo
  	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 =20
  	platform_device_register(&zynq_cpuidle_device);
+ 	platform_device_register_full(&devinfo);
 +
 +	zynq_slcr_init();
  }
 =20
  static void __init zynq_timer_init(void)

--Signature=_Fri__28_Mar_2014_14_50_27_+1100_YUwt46VaipQ_Z1.M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTNPGIAAoJEMDTa8Ir7ZwVy64P/3P2YXAyAOjC2w9ZEgKV5IcG
roOgpASjb9mQztSbESUSuG7hwqjAj0Kx2YIi5eTsz9Qk88IVlIqd2asWU0VUROVB
MgZezXzw4HxxrwoU9sp8BXxwSJQH89sFPUNRgK33roxRnYDZoDUF3RlsbzfkPQ1a
t4W+xVpFanuTDesPLjqh5CA8+CGt4QAV8t5dJ1k3Ge6hOHrWkTt5SZs7XoT3+sfy
zXSCLod1Y2pq/K7x6pjtf385NvVbwWwGXzbfEoG13vLWOjw3Uasz4axnifhcWgSq
pTblDiC5joXKX7UfPYEkuur2x9WwfRHAtMwR+pOsbSDGbh/w8/g2mILCcS14K/wn
hu8eZT8b0F7WMHVcsEZe8fGOUE16Y01k06nEZqlsXdmwFjt9sGFuG05gi8rDKSoY
dTPwV5qz4bzwSm7rUzDkvnZaxG6+QeMITa/O3XrIq5HaeP8jLmtUHFnoc4Y8dElC
yAvdpQFlKTBpiWEtsvkvMyIVRjGNzSSH/Tv8d4EsTABIXqTWINnxxCYAXhvHiXqU
/ma4Uaprr3UYy98ZmOcFzDV8QbMuU3I8r6SigK3naqE5bBN4/vc9fliPAqVPaejp
nVEeHMHwetuxT6mADDK4bB7KFZAsVwH4DCvDqUuBrdmBoTLYEXx2CWvL/kCEtCps
cThp0SUnKhoFU0GYAzhD
=UAXs
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Mar_2014_14_50_27_+1100_YUwt46VaipQ_Z1.M--
