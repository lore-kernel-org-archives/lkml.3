Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab3APDMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 22:12:18 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:34292 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab3APDMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 22:12:16 -0500
Date: Wed, 16 Jan 2013 14:12:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: linux-next: manual merge of the tegra tree with the arm-soc
 tree
Message-Id: <20130116141211.c051e57f1b5281ea23fecb99@canb.auug.org.au>
In-Reply-To: <20130116141016.a831f6d246b0f038c4afab98@canb.auug.org.au>
References: <20130116141016.a831f6d246b0f038c4afab98@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_Jan_2013_14_12_11_+1100_oR5uq3AF.n+WPhyv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Jan_2013_14_12_11_+1100_oR5uq3AF.n+WPhyv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi All,

On Wed, 16 Jan 2013 14:10:16 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the tegra tree got a conflict in
> arch/arm/mach-tegra/board-dt-tegra20.c between commit 1d5cc604f42f ("ARM:
> remove mach .handle_irq for GIC users") from the arm-soc tree and commit
> ac0fd9eca3ba ("ARM: tegra: move timer.c to drivers/clocksource/") from
> the tegra tree.

This also affected arch/arm/mach-tegra/board-dt-tegra30.c.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/board-dt-tegra30.c
index 12dc2dd,cfe5fc0..0000000
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/board-dt-tegra30.c
@@@ -111,7 -113,8 +112,7 @@@ DT_MACHINE_START(TEGRA30_DT, "NVIDIA Te
  	.map_io		=3D tegra_map_common_io,
  	.init_early	=3D tegra30_init_early,
  	.init_irq	=3D tegra_dt_init_irq,
- 	.init_time	=3D tegra_init_timer,
 -	.handle_irq	=3D gic_handle_irq,
+ 	.init_time	=3D clocksource_of_init,
  	.init_machine	=3D tegra30_dt_init,
  	.init_late	=3D tegra_init_late,
  	.restart	=3D tegra_assert_system_reset,

--Signature=_Wed__16_Jan_2013_14_12_11_+1100_oR5uq3AF.n+WPhyv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ9hqLAAoJEECxmPOUX5FEdAgP/RsSuFilzIzBQ4kKBiKDWoae
Z0K9KW20iICr4VpeSRXVjAA3HAGe8iom3shRXxrcLfVFKBkhKCfcth2zY7RhZBNG
J04RGakTFAdqETttldOEppLrbLHFhVcYJV5GoY8vR0MV9CDwt80sJj17Ulc6E4/Q
Ne1J7WB8iHhfrlAXl4MbQUzKhMBVorCInDuEnLHxJrlbS7eygJBG3m3eoN8dSncm
4PaEKxaEdXy70SUc1kfM008Y6hzefRhzeTgXQU2GugihTra7JsLMzdIDxV9Ar+L1
71wn64mQeA4j1LiYKaUa9Lqx5+jNKdvPkxuQHud4/cznMXUda7oExq+/fg/qoooG
1fOWL3kFmcbMtpRevGfS0aqsG5qNNNIa5W0HqIo7bWdqtNlP5QrzQ9SudKtNov7K
tcWXsm9kpEK6mJpmEHixoDt0uYR2+jVRnH4uWT1LBWpe6dU0ZY2DF15ZhpcI2v2h
ZoPbVJbw/QugDk2F2VnSDCYMK1ZR4JfZbrJCtIjWak1CRDt9T6Zxn0TkZEdWQeWp
y2booVu6E5OrYedxPggu9/LugmlgjNus/iZ3je4c1DMHsRg+ePWsEyemKFlvDaYb
wdcr+URyz0MquZqo5KxOKPQQ8pxbf4eST22IpXooRMmfrii10rO3MdvWQJWxXmLk
0B8g14mIbmineFhISa0t
=sOdo
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Jan_2013_14_12_11_+1100_oR5uq3AF.n+WPhyv--
