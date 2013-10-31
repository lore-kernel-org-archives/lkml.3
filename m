Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3JaITM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 04:19:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60124 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3JaITJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 04:19:09 -0400
Date: Thu, 31 Oct 2013 19:18:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the devicetree
 tree
Message-Id: <20131031191854.f182b66eaf9e03d78e18e27f@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_Oct_2013_19_18_54_+1100_XxZE1KrCNiQEDWIW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_Oct_2013_19_18_54_+1100_XxZE1KrCNiQEDWIW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-integrator/pci_v3.c between commit 16b84e5a505c ("of/irq:
Create of_irq_parse_and_map_pci() to consolidate arch code") from the
devicetree tree and commit d7057e1de8d6 ("ARM: integrator: delete
non-devicetree boot path") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-integrator/pci_v3.c
index a87e510fe0c4,c9c5a33bc802..000000000000
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@@ -809,21 -808,22 +808,6 @@@ static u8 __init pci_v3_swizzle(struct=20
  	return pci_common_swizzle(dev, pinp);
  }
 =20
- static int irq_tab[4] __initdata =3D {
- 	IRQ_AP_PCIINT0,	IRQ_AP_PCIINT1,	IRQ_AP_PCIINT2,	IRQ_AP_PCIINT3
- };
-=20
- /*
-  * map the specified device/slot/pin to an IRQ.  This works out such
-  * that slot 9 pin 1 is INT0, pin 2 is INT1, and slot 10 pin 1 is INT1.
-  */
- static int __init pci_v3_map_irq(const struct pci_dev *dev, u8 slot, u8 p=
in)
 -static int __init pci_v3_map_irq_dt(const struct pci_dev *dev, u8 slot, u=
8 pin)
--{
- 	int intnr =3D ((slot - 9) + (pin - 1)) & 3;
 -	struct of_irq oirq;
 -	int ret;
--
- 	return irq_tab[intnr];
 -	ret =3D of_irq_map_pci(dev, &oirq);
 -	if (ret) {
 -		dev_err(&dev->dev, "of_irq_map_pci() %d\n", ret);
 -		/* Proper return code 0 =3D=3D NO_IRQ */
 -		return 0;
 -	}
 -
 -	return irq_create_of_mapping(oirq.controller, oirq.specifier,
 -				     oirq.size);
--}
--
  static struct hw_pci pci_v3 __initdata =3D {
  	.swizzle		=3D pci_v3_swizzle,
  	.setup			=3D pci_v3_setup,

--Signature=_Thu__31_Oct_2013_19_18_54_+1100_XxZE1KrCNiQEDWIW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSchJzAAoJEMDTa8Ir7ZwV5ukP/048UE0cA/WunX2Ft8BdPSnl
K4g75EAiLleTDZvq/oRMMVO/TLJLm2Jqr4Rv9h8EgJ2Sap0gzfvzt9ccRp1B0uOc
gfFwIlbbemh5spLfYJ0Zxn//immGkVMDIH504ZbrB1sDUYU5W8Ii4x5NixoRQ/08
qQnc6Av5s3k2ve3kx1QJ1DMebwulrgDXfNiHl9ZsgBSAvXM8wr0IOoD3D0i+8DX9
19IEflDBhBtbumFOABNsOW6Ucg4+8etXmVdHq5DM2wIkIan5wwntYCyk9iJimF+L
lgfUBsRJ2Jb80iOFiI/Q/lwV6MIot/gz7lwGooc8K9slgmhtwTmm+hh/EWnrI1bW
mjsroJefuxvMPqfEqCXTDMTYFGdWvP6qeBxxdCK+3vVaVcegkdFdyTXT/M5J7d+0
2QPfE/0xCdOdQBpCD5gXrNv45wdROaPFLwZo1otbD4GEEP7Bz28mbrcX4A5xJ479
PN9NiMgn2qAyoHezFh9BHLwxdc/vkXYev6ILUHlzRL6XVa/sP8ARLQgZZnRE1ovs
lIA1s9Ya/vkX+AU4Hg6AgO9jckXC6EoH3bsmai9z+ec8kU255uid9mgG64uoxo1t
M+b1Grd1+aJxU8bU+Ee6UfGCDUsf/Z7YR2+nbxLL9d8DNMLb65p6ga4BAMRtEY34
x+YcFPsAUc289aiRJtJY
=VSMB
-----END PGP SIGNATURE-----

--Signature=_Thu__31_Oct_2013_19_18_54_+1100_XxZE1KrCNiQEDWIW--
