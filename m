Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3H0JDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:03:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51113 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab3H0JDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:03:18 -0400
Date: Tue, 27 Aug 2013 19:03:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: linux-next: manual merge of the clk tree with Linus' tree
Message-Id: <20130827190304.c3f2f891f20d078d66b703b1@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Aug_2013_19_03_04_+1000_smeSy=9ICZuZa=n_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Aug_2013_19_03_04_+1000_smeSy=9ICZuZa=n_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

Today's linux-next merge of the clk tree got a conflict in
drivers/clk/zynq/clkc.c between commits 252957cc3a2d ("clk/zynq/clkc: Add
dedicated spinlock for the SWDT") and 765b7d4c4cb3
("clk/zynq/clkc: Add CLK_SET_RATE_PARENT flag to ethernet muxes") from
Linus' tree and commit 819c1de344c5 ("clk: add CLK_SET_RATE_NO_REPARENT
flag") from the clk tree.

I fixed it up (see below and in a couple of places I chose
CLK_SET_RATE_NO_REPARENT over CLK_SET_RATE_PARENT, which may, of course,
be wrong) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clk/zynq/clkc.c
index 089d3e3,e05c9e3..0000000
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@@ -293,8 -294,9 +295,9 @@@ static void __init zynq_clk_setup(struc
  			swdt_ext_clk_mux_parents[i + 1] =3D dummy_nm;
  	}
  	clks[swdt] =3D clk_register_mux(NULL, clk_output_name[swdt],
- 			swdt_ext_clk_mux_parents, 2, CLK_SET_RATE_PARENT,
- 			SLCR_SWDT_CLK_SEL, 0, 1, 0, &swdtclk_lock);
+ 			swdt_ext_clk_mux_parents, 2, CLK_SET_RATE_PARENT |
+ 			CLK_SET_RATE_NO_REPARENT, SLCR_SWDT_CLK_SEL, 0, 1, 0,
 -			&gem0clk_lock);
++			&swdtclk_lock);
 =20
  	/* DDR clocks */
  	clk =3D clk_register_divider(NULL, "ddr2x_div", "ddrpll", 0,

--Signature=_Tue__27_Aug_2013_19_03_04_+1000_smeSy=9ICZuZa=n_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHGtMAAoJEECxmPOUX5FET5AP/imuch8fTXd6BpvpM2iCdkkg
IVBaW3A2+GX2Um/CDYus1lo/kt9y2ZJvn+LTR3Vi7jbI/in5epMwxDR7ZcgbeuHN
uTC55vJtOBFt5qfe/bcO/RS3fWntIq+0UU1EXg/Gd8LmwbB2qH8xWHOccvZjOMt0
RK9E4KR9YhSRV+qpVP3gVNBG7xIYzNU5XwwJKfZYwE8j9ZWwvdepoPGfQ+j2XkfS
cwLAtmX1wZ+2Jz1549IbNOhZK+zfzl3NO4tLrjuB/Emc2oRbXdTUuWeFaSUK0JRu
Fzz8Nh8evCCWwqtVvyZLs8UPqE+fCX6HNFHAKJW94Z/+ziS2+p16EVfsCb3cA57C
dHWJHSqhGhcNvqCXG8rBMaulMKwRsb8lpZCVksyNAtnqnlI/+tzWSKGNLuWjOokB
isC4rqe694PQBjMEJooflb8Ghv/0ppn4Ex6ytjdgjKkCXrT5FPSn0Ie8MIWU6z+w
evK9EKqetY8hXjybJeuaoNtYAwkRHMzQnrXH+5Puh1e04jQ14Kr/d/pvw3P0yfYA
XLu/MZU69kKVqP9T0KZIefYb4xjQWD2DTA+YtjRbI9N02pjtwYtHjHi2BoDSVx0U
29c/YryH0cd7nxo683x6LU5A5n51C2d7BrORxFyUzfgVO9uGkGehvbtA7V1L9G0t
DjlzDLqOO31H0ER0CIqp
=neZX
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Aug_2013_19_03_04_+1000_smeSy=9ICZuZa=n_--
