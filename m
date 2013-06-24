Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab3FXFsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 01:48:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40901 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3FXFss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 01:48:48 -0400
Date: Mon, 24 Jun 2013 15:48:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tushar Behera <tushar.behera@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the clk tree with the samsung tree
Message-Id: <20130624154828.292bd8800c80c526695c1659@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Jun_2013_15_48_28_+1000_JPoihGJ4ElMqRHxo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Jun_2013_15_48_28_+1000_JPoihGJ4ElMqRHxo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

Today's linux-next merge of the clk tree got a conflict in
drivers/clk/samsung/clk-exynos4.c between commit 6082f908b060 ("clk:
exynos4: Staticize local symbols") from the samsung tree and commit
82ba93b27cf5 ("clk: exynos4: Fix clock aliases for cpufreq related
clocks") from the clk tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clk/samsung/clk-exynos4.c
index 50af410,94c5e1a..0000000
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@@ -355,9 -355,9 +355,9 @@@ static struct samsung_fixed_rate_clock=20
  };
 =20
  /* list of mux clocks supported in all exynos4 soc's */
 -struct samsung_mux_clock exynos4_mux_clks[] __initdata =3D {
 +static struct samsung_mux_clock exynos4_mux_clks[] __initdata =3D {
- 	MUX_F(mout_apll, "mout_apll", mout_apll_p, SRC_CPU, 0, 1,
- 			CLK_SET_RATE_PARENT, 0),
+ 	MUX_FA(mout_apll, "mout_apll", mout_apll_p, SRC_CPU, 0, 1,
+ 			CLK_SET_RATE_PARENT, 0, "mout_apll"),
  	MUX(none, "mout_hdmi", mout_hdmi_p, SRC_TV, 0, 1),
  	MUX(none, "mout_mfc1", sclk_evpll_p, SRC_MFC, 4, 1),
  	MUX(none, "mout_mfc", mout_mfc_p, SRC_MFC, 8, 1),
@@@ -423,9 -423,9 +423,9 @@@ static struct samsung_mux_clock exynos4
  };
 =20
  /* list of mux clocks supported in exynos4x12 soc */
 -struct samsung_mux_clock exynos4x12_mux_clks[] __initdata =3D {
 +static struct samsung_mux_clock exynos4x12_mux_clks[] __initdata =3D {
- 	MUX(mout_mpll_user_c, "mout_mpll_user_c", mout_mpll_user_p4x12,
- 			SRC_CPU, 24, 1),
+ 	MUX_A(mout_mpll_user_c, "mout_mpll_user_c", mout_mpll_user_p4x12,
+ 			SRC_CPU, 24, 1, "mout_mpll"),
  	MUX(none, "mout_aclk266_gps", aclk_p4412, SRC_TOP1, 4, 1),
  	MUX(none, "mout_aclk400_mcuisp", aclk_p4412, SRC_TOP1, 8, 1),
  	MUX(mout_mpll_user_t, "mout_mpll_user_t", mout_mpll_user_p4x12,

--Signature=_Mon__24_Jun_2013_15_48_28_+1000_JPoihGJ4ElMqRHxo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIbBAEBCAAGBQJRx92wAAoJEECxmPOUX5FEduUP+OYRF0rHMo/3gUYhW+ZaFwsd
K8ekhKsvawuOvFhmdU1RpDNHZaPLfSswIuWXb/iwY9ltBsJQpIA8s9z5GqYF0zu+
t7mrm6pNbOLeWEuW0VDlEnQ4+jfpgPrME+lMI1LlyvXP5XCIq72VZvc4A/ZQ3wdU
Ugt4QOX3WUVbHsDIH7II+aaM3CmwvmsLITpTbjzlAYiq/0hAkurkbbrNRLgS9fTK
QyALkQ0KpDGG9tdGiIe97zU33yBiOjE62bYzSpNa3sDM1kRoMEBD3JpAuD5b1CVn
TTqNLSdFsTpdygOr3apOF+ZnfVrurmHB2MWZEvPRIxZ1S1/ujasIWzTcGJbrSJoG
WZVElp4kwNLSowrfRosrPtf/jpOMrEj35WKSPX2Fmrm5jughQGP40XmATKZb2bwW
kbxT7t4aAeBU1wIDtnq/520kOI2tQCsHudkPT8uhlhz6ynsKKQfeT+V6jkwWbOK8
uMAhqoMVSqh6IUrh5kP41bFRSp87eRb92aMm52RksQnzb1chiPVmZPaH3TFJyHP+
B4ZlKBLhPkBcuVejA2bwkmnk5RZzFjkZjtKP+7xTVtOtgnkXF7jlQ7pQCck32vJy
RQOus1J55TaM14RAmOJK2Co9NoslFj4apm1s4/k5tYXJ2URd1CDaw8OHYSHIvKBD
4Okzyc8DuOxnmTuHcSY=
=orwx
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Jun_2013_15_48_28_+1000_JPoihGJ4ElMqRHxo--
