Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaI3H0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:26:43 -0400
Received: from ozlabs.org ([103.22.144.67]:34723 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaI3H0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:26:42 -0400
Date: Tue, 30 Sep 2014 17:26:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: linux-next: manual merge of the tty tree with the slave-dma tree
Message-ID: <20140930172632.78398c4f@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5luF3=_qzQJpTbudsRp6FLe"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5luF3=_qzQJpTbudsRp6FLe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/tty/serial/8250/8250_pci.c between commit 29897087d901 ("Add
new PCI IDs to cover newer Intel SoCs such as Braswell") from the
slave-dma tree and commit 1ede7dcca3c4 ("serial: 8250: Add Quark X1000
to 8250_pci.c") from the tty tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/tty/serial/8250/8250_pci.c
index 85a2eb986ffe,4f1cd296f1b1..000000000000
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@@ -1934,18 -1888,11 +1922,25 @@@ static struct pci_serial_quirk pci_seri
  	},
  	{
  		.vendor		=3D PCI_VENDOR_ID_INTEL,
 +		.device		=3D PCI_DEVICE_ID_INTEL_BSW_UART1,
 +		.subvendor	=3D PCI_ANY_ID,
 +		.subdevice	=3D PCI_ANY_ID,
 +		.setup		=3D byt_serial_setup,
 +	},
 +	{
 +		.vendor		=3D PCI_VENDOR_ID_INTEL,
 +		.device		=3D PCI_DEVICE_ID_INTEL_BSW_UART2,
 +		.subvendor	=3D PCI_ANY_ID,
 +		.subdevice	=3D PCI_ANY_ID,
 +		.setup		=3D byt_serial_setup,
 +	},
++	{
++		.vendor		=3D PCI_VENDOR_ID_INTEL,
+ 		.device		=3D PCI_DEVICE_ID_INTEL_QRK_UART,
+ 		.subvendor	=3D PCI_ANY_ID,
+ 		.subdevice	=3D PCI_ANY_ID,
+ 		.setup		=3D pci_default_setup,
+ 	},
  	/*
  	 * ITE
  	 */

--Sig_/5luF3=_qzQJpTbudsRp6FLe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUKlsuAAoJEMDTa8Ir7ZwVI5wP/iRSeUdhiKNE9kb+sdtif8nh
hZSv6nyi7ZRA3qeEJni+g5xpI0S3ng/o65Y7wshb1eJAPcMCNFHN31Dvjvu3sYgj
F33mxDhjjGbzDb420D25PV6YoXG0m/+VILIG4nMDQt2nVJWbCcERtgu9cBCPZ1An
S0R9eyVCjwnHtIgScmzicJfC72+dFip9f3vIDWekawB2iS/7sRgJMWl4VeBx9Zcx
I+g/cMC/WnZv6Tx/uLcEeakBHMCSCX/qOpPt9bSQp8kpA84ezzYq49rH87rtONZ7
vdtEbp/Wi2UOBopKQfpIWGlooDQou31BA3jE1ZUkBqjAuo2Y0svtu0gaElM8FpRA
LwCkSesjTnbFGDqU7LKIUNVPz8l9fdOLhbZGzLdTkRIg1+2Q8uyWf1OuVLSQO+hs
pHcQ4LK/nEOL1hTVTVOyRQ0MUUJYZH/TDnVp8Qz9Qczy9/HvcOv3ns64b5yOmcu8
AMIGxNVO1VaFfSHRIjEH8JzofWLL8RvSFQzKfVuxjrovheldxctooMqI9As6mAHE
t5xnACipyU0bcyTQEPpjfgyqpH1o1vQT2sJRHFj5Ewpo629L22N3uEip62iBRcgH
x7/aQgeFqwTVLDwI/6SUE2CB++VEK2kJ5TWMVHSF5H0D8FIIdDc5IXNwx5nWZODa
nJfDQedVYFk1AWtp8so6
=54AO
-----END PGP SIGNATURE-----

--Sig_/5luF3=_qzQJpTbudsRp6FLe--
