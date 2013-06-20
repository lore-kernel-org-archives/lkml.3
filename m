Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3FTHgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:36:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44496 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab3FTHgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:36:09 -0400
Date: Thu, 20 Jun 2013 17:36:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tushar Behera <tushar.behera@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: linux-next: manual merge of the samsung tree with Linus' tree
Message-Id: <20130620173604.67b07fa0932dac4a75583fd5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Jun_2013_17_36_04_+1000_offgw2Y_IAMhxnUC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Jun_2013_17_36_04_+1000_offgw2Y_IAMhxnUC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
drivers/clk/samsung/clk-exynos5250.c between commit 39b72d89eb2b ("clk:
exynos5250: Update cpufreq related clocks for EXYNOS5250") from Linus'
tree and commit 407e8d62fa7d ("clk: exynos5250: Staticize local symbols")
from the samsung tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clk/samsung/clk-exynos5250.c
index 22d7699,f6e3031..0000000
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@@ -207,11 -213,11 +213,11 @@@ static struct samsung_fixed_factor_cloc
  	FFACTOR(none, "fout_bplldiv2", "fout_bpll", 1, 2, 0),
  };
 =20
- struct samsung_mux_clock exynos5250_mux_clks[] __initdata =3D {
+ static struct samsung_mux_clock exynos5250_mux_clks[] __initdata =3D {
 -	MUX(none, "mout_apll", mout_apll_p, SRC_CPU, 0, 1),
 -	MUX(none, "mout_cpu", mout_cpu_p, SRC_CPU, 16, 1),
 +	MUX_A(none, "mout_apll", mout_apll_p, SRC_CPU, 0, 1, "mout_apll"),
 +	MUX_A(none, "mout_cpu", mout_cpu_p, SRC_CPU, 16, 1, "mout_cpu"),
  	MUX(none, "mout_mpll_fout", mout_mpll_fout_p, PLL_DIV2_SEL, 4, 1),
 -	MUX(none, "sclk_mpll", mout_mpll_p, SRC_CORE1, 8, 1),
 +	MUX_A(none, "sclk_mpll", mout_mpll_p, SRC_CORE1, 8, 1, "mout_mpll"),
  	MUX(none, "mout_bpll_fout", mout_bpll_fout_p, PLL_DIV2_SEL, 0, 1),
  	MUX(none, "sclk_bpll", mout_bpll_p, SRC_CDREX, 0, 1),
  	MUX(none, "mout_vpllsrc", mout_vpllsrc_p, SRC_TOP2, 0, 1),

--Signature=_Thu__20_Jun_2013_17_36_04_+1000_offgw2Y_IAMhxnUC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwrDkAAoJEECxmPOUX5FEbrAP/289l96CKfPfj2n9DGO6HWqW
57UXpsvNpNdC7gbVJtMZGgg3xsAFFVFXGmtcANmDsFzV0A8WOUhrHeb/9yKhYZq4
ekQxVogln4yoDJaP0k0RrDYhwlOVT/s/s3SJM4ylH4yyjaZur8mXBVwU+NAe7aKl
eyAg3V6GZzQt5s5j3JpTFHNjRu++dfG1nEgKVBCMueqYrM09+M5XtnPYnpenBbu2
kuleDEGp8GC1eAa2/rmthofR+gaQ1Aw7znwUAgXhU6+Bawef3Z1t4Wq3hVInPlUh
8P+4JAxCVaWmcLFDJd4+NiWzqtXCdpqgkEwmzHPqSPE28mjuZ+ZSmsR4PmWLshr5
1bmPp0fTLMTeruIanKo8UNYLNbFDNg9y/saACyF7FesrTaEFdoq30DIxNWV7oOeq
ENs2+VQLqemrY0HbVMGxlSeew/pI3TQ0dKPMo8SzCc3XXXPZPbvi3cK56TUVRO9s
jUsRiJxj7Mu1MJhTYdqM+ARp+JX1r1iZrbDJFhkmIQnVe7EAO8ZeR5cqOrC4sWdu
s9CpHY8Mfbpc4Ceil7JxP47d+DoPBj3R5rb8B+84QhG7qqOagWT9YFzS6tu8kuGa
M/O1OmdVKWCJL77gxgg83oSMe0TySRd6r5dm0MGmAjtOKMNwm9jQZq1psP1KEEVx
kt9rFNYpt9n+lT5UBiXY
=KCR1
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Jun_2013_17_36_04_+1000_offgw2Y_IAMhxnUC--
