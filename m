Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab3BRBLV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:11:21 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36628 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab3BRBLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:11:19 -0500
Date: Mon, 18 Feb 2013 12:11:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: linux-next: manual merge of the pm tree with the pci tree
Message-Id: <20130218121105.e728f240b75b73821ff8058d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Feb_2013_12_11_05_+1100_JtfQKZsgFDvRwowz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Feb_2013_12_11_05_+1100_JtfQKZsgFDvRwowz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got a conflict in
drivers/acpi/internal.h between commits 668192b67820 ("PCI: acpiphp: Move
host bridge hotplug to pci_root.c") and ab1a2e038ff2 ("ACPI / PCI: Make
pci_slot built-in only, not a module") from the pci tree and commit
00c43b968250 ("ACPI / PCI: Make PCI root driver use struct
acpi_scan_handler") from the pm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/acpi/internal.h
index e09ce03,7909232..0000000
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@@ -67,13 -94,6 +94,12 @@@ struct acpi_ec=20
 =20
  extern struct acpi_ec *first_ec;
 =20
 +#ifdef	CONFIG_ACPI_PCI_SLOT
 +void acpi_pci_slot_init(void);
 +#else
 +static inline void acpi_pci_slot_init(void) { }
 +#endif
- int acpi_pci_root_init(void);
 +void acpi_pci_root_hp_init(void);
  int acpi_ec_init(void);
  int acpi_ec_ecdt_probe(void);
  int acpi_boot_ec_enable(void);

--Signature=_Mon__18_Feb_2013_12_11_05_+1100_JtfQKZsgFDvRwowz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRIX+pAAoJEECxmPOUX5FEE2wQAKQ7yqNCPNPpLiN69e4vkYkE
fx8Vk9u3vNS8mDSc8jQbgeV00OJUcgTU80gtKNW9YfsvFrOxMFlTXD7SjfDnbqTO
H5hxDYajgmGFhwKad9LS5HjkKxpZJ0W9RQhT6VORC65B1QTUpS5BTzffsX9tJoaa
ACoqlq2l50DfJ41oKcgTCPE6XxYfWkLoFHwpWhEI4jFslcpVJzIz+EXqAVQCn6hy
qVXHySI6I/hooCPOQgTRlo3MAvmmcf03E754YGCND9Zz+i8CJSp8/kPgcVLGH+54
kmsDbnJY9qARG7CyXUC3o6TBnGTUtXDsjuMH2KKcI2/5QrJ7VjLI/+N33nY63nFN
8EYU54mBRviP/S+o+qwYDMdlD1nUhQwtz2GZdJnB1Y+16a3KlDaftWlvCFCNrRHc
iP9Z3X3JAwJbQEUJ+gLVaULII8uK7PImbiqtM1u4dwk90/X8NWVT1kGjI4YRDU9m
IlubVRmd62xz9vgJtKQmx1J+fX3Or/NR6VBrBOKjGqXbi90UkfRn99bwth+NPNzi
IRhJ/s7e4KEUpvhet0Y4cCAy7LEBEN9kbB808wz4msEKa7lx+SSTFf9qi9Z6NLo9
34KQwRAJ2oO//5w85A7hKJ/M+fA7FnKJjGpSvpZPfqt3uD+7C8owB9j2APWVBVjj
0qKg4brK+PYvHqmQxU+w
=NgRS
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Feb_2013_12_11_05_+1100_JtfQKZsgFDvRwowz--
