Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab3I0IdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:33:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52229 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3I0Ic4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:32:56 -0400
Date: Fri, 27 Sep 2013 18:32:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dong Aisheng <b29396@freescale.com>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20130927183246.13094a90de1676232e17d30e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Sep_2013_18_32_46_+1000_nMNKTlfWPLafoASb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Sep_2013_18_32_46_+1000_nMNKTlfWPLafoASb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

In file included from include/linux/kernel.h:14:0,
                 from include/linux/debug_locks.h:4,
                 from include/linux/lockdep.h:23,
                 from include/linux/sysfs.h:18,
                 from include/linux/kobject.h:21,
                 from include/linux/device.h:17,
                 from arch/powerpc/include/asm/io.h:27,
                 from include/linux/io.h:22,
                 from drivers/mmc/host/sdhci-of-esdhc.c:17:
drivers/mmc/host/sdhci-of-esdhc.c: In function 'esdhc_of_set_clock':
drivers/mmc/host/sdhci-of-esdhc.c:230:10: error: 'host_clock' undeclared (f=
irst use in this function)
   clock, host_clock / pre_div / div);
          ^
include/linux/dynamic_debug.h:87:9: note: in definition of macro 'dynamic_d=
ev_dbg'
       ##__VA_ARGS__);  \
         ^
drivers/mmc/host/sdhci-of-esdhc.c:229:2: note: in expansion of macro 'dev_d=
bg'
  dev_dbg(mmc_dev(host->mmc), "desired SD clock: %d, actual: %d\n",
  ^

Caused by commit d31fc00a71b4 ("mmc: sdhci-esdhc: move common
esdhc_set_clock to platform driver") from the mmc tree.

I applied this temporary fix (reverting looked too hard):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 27 Sep 2013 18:28:29 +1000
Subject: [PATCH] mmc: sdhci-esdhc: temporary build fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/mmc/host/sdhci-of-esdhc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-=
esdhc.c
index b1605a1..82d22ff 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -226,8 +226,8 @@ static void esdhc_of_set_clock(struct sdhci_host *host,=
 unsigned int clock)
 	while (host->max_clk / pre_div / div > clock && div < 16)
 		div++;
=20
-	dev_dbg(mmc_dev(host->mmc), "desired SD clock: %d, actual: %d\n",
-		clock, host_clock / pre_div / div);
+	// dev_dbg(mmc_dev(host->mmc), "desired SD clock: %d, actual: %d\n",
+	//	clock, host_clock / pre_div / div);
=20
 	pre_div >>=3D 1;
 	div--;
--=20
1.8.4.rc3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__27_Sep_2013_18_32_46_+1000_nMNKTlfWPLafoASb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSRUKyAAoJEMDTa8Ir7ZwVw94P/idQaD10dufANhNQFrwk4E0h
jtiZx0o8RXNEMfkFVBwNYAIH3MErx08vVgvnfz8bns1TtqiRdnn+fVYTDZua+Cv1
wflI2XImwU5TgKfBh5q4nHGXGS1vbJdYDfQrV3eaWvGymZVMSkxEFcgYntT33Hnx
lR7DQSgI9X5DWqkczoxId/IlRUW2AHgvsrhkL4DFGaozVGHpRtszIRc31CTbM/zh
ZmsINmKXo0V0qfPQohDK/EEOAeon+Z1IRwBt9AGO2+XVTrpqU1OcmuF4z5d2kXe3
SjZVYUvT0oa5YPUAPTaCGKKrwF4AFfUj8VKkIv75LQyPkhFHyAOZKK/JWSM+b+fm
w/9/v1fnmj5jx3BX0mDG8T7EbfPBxDh7uQHgKzblC7UNP7yLMtMjRTqud9Y4Js6c
NSIf9I32WNOkyxLscDo2WKx1Ka0y078jdLnfnBvMt1rLg8VmEmyx8BtqeS2RAEit
uC6PXHLYFrf1i8Gg6SmZdEEN70s45rE604W+1ILXljDlGuGc4SyngCKuAvJ8G21o
tKoiNzldZ1nBTkbsl1SuqIt5MU01z3zma2kMDIxm4g3/RG8IRx+MbZKIGAQSn1Qx
9Ts7ruckMtT4n50kLmmmaL4ckWaFTe+c5fIVXMqJTzF0oOlSVLBoBAAqLywA/Oxt
2L88UZQggx5koHuDoEd0
=w4dn
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Sep_2013_18_32_46_+1000_nMNKTlfWPLafoASb--
