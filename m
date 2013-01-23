Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab3AWFdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 00:33:08 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50577 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3AWFdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 00:33:05 -0500
Date: Wed, 23 Jan 2013 16:33:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: linux-next: manual merge of the tegra tree with the pm tree
Message-Id: <20130123163303.1a8de2f38e78a20d6cb1d0a6@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Jan_2013_16_33_03_+1100_WQ_qPiqdMxkdlICr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jan_2013_16_33_03_+1100_WQ_qPiqdMxkdlICr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
drivers/clk/Makefile between commit bd3bffb544b1 ("clk: x86: add support
for Lynxpoint LPSS clocks") from the pm tree and commit 82f6b0926514
("clk: tegra: add Tegra specific clocks") from the tegra tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clk/Makefile
index ee11460,f0b269a..0000000
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@@ -22,7 -22,7 +22,8 @@@ obj-$(CONFIG_ARCH_U8500)	+=3D ux500
  obj-$(CONFIG_ARCH_VT8500)	+=3D clk-vt8500.o
  obj-$(CONFIG_ARCH_SUNXI)	+=3D clk-sunxi.o
  obj-$(CONFIG_ARCH_ZYNQ)		+=3D clk-zynq.o
 +obj-$(CONFIG_X86)		+=3D x86/
+ obj-$(CONFIG_ARCH_TEGRA)	+=3D tegra/
 =20
  # Chip specific
  obj-$(CONFIG_COMMON_CLK_WM831X) +=3D clk-wm831x.o

--Signature=_Wed__23_Jan_2013_16_33_03_+1100_WQ_qPiqdMxkdlICr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/3YPAAoJEECxmPOUX5FEhxgP/1R84RElHhRwSyHKvn3QrUqS
jC2RqxNZEBdZ/Qvy5pHZ4iJtu+4OT4ttuYBC+8yz58gZnDYYssYYxz334YPxcmYh
SjxItjGWgZ/ae6lTwxOncRMnHZHCCVgIIVqMAUg2LKufJ1+iKzAL7wJCYkSg5kV6
ikvifIQwOVmIQe7LQ1jFc7/eAv4ux+PESqYTl0x8xeZ5BwLoPzOCQoSmgl3WwMRe
+YgeIUJonRjfXGiyKHOphikfMkpSgFYBNKmGNezK4dKvnK2pHVFpsgc1Y1IHDrFa
psnI1JcNw+xyQlgmsVH/TXHZXSkaaXL5bf10bXmRKOZHn72uo932JfexAeH0YcOB
BKTWl9Xq8lHAxekQtaZZvmXM/EhaDRyPE2b/kaxK3lRcH1+4PFaT0zYqUrvo65DQ
fEolrDs2Pkr6zqnS7IjXRaEa3BUu+GtSeFqkNwr9jaquSXHU4iFVxkS9Ky3+utUB
zFS0YRKr58/zo+t2I029lNTzm2Owp5HoPfgpPNXpSQY411mgXlq1YbW1HdoWgHzG
3nq2LW72bBM27lMr6/VyfVZZusBK26Mp/n/7ReZLbZ73nprknOIDgwZ+THH/UEm1
qm1yjGJI5u5FEfLBpgeOz7f8zW96MdWYpgoPSgNkqSeoeg54Z8GMQrNjrVwHnMbY
DGn1l2AJ5CSbmqeBq6mp
=AG6p
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jan_2013_16_33_03_+1100_WQ_qPiqdMxkdlICr--
