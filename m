Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3HNGS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 02:18:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36026 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab3HNGSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 02:18:54 -0400
Date: Wed, 14 Aug 2013 16:18:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: linux-next: manual merge of the mvebu tree with the pci tree
Message-Id: <20130814161840.dcee2b1354579cce7ff81730@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Aug_2013_16_18_40_+1000_l2QvE9vgSaqtk6Iw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Aug_2013_16_18_40_+1000_l2QvE9vgSaqtk6Iw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mvebu tree got a conflict in
drivers/pci/host/Kconfig between commit 5477a33b51b7 ("PCI: mvebu: Make
Marvell PCIe driver depend on OF") from the pci tree and commit
31d896ade95d ("PCI: mvebu: add support for Marvell Dove SoCs") from the
mvebu tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pci/host/Kconfig
index e5ba4eb,492eec9..0000000
--- a/drivers/pci/host/Kconfig
+++ b/drivers/pci/host/Kconfig
@@@ -3,8 -3,7 +3,8 @@@ menu "PCI host controller drivers
 =20
  config PCI_MVEBU
  	bool "Marvell EBU PCIe controller"
- 	depends on ARCH_MVEBU || ARCH_KIRKWOOD
+ 	depends on ARCH_MVEBU || ARCH_DOVE || ARCH_KIRKWOOD
 +	depends on OF
 =20
  config PCIE_DW
  	bool

--Signature=_Wed__14_Aug_2013_16_18_40_+1000_l2QvE9vgSaqtk6Iw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSCyFEAAoJEECxmPOUX5FEuzYP/0NehFO9OLcm8oAGZPIkURBT
CFgol0fLD98ONrzi9h3XCv1ZwadhmoSz3INRcpT4Kdthk8gmJeNA6a+7yGJVCGbc
Fk7LxYtZwSVoB8lLMehjcqDTa50R4QcnPhNPmkjXQEtPx0Gl8OqpZTSFoKrhUXdz
/95YDLuiy8tJgmQ7UYmveM6GUWgjbY47Q0756BF6NR2zJA01Z5p0j8FnvEwlQEoS
w1uVa4MHmqspTdbJ6orKJpI1FCgXYqJDWN8ug4i6VkLmGG/a15XIbqYtPVvRqNP6
t/tP0hTemf6Ks0hAW5DHgYDZCEPPFFvhP8vOjT0frsmnLjvgvdfOcGMDsduHWmZB
UU0fsT5DoHAsSFtx7IX9scwoCcGD93agxi36nolXRXclmLFpShE+MPfzSZdeGWsw
d3foPw6nqYhjiFgGXgku0RQUtDIO4SsfSoYEA1lO25359iTlNZGfZdXtIJcR0qxc
QUR3B4OT/5IlwTwj09eMdGUnfTXFNHh0ATGuGhP2TmLUAznA9QePE1pmgtQG94Y5
q7HLadyTH0TJTwyFHZaSrdqFmiFD8N+g55FA9pIWhFMLcQ+m92YPz9uc8bvbhmte
0WXY3u/USbB40+YZMb6zxVVIMWrkbz6Dy+cww4xqn2kINhkgYWqLU6nntjJDII2n
QexprF9szYiEh1cH1N+d
=1TkN
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Aug_2013_16_18_40_+1000_l2QvE9vgSaqtk6Iw--
