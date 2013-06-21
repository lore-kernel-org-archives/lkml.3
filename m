Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab3FUGOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:14:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37810 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758359Ab3FUGOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:14:49 -0400
Date: Fri, 21 Jun 2013 16:14:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suman Anna <s-anna@ti.com>, Sricharan R <r.sricharan@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the arm-soc tree with the mailbox tree
Message-Id: <20130621161447.aa6c3eac42d9f1d26e39bc5f@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Jun_2013_16_14_47_+1000_cjpdhPN8TQQRT4d="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Jun_2013_16_14_47_+1000_cjpdhPN8TQQRT4d=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap2/omap_hwmod_44xx_data.c between commit 4a1c0e83bb4e
("ARM: OMAP2+: mbox: remove dependencies with soc.h") from the mailbox
tree and commit 3b9b10151c68 ("ARM: OMAP4: hwmod data: Clean up the data
file") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 4065962,d04b5e6..0000000
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@@ -1862,22 -1573,6 +1574,17 @@@ static struct omap_hwmod_class omap44xx
  };
 =20
  /* mailbox */
 +static struct omap_mbox_dev_info omap44xx_mailbox_info[] =3D {
 +	{ .name =3D "mbox-ipu", .tx_id =3D 0, .rx_id =3D 1 },
 +	{ .name =3D "mbox-dsp", .tx_id =3D 3, .rx_id =3D 2 },
 +};
 +
 +static struct omap_mbox_pdata omap44xx_mailbox_attrs =3D {
 +	.intr_type	=3D MBOX_INTR_CFG_TYPE2,
 +	.info_cnt	=3D ARRAY_SIZE(omap44xx_mailbox_info),
 +	.info		=3D omap44xx_mailbox_info,
 +};
 +
- static struct omap_hwmod_irq_info omap44xx_mailbox_irqs[] =3D {
- 	{ .irq =3D 26 + OMAP44XX_IRQ_GIC_START },
- 	{ .irq =3D -1 }
- };
-=20
  static struct omap_hwmod omap44xx_mailbox_hwmod =3D {
  	.name		=3D "mailbox",
  	.class		=3D &omap44xx_mailbox_hwmod_class,

--Signature=_Fri__21_Jun_2013_16_14_47_+1000_cjpdhPN8TQQRT4d=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRw+9XAAoJEECxmPOUX5FEIukQAJ48IC6kBiiWpOCypYZxKa1r
qBCMjCvx28B6ZkBC6hNIFcuWBy/e+RJkkgjzoXstilNnKAVUzb4WcTBRsRHf9W1S
25CUkWXRPY5SBrqE2i/mlfFQyfkq9z8bsVOZhSn+Qy/tGUljXsDFF5J8TLq0I0SY
Ius2pKlK7WQ0+Y+6y0ICgJtRk/qSeyYl97jO/en70SlBwwwNvwkU7kAYtg4LIx7t
J3g83jSsKwQLd94mIOJk9jr259EuorojgP6Ohk+RVIrS/nF9Q59CFkw3BbzcXagR
K6PIBqSN0RL9GwI2aJzEYCaD0O5g/ieurTkwoxn87FROgNk3qNGHPW92ruclKKJf
0PeUPHrUnusWxnuWMr3GgKOL04flauDJVujTclOSUvru0EOnpOC78RlN9eQ2s4HS
1okt1NTMgjDqgUqAIymE40jWIdLPKBXGnHLpzC4FlJamHUCc19EA1EDteokqJquf
P5Bo4PyDSpr5ejRRdHoXUMZ5dGILRjW+GwZPiwpvfLvaIFwKiDQeKxTuyWCzn8P0
qRkZbzB63rIkI/o9ZKdwcuXffdVXZieNB+csESH8rzuT6sYTsER53bJkMm2gqNBE
TTGQ8p9MSuVR8guw2Wz9YvyUQjFXP4IGK/U5GEwJiio+W6ImyeMGV9Lu8YLj0uTH
E6LLRpl/NXBCDlPlA7mt
=YCHa
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Jun_2013_16_14_47_+1000_cjpdhPN8TQQRT4d=--
