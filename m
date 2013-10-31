Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3JaIYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 04:24:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49537 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab3JaIYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 04:24:01 -0400
Date: Thu, 31 Oct 2013 19:23:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: linux-next: manual merge of the arm-soc tree with the devicetree
 tree
Message-Id: <20131031192354.32945644fbdca2e0d6ca5455@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_Oct_2013_19_23_54_+1100_MUsLh42x6OQ6R8rK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_Oct_2013_19_23_54_+1100_MUsLh42x6OQ6R8rK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/pci/host/pci-mvebu.c between commit 16b84e5a505c ("of/irq: Create
of_irq_parse_and_map_pci() to consolidate arch code.") from the
devicetree tree and commit e5615c30c1c9 ("PCI: mvebu: remove
subsys_initcall") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pci/host/pci-mvebu.c
index 07ddb3a13c6e,80b2250ea19a..000000000000
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@@ -693,9 -732,10 +719,10 @@@ static void mvebu_pcie_enable(struct mv
  	hw.private_data   =3D (void **)&pcie;
  	hw.setup          =3D mvebu_pcie_setup;
  	hw.scan           =3D mvebu_pcie_scan_bus;
 -	hw.map_irq        =3D mvebu_pcie_map_irq;
 +	hw.map_irq        =3D of_irq_parse_and_map_pci;
  	hw.ops            =3D &mvebu_pcie_ops;
  	hw.align_resource =3D mvebu_pcie_align_resource;
+ 	hw.add_bus        =3D mvebu_pcie_add_bus;
 =20
  	pci_common_init(&hw);
  }

--Signature=_Thu__31_Oct_2013_19_23_54_+1100_MUsLh42x6OQ6R8rK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSchOfAAoJEMDTa8Ir7ZwVMMUP/0sM+QdYjlrPnrd6Y55G50Ec
mhL5riA6dmHeRGZ1AsGBJJnwuKSi0O0NcPALHzWxVI1rgLHM4QDM7U1hnkfSQiMu
WLdIY+botPW3Yz3AGCkHfdMZCBhOZo4w/9fwaCnIxIUEToFSUkvlPxKn7zl52JeY
JCMk/B7UPBFtqLNpcJy58KxPdT88HepG8PBuXrwjNzqMRKR8ivkp9+cn5h3N1SVR
uSmF6r/ofkN6k+PsvWZW9hEu8UCddD0AJUPlXrw0AB3CV47370QbvUuxrG4ixFu5
x1Wy8d2o0wKNrsjBZMuO7F7HJs8YC7WKrgIz1ZRk2v7BmWZQC1kneEmfBpeavdi+
3jz6PluCrMeb5Mj/UqjEfCNSdUaFb1X2E4Gv/ttpWtVTvnhaGRPptRtYEd6ZXL22
JSlfcx0glRL7dH2rLa0baiYz7lKHr6b+x9o5yb6mpGgkj3vYTxgbNPCfoLd3IgBh
Gv9B9KfXqc41AOq9QXUnl8ZKQOn6mce1PagwrNUmRX8ua0M81jPubCSOArY/y6Qt
4S2Oj7nRGuZ/fbBGSlpzRvS1Lq0ak0SWIDKyQPgF2TgQHwbZnTcZ6eaiimGSo1u4
jxKvaf4/lodHIwM4Ne3eQm9ArpLH9PDX5ORjERL2ci4Y/hlIDHMqXAFm1M/hmZKj
w5KfNadxRr+jMdYAiLFt
=wsuf
-----END PGP SIGNATURE-----

--Signature=_Thu__31_Oct_2013_19_23_54_+1100_MUsLh42x6OQ6R8rK--
