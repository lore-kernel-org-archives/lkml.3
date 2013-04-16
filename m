Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935365Ab3DPCqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 22:46:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54150 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935183Ab3DPCqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 22:46:22 -0400
Date: Tue, 16 Apr 2013 12:46:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: linux-next: manual merge of the pm tree with the pci tree
Message-Id: <20130416124611.3dd55ea49fc6724e0994ed8e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__16_Apr_2013_12_46_11_+1000_CpyGK.6Whi9nffV_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Apr_2013_12_46_11_+1000_CpyGK.6Whi9nffV_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got a conflict in
drivers/acpi/scan.c between commit 5c0b04e3d913 ("PCI/ACPI: Handle PCI
slot devices when creating/destroying PCI buses") from the pci tree and
commit 0a34764411aa ("ACPI / scan: Make memory hotplug driver use struct
acpi_scan_handler") from the pm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/acpi/scan.c
index f54d198,d7f3c8b..0000000
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@@ -1788,8 -2041,11 +2041,10 @@@ int __init acpi_scan_init(void
  	acpi_pci_root_init();
  	acpi_pci_link_init();
  	acpi_platform_init();
+ 	acpi_lpss_init();
  	acpi_csrt_init();
  	acpi_container_init();
 -	acpi_pci_slot_init();
+ 	acpi_memory_hotplug_init();
 =20
  	mutex_lock(&acpi_scan_lock);
  	/*

--Signature=_Tue__16_Apr_2013_12_46_11_+1000_CpyGK.6Whi9nffV_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRbLtzAAoJEECxmPOUX5FESXsQAI7c/xr9I1II6aYbiHwSOrsy
t71xEPSQyR964q4yMvKwcjSUOLOBIR9RyseSSPBMqotyQMMHkjMrdSYCOy/bE2tD
lDi4b4OWcz8V0S3Syk2MuuAP/dhZLpeA2MIb97LMoEXjc3g/g19qK2EfKMLHyQv+
7BxAA83kgQfMmDgYYj9R5k/fbDLGC5iQTDd6CTCI0wtQPDOrHeOcn+F5+091aMLr
pMFyI7c8+z6BGLpTgit3BpT5/GFuphfvT1J4ZyADbQt/FLOO70GnDexnGqbmZZml
FoP1QDv3dBAfQ8S/yHRpTM6cKXrM+NXtKsEqQEpzFx+CQt9mBA066W2Tj0USPbZg
ZMcLLLl7r3X77PUeSO1AQ0gBeb2FY+vMmS+Iyp/gy8D56GB+ta6x6TsZ8Yt0vhSw
e/9M1O/QN7Y1LpTO7kHEypj28kJFWiKR+0tgGLSQy8RakNLlHAOFeWYnmhTT/VNW
jnoyjABpS2XwuPS+PfGYuJ5x/EY9qliWvUUhLEXU8PVJqAmxnzBnNW522oKG4lSS
AJSrXUzlhs8RW1JZj6Eof+vyNEd2QXuPN/mbkKy8LMFvKBWW/ojhTLgBsoT1wvSN
s7uooJshNH9oedoNTNcDyEaKJNoIFh08af5Kq5iW1I5cuYtc/Ja6kxFlSwo8JOMq
nJ4Q7Th16ZMCbpI1lTSz
=ekBo
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Apr_2013_12_46_11_+1000_CpyGK.6Whi9nffV_--
