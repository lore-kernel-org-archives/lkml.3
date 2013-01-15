Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab3AOVO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:14:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54854 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab3AOVOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:14:55 -0500
Date: Tue, 15 Jan 2013 22:14:41 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Andrew Murray <andrew.murray@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
Message-ID: <20130115211441.GA13139@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130114095706.GA23467@arm.com>
 <20130115120855.GA5637@avionic-0098.adnet.avionic-design.de>
 <201301151244.12767.arnd@arndb.de>
 <20130115154038.GA11241@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <20130115154038.GA11241@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:wQbunxv8kKmYX08mdAqBuyHCSwavE8ORX7O7KI6v5+W
 V2IQe/hMh45twp114rCBvkw6alurprT49ilc5xRiZblgSDCrnv
 2f+jryNuixpRaZggnaZkAkPqq3pVE21G3eyMtrAq1INlRtfJP+
 2dJNSRnRaEyRA/QT1EoygpuVBtSgMeDgzlrZ8TTd9AFV1YLLok
 s/ahKQIYaMgU9Gpu37U+F+cGB2TssV4xORM8KJctiOilIUqvED
 Oz+Oe7bknLAxFLSBnI93+KrAqK7x97YmHHJbxy/07FD23527Qm
 T95RYoIbUFrM7dkv1JtXAPdGhWbfFRnOQe1x9W8Iy0YP9jaPlK
 dIsUJsyl0A977PEYWLawHt4hw157NU8bd+y1SHvMbsXj8slO9g
 uX1tlmw7newNjfG0mrDq8GSbg4BZt3+C+4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 15, 2013 at 03:40:38PM +0000, Andrew Murray wrote:
> On Tue, Jan 15, 2013 at 12:44:12PM +0000, Arnd Bergmann wrote:
> > On Tuesday 15 January 2013, Thierry Reding wrote:
> > > I'm not sure I follow you're reasoning here. Is it possible to use MS=
Is
> > > without PCI? If not then I think there's little sense in keeping the
> > > implementations separate.
> >=20
> > Conceptually, you can use MSI for any device, but the Linux interfaces
> > for MSI are tied to PCI. If you use an MSI controller for a non-PCI
> > device, it would probably just appear as a regular interrupt controller.
> >=20
> > > Furthermore, if MSI controller and PCI host bridge are separate entit=
ies
> > > how do you look up the MSI controller given a PCI device?
> >=20
> > The host bridge can contain a pointer ot the MSI controller. You can
> > have multiple host bridges sharing a single MSI controller or you
> > can have separate ones for each host.
>=20
> Yes and I hoped this relationship would be described by a device tree pha=
ndle
> as is done for relating devices to their interrupt-parent (where device t=
rees
> are used). This would provide (arguably unnecessarily) greater flexibilit=
y,
> e.g. if you have two PCI/MSI controller pairs, the MSIs only offer limite=
d MSIs
> and you only use one PCI fabric - you could service different parts of the
> fabric by different MSI controllers (assuming you relate MSI controllers =
to
> part of the fabric and that you'd want to). Perhaps there would be benefi=
ts for
> virtualisation as well?

Is there actually hardware that supports this? I assumed that the MSI
controller would have to be tightly coupled to the PCI host bridge in
order to raise an interrupt when an MSI is received via PCI.

Thierry

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ9cbBAAoJEN0jrNd/PrOhtl4P/jFRPjJMBYsIefiaxa04+iqT
3x9QHWpfSoQabBZedImODOBW//x/WY95wzU1svRNSn9KRP57HNoI1dSetfx7dsxv
UWJ5lklcJjfBCgj7m2WyG9V9Oh1YrZYJ006pie/Qi5i4YsVuLwAbXc5HyhwHHBzZ
/Xm3QRPqAyXHY/mWLdqRDMMC0EntcfK6VxiM7vGyhYlFDu/0Vok7leXUXu1KB4/c
yDVHB7miuzYAqX4BhrCk2Qvyt2vB7+EU40ZNOahWOJA0IYY9PcAHN36/WB6JKxFu
6my0R/Hl9XqsLim6e8nEbE6oglNnDgSITjKD+GHrQ7Jk+crhUyLBWbJpRpDVCI3Z
TqKhJgaHB5nOal4aCy3rCWx9Bzg6IT+LN3xGjLtzx3OxwCbDAdDjTO9knF4FEu3h
QlRMcx0Nm/vKmXE8GSeDBvjbDIoz6fAILZoIhDYG7cAcjeshDuUYLa9ZKJDxrsZU
VlVI51jMty+wLcAY9yVL3TYo/pPH96Iw4xNPC7gGSFe/QELh7coynxeEOjGxcC1C
BuuJrVP3iN1ozDsdU4N5sBqJMnn2yiuIHxznScPifa/9TK44OcmDffKUFOOYOXTV
raEZJjmFfCQqQf7FWdQcgK7KEYLB+5rAPhJxw+kdA5D5y8t6IFBTPn1faIf9e2XE
SQaQ+rKu8bPN9+wyPtr3
=JrIc
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
