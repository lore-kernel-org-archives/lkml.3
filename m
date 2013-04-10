Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936088Ab3DJIDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 04:03:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48405 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3DJIC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 04:02:57 -0400
Date: Wed, 10 Apr 2013 18:02:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Axel Lin <axel.lin@ingics.com>
Subject: linux-next: manual merge of the clk tree with the trivial tree
Message-Id: <20130410180238.f600ccf4ccbce04a5272f75b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Apr_2013_18_02_38_+1000_gsMpwyxa=he1Tjbb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Apr_2013_18_02_38_+1000_gsMpwyxa=he1Tjbb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

Today's linux-next merge of the clk tree got a conflict in
drivers/clk/mvebu/clk-core.c between commit 07f42258893d ("treewide: Fix
typos in printk") from the trivial tree and commit 4cb24e68a5af ("clk:
mvebu: Fix valid value range checking for cpu_freq_select") from the clk
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clk/mvebu/clk-core.c
index 1b4e333,2628610..0000000
--- a/drivers/clk/mvebu/clk-core.c
+++ b/drivers/clk/mvebu/clk-core.c
@@@ -156,8 -156,8 +156,8 @@@ static u32 __init armada_370_get_cpu_fr
 =20
  	cpu_freq_select =3D ((readl(sar) >> SARL_A370_PCLK_FREQ_OPT) &
  			   SARL_A370_PCLK_FREQ_OPT_MASK);
- 	if (cpu_freq_select > ARRAY_SIZE(armada_370_cpu_frequencies)) {
+ 	if (cpu_freq_select >=3D ARRAY_SIZE(armada_370_cpu_frequencies)) {
 -		pr_err("CPU freq select unsuported %d\n", cpu_freq_select);
 +		pr_err("CPU freq select unsupported %d\n", cpu_freq_select);
  		cpu_freq =3D 0;
  	} else
  		cpu_freq =3D armada_370_cpu_frequencies[cpu_freq_select];
@@@ -278,8 -278,8 +278,8 @@@ static u32 __init armada_xp_get_cpu_fre
  	cpu_freq_select |=3D (((readl(sar+4) >> SARH_AXP_PCLK_FREQ_OPT) &
  			     SARH_AXP_PCLK_FREQ_OPT_MASK)
  			    << SARH_AXP_PCLK_FREQ_OPT_SHIFT);
- 	if (cpu_freq_select > ARRAY_SIZE(armada_xp_cpu_frequencies)) {
+ 	if (cpu_freq_select >=3D ARRAY_SIZE(armada_xp_cpu_frequencies)) {
 -		pr_err("CPU freq select unsuported: %d\n", cpu_freq_select);
 +		pr_err("CPU freq select unsupported: %d\n", cpu_freq_select);
  		cpu_freq =3D 0;
  	} else
  		cpu_freq =3D armada_xp_cpu_frequencies[cpu_freq_select];

--Signature=_Wed__10_Apr_2013_18_02_38_+1000_gsMpwyxa=he1Tjbb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRZRyeAAoJEECxmPOUX5FEHLUP/16YhIKDUy52+PZ/AxM4Own/
7NpePCGm8WgXuo7RByNJLbYPAZJT+TCiWadS+PAY8vOj97tOGaoE+7QIPFRmmy74
OCYSq7l0laT0VjHhZ2spFpIxUQFgTzBMJBqRZkWjw5eyZUDJA0Nz4RJW02Mj+xJy
UJVynCLqiMXTkPdkumk+hOcciuSri4i4CLASZc6yw7PCFGKiSyNlvdyooCOkXCmj
pmrZaG1h142fzVShVPlDsHAn+Ar9MH+kkxz/7/6zc86MEkh/U0WI8O7YuAGvdxuJ
t6ghovg7Rfv2/2CR278YpnvVkVTMoOQiYYltKQ2zi29hewXMOCXggXnunk2COO05
v75Zili/8sB1yv7OvElnt+nD1IsGsIGh7PIGWBr8FtqzptnXxbAN27AiMOJ/5leK
OoN31eWHrXMa6DK4cCaCKVZNa434mYqiJXzMrCRu2nsGhGB/bEZmZQkHE48t/02s
yRx2nb/WvnhNXQhhcegBTJJ97NhztbNA5oZfVa3X67BmjdeLNZ0Hli278PWr2o+l
yWPT8dQ5NcN7XY0Qd01u4wkrsnUERcUKMXcSxEo6FtT92Qd9OpIpoN+EnLb9Q/tE
sF0hG1L0O9ZqGRq8UOnmvuBb4zu2lCLER9NpbKnVX3XwlFr3EwbStRGefXddX3eF
Ggac8iaSlbscWWfSQWzt
=uZSP
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Apr_2013_18_02_38_+1000_gsMpwyxa=he1Tjbb--
