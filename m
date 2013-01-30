Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3A3IgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:36:05 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48850 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3A3IgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:36:03 -0500
Date: Wed, 30 Jan 2013 19:35:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: linux-next: manual merge of the pm tree with the pci tree
Message-Id: <20130130193551.075bfa10acd39aec315a7787@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__30_Jan_2013_19_35_51_+1100_1xNgv2TVye5Q/n_g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Jan_2013_19_35_51_+1100_1xNgv2TVye5Q/n_g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got a conflict in
drivers/acpi/internal.h between commit 668192b67820 ("PCI: acpiphp: Move
host bridge hotplug to pci_root.c") from the pci tree and commit
2c545601d933 ("ACPI / PCI: Make PCI root driver use struct
acpi_scan_handler") from the pm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/acpi/internal.h
index 0f24148,0d1397d..0000000
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@@ -67,8 -89,6 +89,7 @@@ struct acpi_ec=20
 =20
  extern struct acpi_ec *first_ec;
 =20
- int acpi_pci_root_init(void);
 +void acpi_pci_root_hp_init(void);
  int acpi_ec_init(void);
  int acpi_ec_ecdt_probe(void);
  int acpi_boot_ec_enable(void);

--Signature=_Wed__30_Jan_2013_19_35_51_+1100_1xNgv2TVye5Q/n_g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRCNtnAAoJEECxmPOUX5FE0ZIP/A8qzGfsG+KzuzWVKGB0o+7w
aTTdLdmyzTAauJ3Jsu7b7QSUTbOcVpbB6YMvdwZ3nbyCNpLujs3oipKm9VHr5g6J
7em4abSmJyzdtYRvFb1cxfHjWmnu7EMBAF6l8sco8TtFSoPBHeZpBT5VsR7INvPm
bqmQ0SOmoN3tEXqYrs3xHY2wprDigE7PYvNbatroMi+A0y7ypi7zTObp7+UoDCr1
BNUCJKnuLPRi94E83ZVASheAQvyYrgxx8XkAuEk6cRtCASrzba6BoeHU7JvIaepb
Pv/BdX/WwUYVuPFrMKvkouVrwT5V/y6U0EKJ489wfs3gkmN0n7ypmlv3YvZVbC9m
MB/1j6COujZHQpWz9eVnQ04JRdId3FldZHpWTVcEQfERHmtihq3ONbVDix+f5fLb
gPSUNappzrFlKDhD4k3mJZDqxc97GRpR1GeTxmZdfjkFG8QLEjCyGev1g2xnvAYh
DWZqJc/Cw5o3KtQ46BrO4hvz8/08kf6xnaM9rrzw2qi87pj+tvZheBN8W3549HRB
oEZlqHtvyiDkCA07SfGU0mNWkUtFwVaZD9g2uR69wwKDW0LtCY2q0R/E4v2hpeD6
ssL9bDAiHB6hLEtzUxt9gjmf1OwQOOWToESm85cQg/D5jI6hkiRot1M4F3rak0Vl
cRdpeGWqpM4KaJu9Wvg2
=Jq1e
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Jan_2013_19_35_51_+1100_1xNgv2TVye5Q/n_g--
