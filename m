Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab3APSbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 13:31:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56528 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab3APSbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 13:31:15 -0500
Date: Wed, 16 Jan 2013 19:31:01 +0100
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
Message-ID: <20130116183101.GA28660@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130115154038.GA11241@arm.com>
 <20130115211441.GA13139@avionic-0098.adnet.avionic-design.de>
 <201301161400.26587.arnd@arndb.de>
 <20130116161716.GA10630@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20130116161716.GA10630@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:9bs6BpSVmDNvfZi4sbA7xhTzxiK63FgQLpcABG4ppQP
 KqwnLD9DGn23kPkjHVXdReoibl2542U2zJ/AjwHMHnreChEKe6
 T3CNqeOZgp2HSwITx+E2hR8eryS9AML2opr99EHAVZ/0/Wjnmp
 E5ZI03q2/ipbirwxlBXHGLBY+ZFOxrnrsTEx0tFOd1auZg3Dg0
 WQsPTTm2fneEdCfpEFOZiX8qOw6BAaDEWEiiEVi6Xtym43e71C
 8+Yy/BDAkuLqrNmGGvI5B4DV5WfgnoK2sL80NyijtPi74Y6AgR
 VKtW8c29ywLL16bhgzEmkFtmNpaUZ++MGGGWDstMbA86EL2OXr
 oOFrAb8tht0P2bA2jhPhoTXsWoowv16M83TJzNhx52LWz5frCw
 wMwBPHI0Fd1NC3Oh5VucOHuBvh9ePJOT6Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 16, 2013 at 04:17:16PM +0000, Andrew Murray wrote:
> On Wed, Jan 16, 2013 at 02:00:26PM +0000, Arnd Bergmann wrote:
> > On Tuesday 15 January 2013, Thierry Reding wrote:
> > > Is there actually hardware that supports this? I assumed that the MSI
> > > controller would have to be tightly coupled to the PCI host bridge in
> > > order to raise an interrupt when an MSI is received via PCI.
> >=20
> > No, as long as it's guaranteed that the MSI notification won't arrive
> > at the CPU before any inbound DMA data before it, the MSI controller
> > can be anywhere. Typically, the MSI controller is actually closer to
> > the CPU core than to the PCI bridge. On X86, I believe the MSI address
> > is on normally on the the "local APIC" on each CPU.
>=20
> MSIs are indistinguishable from other memory-write transactions originati=
ng
> from the RC other than the address they target. Anything that can capture
> that write in the address space (even a page fault) could be an MSI contr=
oller
> and call interrupt handlers. And so the RC / MSI controllers don't need to
> be aware of each other.

Alright, putting the functions into pci_ops doesn't sound like a very
good idea then. Or perhaps it would make sense for hardware where the
root complex and the MSI controller are handled by the same driver.
Basically it could be done as a shortcut and if those are not filled
in, the drivers could still opt to look up an MSI controller from a
phandle specified in DT.

Even another alternative would be to keep the functions within the
struct pci_ops and use generic ones if an external MSI controller is
used. Just tossing around ideas.

Thierry

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ9vHlAAoJEN0jrNd/PrOhZNgP/j1W2PffGWmvDtMdurQ29Vp1
ddGd2AxrNmpr69zaRcX6+Sr0RD98UR/kLcMpGFn8JMF3OcNaqjiIHgSer1I2QYlu
UNdWU71yzqlcp2cHW1pqpjElDaiE/IT9PnAdfFgAdFcTAwACZvBmAZrxoooSEi9b
mfkp5bwVU/Mjdg5N293V2bPI872mdWON143CmHG6UYQRvU2yJoRul15WKRvzvupR
NWUQcVM4R/QHNAhwJh7dDbcX2HWzZCjXArRUk7tdHY0rE7ZNRLezM3Np0YqFM+2d
f/mW9FVLQj/++6JK0+gjSzbgHF15fa1NjySr+OWh9vIWNPF4z43KvFv4wEWkNdNi
n/tFq151CLfMjrzWJ8x4c3+/Up2jKRbsq4IA4vLoltza1A+tnlbtTiC/wJ2yIaqA
4vICiIDb6P4uEF7XWIEAFB0VWO6YmSTb++ZSK7BNj37EIDGTyAdOMbgJGLmCCG+I
MtIOGKu5XB6o6Va2YA8470VPzGp8Yhzudh5PoPaomGVDTIH/Cnky+JXECvt9v7zS
MulwDh98I1V+w9L0KzspsGaoe6rh3z26xBvFRBwLdvylG8/HhWtWibst4m23reIu
NfJskqkTnlPOIAeH4o0bmoTm4kjJDNmzuf39Wj0maufY7r3AQ2v42z/v7AyLwPDi
6XmBE127Ae6ZkvjkfQ06
=bdya
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
