Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbaI3JiC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 05:38:02 -0400
Received: from ozlabs.org ([103.22.144.67]:46133 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaI3JiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 05:38:00 -0400
Date: Tue, 30 Sep 2014 19:37:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiko =?UTF-8?B?U3TDvGJuZXI=?= <heiko@sntech.de>
Subject: linux-next: manual merge of the akpm tree with the clk tree
Message-ID: <20140930193752.3f0ae731@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/iuXtqNkrcYsa+O=nvAp=lmY"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/iuXtqNkrcYsa+O=nvAp=lmY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/clk/rockchip/clk.h between commit f6fba5f6967d ("clk: rockchip:
add new clock-type for the cpuclk") from the clk tree and commit "clk:
rockchip: add restart handler" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clk/rockchip/clk.h
index f4791fbb3da9,2f0236a00664..000000000000
--- a/drivers/clk/rockchip/clk.h
+++ b/drivers/clk/rockchip/clk.h
@@@ -361,11 -329,7 +361,12 @@@ void rockchip_clk_register_branches(str
  				    unsigned int nr_clk);
  void rockchip_clk_register_plls(struct rockchip_pll_clock *pll_list,
  				unsigned int nr_pll, int grf_lock_offset);
 +void rockchip_clk_register_armclk(unsigned int lookup_id, const char *nam=
e,
 +			const char **parent_names, u8 num_parents,
 +			const struct rockchip_cpuclk_reg_data *reg_data,
 +			const struct rockchip_cpuclk_rate_table *rates,
 +			int nrates);
+ void rockchip_register_restart_notifier(unsigned int reg);
  void rockchip_clk_protect_critical(const char *clocks[], int nclocks);
 =20
  #define ROCKCHIP_SOFTRST_HIWORD_MASK	BIT(0)

--Sig_/iuXtqNkrcYsa+O=nvAp=lmY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUKnn0AAoJEMDTa8Ir7ZwVbkEP/2RBap5w4ke29k0v8hTgxGNn
WXUhbJEU7AzHFuvcUH40Aw+70RSgO5TDGiebF06BqFLYwBbMMwzidFBf3v/DpNDG
Nml+RV7k+ZwyUR2ZxdLxI9bBKm7oiCRD5SDbkxEv/6Sf1dnmMQ9agJkyNiXfS+dY
Q2dvXbrYfd6xTbvevBdTqxtV7PCQyVnekUIYczn21p+rFpTYzpCAzR47YtcV322s
QmPk9wG7i4AYhuwHW5lc4Ok3I3YOszOfc/wd2w3vdyrqMOCUTLgJbtxtFV7iZA8F
p3AcBnhKJOMaHKpMWLd/HBuKrlX8LzQ2qWpPNeSmYGmSO5wPHKOpf/GADBg2lnLs
d//Bry5rLWgJ50BftGMwcKCwuxP9nsrq0/qTeJynEqbIdihpzbcrbbHclNsgPH5o
59EOODl3N2s25FgBirIZTIOb6u8Wd1antRTjiTpAeiOsK4ygsB4rraVKm5n2P1AF
IBe705/RMF+JpUY5YxfKMUpn9vsQaX+hZag7bGgT2oVc5W5E9uFNvjymlvVJSek1
Tve7a1TprQM6gJojRpdrjtkLHqPIPlsBCSH0a2OoLGOZBKWWq3GE3EzEsdAL2dtL
HId6j+ztoSTkm6bUXfvID1oaBzs+Y3lUVqgc2Nikd0xJWw1kZT1RK3BE4OCOof7/
rCMUbX0z11AKjUmVJVPM
=Cx5H
-----END PGP SIGNATURE-----

--Sig_/iuXtqNkrcYsa+O=nvAp=lmY--
