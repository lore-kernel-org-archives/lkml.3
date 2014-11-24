Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051AbaKXFSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 00:18:51 -0500
Received: from ozlabs.org ([103.22.144.67]:43933 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaKXFSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 00:18:49 -0500
Date: Mon, 24 Nov 2014 16:18:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>, Yijing Wang <wangyijing@huawei.com>
Subject: linux-next: manual merge of the tip tree with the pci tree
Message-ID: <20141124161842.02251126@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/IIB_jLdIHgJGPcHF.Qb9+1W"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/IIB_jLdIHgJGPcHF.Qb9+1W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
drivers/pci/host/pcie-rcar.c between commit 3c70637f7569 ("PCI: rcar:
Make rcar_pci static") from the pci tree and commit 7c35c8cc32f3 ("PCI:
rcar: Save MSI controller in pci_sys_data") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pci/host/pcie-rcar.c
index 0df9b2941221,c1177cd55ce3..000000000000
--- a/drivers/pci/host/pcie-rcar.c
+++ b/drivers/pci/host/pcie-rcar.c
@@@ -380,16 -380,7 +380,7 @@@ static int rcar_pcie_setup(int nr, stru
  	return 1;
  }
 =20
- static void rcar_pcie_add_bus(struct pci_bus *bus)
- {
- 	if (IS_ENABLED(CONFIG_PCI_MSI)) {
- 		struct rcar_pcie *pcie =3D sys_to_pcie(bus->sysdata);
-=20
- 		bus->msi =3D &pcie->msi.chip;
- 	}
- }
-=20
 -struct hw_pci rcar_pci =3D {
 +static struct hw_pci rcar_pci =3D {
  	.setup          =3D rcar_pcie_setup,
  	.map_irq        =3D of_irq_parse_and_map_pci,
  	.ops            =3D &rcar_pcie_ops,

--Sig_/IIB_jLdIHgJGPcHF.Qb9+1W
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUcr+2AAoJEMDTa8Ir7ZwVdqYQAIYmsRU2Lb130GZDr5PCYEQf
DY7Wz0QS9bQ4LBmlTwaGc8jsdeh+1SnpnzSkCgzJnmZ1XeLSJW2y7bPFhrgYSsMB
tbaZIZ4TgRDNatWYpgPwg25qPMeUP2zRjXN1kLu/VCWGSasslr0bblYJx+fYxPmk
v+MhHsQug+q5PlkKwbYjVmnNxos4xAEJ3WtIVSQ/VwkI5p/h7cfM9gtN3VTIGtQC
b74rtBeIGzCqLFZhZZh3dbf1DgLqlDGDUTJMT49rff4Q1QCpD32kNueZ7LpFu+4f
ESRC0YeTTn835fAqq4xh4qwDWKV30uktgaZtfv0wfp7XrCLwTcJ9LiSN2xFQS2Cy
IrGrFytuAGMLTM4BP6BBkjLou/RziKAD7DGKdHH8E7jl8jKrLAMIK5xM8Hd01s+U
QGGl21KztrCZVvvw0ELwmsV/f9HRYcdIRRBc5tzTgiaEHAylOIfGQphcbOsNzAU0
QmtNBE04bdn44chh/JJitGRDHhZfF/gYi7C6g86Ef71ehn5BPVvcwl8Pm4W3PFkT
ZZtVGsrZlKTxdz6yWXJN/ersaYGudRcwFMi/IW2q2/9yTsAmEeC05wZVaKB06DYf
pOiBiTROczA1USc+1pI2R5G08/gfZ0jir1aMx+OBzreFxrAh+ZyWcojCZ2LHbd3k
da55Km7Eu5p2Rk1GMdsR
=iQHh
-----END PGP SIGNATURE-----

--Sig_/IIB_jLdIHgJGPcHF.Qb9+1W--
