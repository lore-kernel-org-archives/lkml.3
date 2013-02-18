Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab3BRBRL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:17:11 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56080 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab3BRBRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:17:09 -0500
Date: Mon, 18 Feb 2013 12:17:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: linux-next: manual merge of the pm tree with the pci tree
Message-Id: <20130218121707.221f3f24673d92066b6603ad@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Feb_2013_12_17_07_+1100_wjG/1MsW4xrGGFhU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Feb_2013_12_17_07_+1100_wjG/1MsW4xrGGFhU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got a conflict in
drivers/acpi/scan.c between commits 668192b67820 ("PCI: acpiphp: Move
host bridge hotplug to pci_root.c") and ab1a2e038ff2 ("ACPI / PCI: Make
pci_slot built-in only, not a module") from the pci tree and commits
4daeaf68379f ("ACPI / PCI: Make PCI IRQ link driver use struct
acpi_scan_handler") and  3757b94802fb ("ACPI / hotplug: Fix concurrency
issues and memory leaks") from the pm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/acpi/scan.c
index d9ee41e,daee749..0000000
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@@ -1685,10 -1778,13 +1778,14 @@@ int __init acpi_scan_init(void
  		printk(KERN_ERR PREFIX "Could not register bus type\n");
  	}
 =20
- 	acpi_power_init();
  	acpi_pci_root_init();
 +	acpi_pci_slot_init();
+ 	acpi_pci_link_init();
+ 	acpi_platform_init();
+ 	acpi_csrt_init();
+ 	acpi_container_init();
 =20
+ 	mutex_lock(&acpi_scan_lock);
  	/*
  	 * Enumerate devices in the ACPI namespace.
  	 */
@@@ -1708,7 -1804,7 +1805,9 @@@
 =20
  	acpi_update_all_gpes();
 =20
 +	acpi_pci_root_hp_init();
 +
- 	return 0;
+  out:
+ 	mutex_unlock(&acpi_scan_lock);
+ 	return result;
  }

--Signature=_Mon__18_Feb_2013_12_17_07_+1100_wjG/1MsW4xrGGFhU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRIYETAAoJEECxmPOUX5FE7w4P/i8rt7hPbmoxkbhdPxmqlMf6
M2few1k/qwV/04fw6fNU1xpuFba9GGGxxdY31MmdaHUyiOjr/cC9tD+ZhisuAz+f
tQK+DAjK4TlKwP0Q4qT4haBAqNHM/VahUeZt1zX3kA+VmjreMyvRr86QAXhfJHRt
x8FguyoQMMDwIx5OFvmeegla14XicIRQuDknqrZ48BhcauU9q4VycxZlV7ty+8mK
p8LBK4cOrp6jxTcBJMsAKopCabLAzURz4/waRB1ewEEjTw/QfcXXVRvkUn+J3W+N
CFo4sYwRlXZOlME8HDbCJEExG+7LHqTNUA2T5Lo++8aMEY+PGTFsBonl/hjCprOo
QhM7I6k0ten2xXXKrnHLlgkuvIBPvsB2PCSrWv4XeIsbdwCgfXDL/zAjiiQo3TlZ
tK2eEFYEzljn43hQFAyrZm1erjfwK0sBmhljeTNBG8gr4KwNEEdNYkv9NMOsRZGf
mHsgDlF+2xaEzi7IvaJt9rP76uR+/xRr7SvHPUYhUZG5howvy0AQe0x5wRJt7b0E
gw9Z+1rY8pmk7OTqSt1Gz21JE4ktgOe/RfbEwR4eEAY60EcE+tnyHXLfcmvV9KZA
/yMVhbJYdjFdWqAcLZ9jQ/h3L+5BsNlGV/apyHxSqjdfFCBOX0T0vwcCMSbICLC6
lR7b19oMw9JgItsAftQh
=MAwK
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Feb_2013_12_17_07_+1100_wjG/1MsW4xrGGFhU--
