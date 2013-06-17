Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3FQBmz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 21:42:55 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36601 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab3FQBmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 21:42:54 -0400
Date: Mon, 17 Jun 2013 11:42:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lance Ortiz <lance.ortiz@hp.com>, Tony Luck <tony.luck@intel.com>,
        Betty Dall <betty.dall@hp.com>
Subject: linux-next: manual merge of the pci tree with Linus' tree
Message-Id: <20130617114243.1f3f14901db4a4e38060daf8@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Jun_2013_11_42_43_+1000_n8MincDTM9PSiQJI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jun_2013_11_42_43_+1000_n8MincDTM9PSiQJI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

Today's linux-next merge of the pci tree got a conflict in
include/linux/aer.h between commit 37448adfc7ce ("aerdrv: Move
cper_print_aer() call out of interrupt context") from Linus' tree and
commit fde41b9fa2d0 ("PCI/AER: Remove "extern" from function
declarations") from the pci tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/aer.h
index 737f90a,55bb3dc..0000000
--- a/include/linux/aer.h
+++ b/include/linux/aer.h
@@@ -49,11 -53,10 +53,10 @@@ static inline int pci_cleanup_aer_uncor
  }
  #endif
 =20
- extern void cper_print_aer(struct pci_dev *dev,
- 			   int cper_severity, struct aer_capability_regs *aer);
- extern int cper_severity_to_aer(int cper_severity);
- extern void aer_recover_queue(int domain, unsigned int bus, unsigned int =
devfn,
- 			      int severity,
- 			      struct aer_capability_regs *aer_regs);
 -void cper_print_aer(const char *prefix, struct pci_dev *dev, int cper_sev=
erity,
++void cper_print_aer(struct pci_dev *dev, int cper_severity,
+ 		    struct aer_capability_regs *aer);
+ int cper_severity_to_aer(int cper_severity);
+ void aer_recover_queue(int domain, unsigned int bus, unsigned int devfn,
 -		       int severity);
++		       int severity, struct aer_capability_regs *aer_regs);
  #endif //_AER_H_
 =20

--Signature=_Mon__17_Jun_2013_11_42_43_+1000_n8MincDTM9PSiQJI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRvmmXAAoJEECxmPOUX5FExqYP/1PmBwaTG/Q2wVaeKpHQS5NQ
7n0/zcwHXwQyj7TCC2677xgmfOAk29nPPz8QVBgi6SRWwSjWxgeG6z4MrLLbtb4G
f6w1sqYQ4u+CtULGZu1wjZ9uX4qxUEm3jfMBfqzPJ8PDTP8Y+1E67LJ7eGMvricD
pePKQJWHripLzcpIYdvnl5mdbdZWEfBNVdX0YjUSowWsXhmxxDGmNUzeYmy0qCyU
d8RqeCOO4IKqlwxVXDL1dit96rbzqEOYF4hdv4iZahf/LabOzSlLLtwksOoNTC4r
Or+8y+n3elNkrwuuPNPEuCt8frTscxQRO7G344/sIOoyVGiCgW/7jjT4UhqDIRyb
zKZ5WSVDo1/MzMzZ95KaOJ8Sxxe/6UnVaTqDzTb6Pw9yT8EY7XMOsjP1SWSyY6Ux
KpXnWTAH41NOP4VWNHLaDvv05JT7bP/A4768TtAaRR56MXsjAnBk58xMFRaGLfZC
OTM1qlWaJJymD3sF8oPi9tbeYbGuNTtTjTV6PXds98T50dKaaoFDHhQo/V8+j1br
tXFdpGxe0cPf34WVOtrPJwXwtv+qj454qpJw/IP96X60rpHazLoB0XEXG41HItdT
nC3bfwywZFqxQOnjOGACVoz4w91QZCsUKH/1XyNpAXyxSprc3KwHvGHz2HMA5daT
AzRMakW4YtPRd8EmLv8b
=hYAb
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jun_2013_11_42_43_+1000_n8MincDTM9PSiQJI--
