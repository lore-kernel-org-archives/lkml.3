Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab3AQQGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 11:06:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56846 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757138Ab3AQQGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 11:06:04 -0500
Date: Thu, 17 Jan 2013 17:05:02 +0100
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
Message-ID: <20130117160501.GC2186@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130115154038.GA11241@arm.com>
 <20130115211441.GA13139@avionic-0098.adnet.avionic-design.de>
 <201301161400.26587.arnd@arndb.de>
 <20130116161716.GA10630@arm.com>
 <20130116183101.GA28660@avionic-0098.adnet.avionic-design.de>
 <20130117154236.GA25943@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2JFBq9zoW8cOFH7v"
Content-Disposition: inline
In-Reply-To: <20130117154236.GA25943@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:7dXcUhPsqHUfq1EetOZ3uYdkJqJVAdVVmhyOQjYy90M
 a/+QhVYMOvt1jjhrEuFLaSqjlCVOqEtJcbFqNEQ0PaPUzchBk3
 w2yb/9MjPQQd1koX7QoauBA70EqUfCVRxTPLrBe3vQRJWw22Gk
 yo1HExu1P5+kOr+xXIc9FGcfSigK43/MMstmOjEwtZx7U1vSKQ
 Rike0/LhFi41p8XCgWiJwLE/UKUXxPn1Iz5KIBiNsL+E7cOd/E
 9ormAmXma4oFxjFhvmHuTmKKSidp1l02X1uAbiSdWhPTWDnEg9
 7OnE9us1S6PWMiFGU3DwIQ74EOPjU9eXxyQf+0y0uzHUcol1HS
 uZ+sKWTJB0SXaMOolByWnNj8N2Lx/0nKRiFJy5oVDz8pCfNtdw
 5J/CfI+SqmR+wB/mb2fqs8H0eYw5eeFWuc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2JFBq9zoW8cOFH7v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2013 at 03:42:36PM +0000, Andrew Murray wrote:
> On Wed, Jan 16, 2013 at 06:31:01PM +0000, Thierry Reding wrote:
> > Alright, putting the functions into pci_ops doesn't sound like a very
> > good idea then. Or perhaps it would make sense for hardware where the
> > root complex and the MSI controller are handled by the same driver.
> > Basically it could be done as a shortcut and if those are not filled
> > in, the drivers could still opt to look up an MSI controller from a
> > phandle specified in DT.
> >=20
> > Even another alternative would be to keep the functions within the
> > struct pci_ops and use generic ones if an external MSI controller is
> > used. Just tossing around ideas.
>=20
> I think an ideal solution would be for additional logic in drivers/msi.c
> (e.g. in functions like msi_capability_init) to determine (based on the
> passed in pci_dev) which MSI controller ops to use. I'm not sure the best
> way to implement an association between an MSI controller and PCI busses
> (I believe arch/sparc does something like this - perhaps there will be
> inspiration there).
>=20
> As you've pointed out, most RCs will have their own MSI controllers - so
> it should be easy to register and associate both together.
>=20
> I've submitted my previous work on MSI controller registration, but it
> doesn't quite solve this problem - perhaps it can be a starting point?

We basically have two cases:

  - The PCI host bridge contains registers for MSI support. In that case
    it makes little sense to uncouple the MSI implementation from the
    host bridge driver.

  - An MSI controller exists outside of the PCI host bridge. The PCI
    host bridge would in that case have to lookup an MSI controller (via
    DT phandle or some other method).

In either of those cases, does it make sense to use the MSI support
outside the scope of the PCI infrastructure? That is, would devices
other than PCI devices be able to generate an MSI?

Thierry

--2JFBq9zoW8cOFH7v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ+CEtAAoJEN0jrNd/PrOhVKwQAJaDTjXx1NQRUhFQU8TpJTW7
ldgQIySDQLUC9qo21QLUyfk7IeNL+av2WtmabqVc3eb1vLAoMH+EU5VRQjpD9XgO
fErTEhZcykifUcqHPDHOXQAMBGz9SRZ4K2644r+6tWO6kt5VtFTNNpeFxPVKzfAK
3y5rtwK9gnqaIHOizl+4rA4cRD8PPkcH1scd8A2WS8BioSuowDx2I/gSWZeNAFJb
oKsUixZa9kUwjJm9HEZRbaDf89PEOfNhu4uDqHXMyqGXeKgKYflcBPwPCusTtYOO
e/nEF1/oJJHqmwR8HLHXV8O74oCVmN++9yuvGjCC0oOAS0EbZdTJffeLwWDJZz7y
+Hmag0ZvGgkSKqdK8Sylf2y2uYzwTnMCWCh0USuI5yhpnZGAUR/8Tj1oqM29RL6q
rkC/1EnPryWU6EzHd/MBdzFCloBVH+x6Aw5LHrJEUv5Laj4gdSp7RmIA8fddo9VF
tuJbpjBGCpC0HFNyquX/dudScG1KOA1KC5fUMrCto4x0Ulr5s3+eVm696UkSdr3S
de0Dxvs97v7H0kbZ4FAUCFAW42wbvO8Cg8xIq6y6fAxe+hHb+UMBvxR28iWudXPT
gXMM0XdVlNfeWCZmzjvaUrLHGnismWw3hqcAiOwCR1Mhj4ctFIP3KQY833dT79og
5tXAg1HPR/mQe/KqPpfo
=Og++
-----END PGP SIGNATURE-----

--2JFBq9zoW8cOFH7v--
