Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935501Ab3FTBgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 21:36:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36732 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935237Ab3FTBgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 21:36:50 -0400
Date: Thu, 20 Jun 2013 11:36:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>, Yijing Wang <wangyijing@huawei.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: linux-next: manual merge of the pci tree with the ia64 tree
Message-Id: <20130620113636.9658fab2af8a67231093a462@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Jun_2013_11_36_36_+1000_xtCQbcbCc1ALYHRx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Jun_2013_11_36_36_+1000_xtCQbcbCc1ALYHRx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

Today's linux-next merge of the pci tree got a conflict in
arch/ia64/sn/kernel/io_init.c between commit 2ead66b54725 ("PCI/IA64: SN:
use normal resource instead of pci_window") from the ia64 tree and commit
a649dbfea36b ("ia64/PCI: Clean up pci_scan_root_bus() usage") from the
pci tree.

I fixed it up (see below - this could clearly be done better) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/ia64/sn/kernel/io_init.c
index 2b00ade,e2c7733..0000000
--- a/arch/ia64/sn/kernel/io_init.c
+++ b/arch/ia64/sn/kernel/io_init.c
@@@ -269,16 -326,7 +269,14 @@@ sn_pci_controller_fixup(int segment, in
  	bus =3D pci_scan_root_bus(NULL, busnum, &pci_root_ops, controller,
  				&resources);
   	if (bus =3D=3D NULL)
 -		kfree(controller);
 + 		goto error_return; /* error, or bus already scanned */
 +
- 	bus->sysdata =3D controller;
-=20
 +	return;
 +
 +error_return:
 +	kfree(res);
 +	kfree(controller);
 +	return;
  }
 =20
  /*

--Signature=_Thu__20_Jun_2013_11_36_36_+1000_xtCQbcbCc1ALYHRx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwlypAAoJEECxmPOUX5FEOvoQAJFOrh+5oafzeOiAq2Nb75Ko
F79631hR5eWNX+hsUJiOW+1wBVZvWXo/z2YX9wnIyLWDunG/vkKQaWq1quONvPk6
5vEyMVdYta6Z1vAY0ebcdGBGiahOTPxIBUxdLzboJbWEHa8cpIU6l+GHSQ6OOIu1
V+RNkgie3jox0Nu5tCV+zFabEnNNAWL921rUum1LJujauG44X0fxdTUTPhRrnI7U
pNj6VEDbQRwP7IJUr1hkt8qTxQR1Q/OZCyFeWAZpuUoI7fHb/sJmj4p8t27FI+bM
wDFRoBzgModU4iblY/jAS17ghPW7BH6jtqD5b191SrJ5B/CiutiJN1jv7NRa+mAh
ZUqg9fJUFiHoB7hCBKiPNc12xWXCXcEHDNR105EY18/eKYyL5JtUMn4ZMY14lek3
2QnejI+quacSLZKBamaxr7xYE7erapYpjXOpRg05BTSOENuLEQq434NtuPd+U2Ve
kT4NftUfHoQ2H8Qh2JSVElTF3YyHLvQ5AxRnJSFil0fKEqTz/EwRmfSf6UgDjz1E
qo1jqsAfHvCYUq2abswxrRz/NYr6zxwRmziUA/Pkc2ofyT8DLI4h54Fd0nFFlaCG
DcVzR3Ol8QYdSrpwIxke+vw+ECniPNOIEA9LqcSzNLknaUPnFW0hxoxYf5dgEiit
P/+q6Vj+bnPm3kb8NrUQ
=1cr6
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Jun_2013_11_36_36_+1000_xtCQbcbCc1ALYHRx--
