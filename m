Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3HLBxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 21:53:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49364 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab3HLBxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 21:53:37 -0400
Date: Mon, 12 Aug 2013 11:53:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: linux-next: manual merge of the wireless-next tree with the
 wireless tree
Message-Id: <20130812115327.7bcbb203ac8614d16d32ba52@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__12_Aug_2013_11_53_27_+1000_Mwz1=7V6r1_BAeaa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Aug_2013_11_53_27_+1000_Mwz1=7V6r1_BAeaa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
drivers/net/wireless/iwlwifi/pcie/trans.c between commit eabc4ac5d760
("iwlwifi: pcie: disable L1 Active after pci_enable_device") from
thewireless tree and commit f2532b04b2ec ("iwlwifi: pcie: don't disable
L1 for newest NICs") from the wireless-next tree.

I fixed it up (maybe - see below) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/iwlwifi/pcie/trans.c
index 390e2f0,e52d1ce..0000000
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@@ -1502,16 -1400,22 +1400,22 @@@ struct iwl_trans *iwl_trans_pcie_alloc(
  	spin_lock_init(&trans_pcie->reg_lock);
  	init_waitqueue_head(&trans_pcie->ucode_write_waitq);
 =20
 +	if (pci_enable_device(pdev)) {
 +		err =3D -ENODEV;
 +		goto out_no_pci;
 +	}
 +
- 	/* W/A - seems to solve weird behavior. We need to remove this if we
- 	 * don't want to stay in L1 all the time. This wastes a lot of power */
- 	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
- 			       PCIE_LINK_STATE_CLKPM);
+ 	if (!cfg->base_params->pcie_l1_allowed) {
+ 		/*
+ 		 * W/A - seems to solve weird behavior. We need to remove this
+ 		 * if we don't want to stay in L1 all the time. This wastes a
+ 		 * lot of power.
+ 		 */
+ 		pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
+ 				       PCIE_LINK_STATE_L1 |
+ 				       PCIE_LINK_STATE_CLKPM);
+ 	}
 =20
 -	if (pci_enable_device(pdev)) {
 -		err =3D -ENODEV;
 -		goto out_no_pci;
 -	}
 -
  	pci_set_master(pdev);
 =20
  	err =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(36));

--Signature=_Mon__12_Aug_2013_11_53_27_+1000_Mwz1=7V6r1_BAeaa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSCEAbAAoJEECxmPOUX5FErOEP/09pnS34ZHeiAxPdzgIi6y5A
+aeaQLwlODyxBWjLleU09bSaexqNUbL1NELSmTAtEIfM40B/55fMUR1yTChIC6I4
aQ0Ldif1mCyui05aoPabA5W2ERHafVU/G4wZfT0FX8WPL0ufO5/gDXGVSG9jn1UO
Qm0WRKO5ehK6pi6jHyNvzLEkpb4m2NlmFrB3kyiy1fqYe5zCm+xLQkrD9NrcDRji
x7rt0dRMCSjRFosz9XMH6IKyOkwivTuIetJXH6Jxejx5Qofzt9jIXubrbuFJ5EHY
tr9ScGDD5HyCWQWK2bHYt0dKQL7/oAF/BGjBrYux+/k/QGlZBN9E2t6i6YG7oWwT
rFKJ4L0mxAWPacghoeUhSi8hksYLmrqIJbtZoPMvmFhbPwAMyOazV8INXuR8ot6/
r7kBdS3ukbltWVFBYMpo3MaJ4xY3PN3Ke0Wnb1FGgdefTAw62/8oj8AiHBJCQWY2
+qgvUwbXnYEifxpQJhQ4jB0oBanlkjNvoxiu67AXIqmv2RAujMxiiG500DYOUtr0
TvU+JTFlm6KGJQiLMayB+DghkmI080+vGU4EuViHiRjH6juiTxTeFD4qyxII4HUL
05lny5fqEmmsGv8Ji19Yiy8l+1CLltapxDWEu0MGPnIetcWSHrfSiYxmiauY4WgG
ARPblKx2j3N5MmkSo0E3
=Nt/8
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Aug_2013_11_53_27_+1000_Mwz1=7V6r1_BAeaa--
