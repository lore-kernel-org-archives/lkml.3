Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab3APDK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 22:10:27 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56459 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab3APDKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 22:10:25 -0500
Date: Wed, 16 Jan 2013 14:10:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the tegra tree with the arm-soc tree
Message-Id: <20130116141016.a831f6d246b0f038c4afab98@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_Jan_2013_14_10_16_+1100_z4.wSPV9ar.GaI.h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Jan_2013_14_10_16_+1100_z4.wSPV9ar.GaI.h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
arch/arm/mach-tegra/board-dt-tegra20.c between commit 1d5cc604f42f ("ARM:
remove mach .handle_irq for GIC users") from the arm-soc tree and commit
ac0fd9eca3ba ("ARM: tegra: move timer.c to drivers/clocksource/") from
the tegra tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/board-dt-tegra20.c
index 5ed81bab,171ba3c..0000000
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@@ -200,7 -203,8 +201,7 @@@ DT_MACHINE_START(TEGRA_DT, "nVidia Tegr
  	.smp		=3D smp_ops(tegra_smp_ops),
  	.init_early	=3D tegra20_init_early,
  	.init_irq	=3D tegra_dt_init_irq,
- 	.init_time	=3D tegra_init_timer,
 -	.handle_irq	=3D gic_handle_irq,
+ 	.init_time	=3D clocksource_of_init,
  	.init_machine	=3D tegra_dt_init,
  	.init_late	=3D tegra_dt_init_late,
  	.restart	=3D tegra_assert_system_reset,

--Signature=_Wed__16_Jan_2013_14_10_16_+1100_z4.wSPV9ar.GaI.h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ9hoYAAoJEECxmPOUX5FE1hIQAI6CkFd4LnGVyva8HaT5vqg9
MupFMF5svUUPiK0NKXFPG/VW2IY3uNzNDTs+kwDeMIhMwLga2l/vvGa9VIrjnLR3
1ugVcOLZhZLq4ZfeOvCFGtlEZEMHpCRNowf7A+c3w4ha+b0bIPrMpbrcVKYg4uEQ
x57eq6NHz1JdhYkrKvZBt+7Zj78BSNkZmoXvWGor3lM8CNDgfn6sAUi+u4uVVZDB
nutADn2PpMz8YWrHfaIx916BRC9dYP0Z+wGEi7Q3IgsHfWjkt8qkq/O1EjkWt6+1
8QAcG8I2kQuqfyI+mzOhu6WTDZJzb7770gnoMcGo9z+uPtjiVk24N8TMkUdBhMPR
CM5pASKt29QsceEmFOyQWX17MpbGvJzYzLNTKeLfI1f/yYxuxInvjxCia3FBNiTD
z1nJZs8QqKDtBXttcCEDMjSgrqGMxL2A9gI94GdfVwpAEMHGmn5IqDSGuoCdTL/B
SoPz0xkH4fUmXpJjHlkgIR64AVHoouFTNPY3VzvgRhpNmDeKN8pV5vpdbMdMejU+
SVSc9uQwxYpsacKnnybQpBvL2BpVoDISpyFQar8Wu7ncYXW6b5eLYbSDgPQO39OA
TXAXQxnfXFcu4bCkZ7bG/HHeeU6tiES0fQnGc4tMfW9TBmznAXZqciEdjhgKBsje
s/YovzX1QhkXfV1yW699
=9GC6
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Jan_2013_14_10_16_+1100_z4.wSPV9ar.GaI.h--
