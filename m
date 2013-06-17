Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab3FQH1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 03:27:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52156 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3FQH1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 03:27:31 -0400
Date: Mon, 17 Jun 2013 17:27:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joseph Lo <josephl@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: linux-next: manual merge of the clk tree with the arm-soc tree
Message-Id: <20130617172719.f19a76fae98cc7ef82b91ae9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Jun_2013_17_27_19_+1000_Np9Aylc3TeHaLcuj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jun_2013_17_27_19_+1000_Np9Aylc3TeHaLcuj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

Today's linux-next merge of the clk tree got a conflict in
drivers/clk/tegra/clk-tegra114.c between commit 31972fd95527 ("clk:
tegra114: implement wait_for_reset and disable_clock for
tegra_cpu_car_ops") from the arm-soc tree and commit d53442e94db0 ("clk:
tegra: override bits for Tegra114 PLLM") from the clk tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clk/tegra/clk-tegra114.c
index 40d939d,7fe36ea..0000000
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@@ -250,9 -251,10 +251,13 @@@
  #define CLK_SOURCE_XUSB_DEV_SRC 0x60c
  #define CLK_SOURCE_EMC 0x19c
 =20
 +/* Tegra CPU clock and reset control regs */
 +#define CLK_RST_CONTROLLER_CPU_CMPLX_STATUS	0x470
 +
+ /* PLLM override registers */
+ #define PMC_PLLM_WB0_OVERRIDE 0x1dc
+ #define PMC_PLLM_WB0_OVERRIDE_2 0x2b0
+=20
  static int periph_clk_enb_refcnt[CLK_OUT_ENB_NUM * 32];
 =20
  static void __iomem *clk_base;

--Signature=_Mon__17_Jun_2013_17_27_19_+1000_Np9Aylc3TeHaLcuj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRvrpcAAoJEECxmPOUX5FEz9YP/iJn1bX8mnRLCjg8yXkVWUHA
oHW+Iu6dbQWAs48r01AYKebwS6e5zokKvyM9rqyxQX5QAw+pJHFsDdvJYy5s53yO
2ObQolLEVmuOWpcbZArrCYvPFrTSG6oqGCNQUKj54H2wgjjzyHTfiUz3fLOlhBXa
EQGvrF6ivHLpozyuRZWBsP0putEtxCHcgPyMkfdDuKnuF7mF0teeI6tsbPPj/P0N
wAWP6ANToiM0wjC6xC1CBIB4OQMeIae6qyy19Awsf+lEKagwY5zTR0BVu0/SD3zX
zq6iZVbK14xxXj2maTVqphurTz8q38X80znusLqrQBsykIGZSd1JGLF3k/26wVoC
iWh5MxSmTO2lkJ34zA8u1x/tLdagIEWv8LvALzEpfZXz5MZJZM+uD6aleCHSa/1Q
wPsr9b62AdGTcfok4QFIKUcO/eBVqJwesrPjp5yNn7rcumL0Kt8QjQ8aopSepPDY
FZKvPya6BPzz3dfHkV8x5X9aJkjtePxe/fjrkjtQQl9MQftkWtr5FST0JjGDt0Hz
4LV5DJ7wlwa3ncCr4BlLxyhCJDorPsacvGUiB4LSP9/Ca9oWwt4PY0vpd3zC+FL/
Wboiuar5HprciEubnuOCx+pCiklVdhgceCdsKq8cDlDFZ9MOP7EKdKwcCjEzESVw
tbUOiiffLMJHjp/fzJ2k
=ZhZ2
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jun_2013_17_27_19_+1000_Np9Aylc3TeHaLcuj--
