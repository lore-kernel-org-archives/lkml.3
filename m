Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934136Ab3BTB4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 20:56:11 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35180 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933616Ab3BTB4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 20:56:09 -0500
Date: Wed, 20 Feb 2013 12:55:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: linux-next: manual merge of the pm tree with the pci tree
Message-Id: <20130220125555.46e16e16836ba48f70beb3a9@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__20_Feb_2013_12_55_55_+1100_/qqWcsXtAX63EhfC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Feb_2013_12_55_55_+1100_/qqWcsXtAX63EhfC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got a conflict in
drivers/pci/pci-acpi.c between commit 181380b702ee ("PCI/ACPI: Don't
cache _PRT, and don't associate them with bus numbers") from the pci tree
and commit bc9b6407bd6d ("ACPI / PM: Rework the handling of devices
depending on power resources") from the pm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pci/pci-acpi.c
index c685ff5,e407c61..0000000
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@@ -307,8 -325,26 +307,7 @@@ static void pci_acpi_setup(struct devic
  	struct pci_dev *pci_dev =3D to_pci_dev(dev);
  	acpi_handle handle =3D ACPI_HANDLE(dev);
  	struct acpi_device *adev;
 -	acpi_status status;
 -	acpi_handle dummy;
 -
 -	/*
 -	 * Evaluate and parse _PRT, if exists.  This code allows parsing of
 -	 * _PRT objects within the scope of non-bridge devices.  Note that
 -	 * _PRTs within the scope of a PCI bridge assume the bridge's
 -	 * subordinate bus number.
 -	 *
 -	 * TBD: Can _PRTs exist within the scope of non-bridge PCI devices?
 -	 */
 -	status =3D acpi_get_handle(handle, METHOD_NAME__PRT, &dummy);
 -	if (ACPI_SUCCESS(status)) {
 -		unsigned char bus;
 -
 -		bus =3D pci_dev->subordinate ?
 -			pci_dev->subordinate->number : pci_dev->bus->number;
 -		acpi_pci_irq_add_prt(handle, pci_domain_nr(pci_dev->bus), bus);
 -	}
 =20
- 	acpi_power_resource_register_device(dev, handle);
  	if (acpi_bus_get_device(handle, &adev) || !adev->wakeup.flags.valid)
  		return;
 =20
@@@ -330,7 -367,10 +329,6 @@@ static void pci_acpi_cleanup(struct dev
  		device_set_run_wake(dev, false);
  		pci_acpi_remove_pm_notifier(adev);
  	}
- 	acpi_power_resource_unregister_device(dev, handle);
 -
 -	if (pci_dev->subordinate)
 -		acpi_pci_irq_del_prt(pci_domain_nr(pci_dev->bus),
 -				     pci_dev->subordinate->number);
  }
 =20
  static struct acpi_bus_type acpi_pci_bus =3D {

--Signature=_Wed__20_Feb_2013_12_55_55_+1100_/qqWcsXtAX63EhfC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRJC0rAAoJEECxmPOUX5FEAj4P/1z/Q/V7HbaDa9zRp5Q23GqP
1wgvtk5vXDdb3Ifv9IJEiwgWh6jEzNQSIz8u/OpncitAwOKlPWtaQr+oXOIqNJVA
Cf0DPONnuvgJofxBL7qFj9lcTGWCsKiLqZKev+CUQSO9pV0Rd5RU+ioAHCtoknNW
p+PKg3xqevReBVGdLHMkYqeq4Qf2B5Nd636ux0dmkFeBYAmdSIJL5iDs8wnxrRNq
fUTHXtNXG4Vwqz73Hb2TiVf+A4ARWsOWHjH1qHW+4l0NHSckFhZyjvtZn7K4pRv2
jNaW03zylnEBqfx18Sb0f7ALM2Kb3FtKAGoRBnigGE/3MG1uLjL48IzLAuKQqLPv
hGJKY0Cjvr3vqZvIsVAt+VS3scxc0edOFovOaChiFOcaShaTNKVzWRYqVAr9PF8r
pm6u59A9KDSy8GfvdIF4QSrqH5E15ttoL7vok+SrsLlnwiLW+CUzJ9MurzcEyAZL
PGlUQGI1WhUmTMAs4/DUcPNxwIIeAmfM4GgUd1xfAkvR90Kx9qLmrNIy2JMhLGZl
+GDUzJ+mCCUhpb/V5zDJ/TlAP5PhxSTRDNmu9VvUu13pdXblUbc0rmUdVEmXKCye
hLwYNJeH2H9WrqoyOBgYOW7KOFQzlFfeyzJvlijlx8OAhM+ilFnxZx0SxKi7/9P9
oaGENlf0+dF2sRDBAj46
=mIH1
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Feb_2013_12_55_55_+1100_/qqWcsXtAX63EhfC--
