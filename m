Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab3HSCl6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 22:41:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40941 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab3HSCl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 22:41:56 -0400
Date: Mon, 19 Aug 2013 12:41:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luciano Coelho <luciano.coelho@intel.com>
Subject: linux-next: manual merge of the wireless-next tree with the
 wireless tree
Message-Id: <20130819124146.cd0d6bcf86f013ea6a4e9ecb@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Aug_2013_12_41_46_+1000_hK+R6uSl0TN3qa0M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Aug_2013_12_41_46_+1000_hK+R6uSl0TN3qa0M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in driver=
s/net/wireless/iwlwifi/pcie/trans.c between commit eabc4ac5d760 ("iwlwifi: =
pcie: disable L1 Active after pci_enable_device") from the wireless tree an=
d commit 6965a3540a4b ("iwlwifi: pcie: don't swallow error codes in iwl_tra=
ns_pcie_alloc()") from the wireless-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/iwlwifi/pcie/trans.c
index 8c6c405,bad95d2..0000000
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@@ -1400,11 -1401,6 +1401,10 @@@ struct iwl_trans *iwl_trans_pcie_alloc(
  	spin_lock_init(&trans_pcie->reg_lock);
  	init_waitqueue_head(&trans_pcie->ucode_write_waitq);
 =20
- 	if (pci_enable_device(pdev)) {
- 		err =3D -ENODEV;
++	err =3D pci_enable_device(pdev);
++	if (err)
 +		goto out_no_pci;
- 	}
 +
  	if (!cfg->base_params->pcie_l1_allowed) {
  		/*
  		 * W/A - seems to solve weird behavior. We need to remove this

--Signature=_Mon__19_Aug_2013_12_41_46_+1000_hK+R6uSl0TN3qa0M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSEYXuAAoJEECxmPOUX5FEJcIQAKQ65TWdebN3fABucOe4tVVH
lGyOvPbyMdtGE81B2egDLUwE82ZLIzEk+r11/leO5QC05PQ4O7p1jhcUey1U0Sml
kBz9w5mdTSSiuCKqjSwHeJqNekCXZswUaNv21DLWiKdn5km5incXyrzzUHpEZVYw
VFVzVINjOiBPF9AgeLKXaCGInumrTo+Qt9vqV/AFGtQmKFxecms7SazoKacqkA/d
fD2V6KiK8tzvumPG9ocCqBmvmq1UXEumMVCkkqhxzu5nXYeay0VyKb4+rj2phzkJ
g1IO8vb8wuoi965/OdlkC9N4i+n18wjo17khacHTnvS1bawsYBN9kYPaEbcpX5t0
y2dEwdRI759iqjAYuOpggbA84IWCm7HblZnnLnlvTmZ+fa4vKTQVVKcHU/iRPjFB
wG42y6HwszrrMFy+5oAx45Vtfe2H6ww1KwGclmpT6o/e3FoNvwnSjdEGXFCSBA9O
jv8yYxWBH8fB5MXPAmR2lS+0Q59EY/wNBOs23jecxVi7gUvlYKaYJu64wkbxgICW
p0b8KYzuxz+MVBqFe+JP7l92YO26EBMibbpspFqwU5+pI/ZKHW9WTHpIHNDwCd/N
54xwXyNKGQUGB8IVe0P5Ty6pEL7jt4YFoht/8z3XgIKWqWpBcCuQGfl/k34iPC5G
5l80CSaYWe5eRP+iFbpB
=hsOm
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Aug_2013_12_41_46_+1000_hK+R6uSl0TN3qa0M--
