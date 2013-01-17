Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab3AQUal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 15:30:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56199 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab3AQUai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 15:30:38 -0500
Date: Thu, 17 Jan 2013 21:30:10 +0100
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
Message-ID: <20130117203010.GA24584@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130115154038.GA11241@arm.com>
 <20130115211441.GA13139@avionic-0098.adnet.avionic-design.de>
 <201301161400.26587.arnd@arndb.de>
 <20130116161716.GA10630@arm.com>
 <20130116183101.GA28660@avionic-0098.adnet.avionic-design.de>
 <20130117154236.GA25943@arm.com>
 <20130117160501.GC2186@avionic-0098.adnet.avionic-design.de>
 <20130117162218.GA29016@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20130117162218.GA29016@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:UrkGv7Csaerd0rG4JQNiOgVW3mrYXN9jf4V82chEzOA
 LEJu+U9KPUEBTzB7gZTkXIxK4K0XATTyFXwdwv+VDilIx6dWcY
 XtsWDIyDeBQ1VxtThzeaiwT/BrfWaxpLW4ogkVAwMQN6bsvir5
 oP/C6n7ATeLrHhCP0PfrdVP92u1W3yL83nBGgdgcou7wMbBHZ0
 QFAPUVtm9+uUzx1ITy8fYFAOAfr+Sd6bfDuITbXMSk/30+YCJl
 +klilns9Eb3qNoQEBU2Hi+IsYMB4U7mgj8RcY/HXsKG7dbT2Gg
 IDZIwNFScPVyy7sHzozPKyskNQgnKvj2V+yn8ZvNIMZjoxKuJF
 vXBy+a1iBXTH8oE/470XUrTV9WajOQLApQLzc1lzfVvNR0xsKw
 vmyLo5znhVynxJOJ+TQLXyJP2AZLCI+l0U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2013 at 04:22:18PM +0000, Andrew Murray wrote:
> On Thu, Jan 17, 2013 at 04:05:02PM +0000, Thierry Reding wrote:
> > On Thu, Jan 17, 2013 at 03:42:36PM +0000, Andrew Murray wrote:
> > > On Wed, Jan 16, 2013 at 06:31:01PM +0000, Thierry Reding wrote:
> > > > Alright, putting the functions into pci_ops doesn't sound like a ve=
ry
> > > > good idea then. Or perhaps it would make sense for hardware where t=
he
> > > > root complex and the MSI controller are handled by the same driver.
> > > > Basically it could be done as a shortcut and if those are not filled
> > > > in, the drivers could still opt to look up an MSI controller from a
> > > > phandle specified in DT.
> > > >=20
> > > > Even another alternative would be to keep the functions within the
> > > > struct pci_ops and use generic ones if an external MSI controller is
> > > > used. Just tossing around ideas.
> > >=20
> > > I think an ideal solution would be for additional logic in drivers/ms=
i.c
> > > (e.g. in functions like msi_capability_init) to determine (based on t=
he
> > > passed in pci_dev) which MSI controller ops to use. I'm not sure the =
best
> > > way to implement an association between an MSI controller and PCI bus=
ses
> > > (I believe arch/sparc does something like this - perhaps there will be
> > > inspiration there).
> > >=20
> > > As you've pointed out, most RCs will have their own MSI controllers -=
 so
> > > it should be easy to register and associate both together.
> > >=20
> > > I've submitted my previous work on MSI controller registration, but it
> > > doesn't quite solve this problem - perhaps it can be a starting point?
> >=20
> > We basically have two cases:
> >=20
> >   - The PCI host bridge contains registers for MSI support. In that case
> >     it makes little sense to uncouple the MSI implementation from the
> >     host bridge driver.
> >=20
> >   - An MSI controller exists outside of the PCI host bridge. The PCI
> >     host bridge would in that case have to lookup an MSI controller (via
> >     DT phandle or some other method).
> >=20
> > In either of those cases, does it make sense to use the MSI support
> > outside the scope of the PCI infrastructure? That is, would devices
> > other than PCI devices be able to generate an MSI?
>=20
> I've come around to your way of thinking. Your approach sounds good for
> registration of MSI ops - let the RC host driver do it (it probably has i=
ts
> own), or use a helper for following a phandle to get ops that are not part
> of the driver. MSIs won't be used outside of PCI devices.
>=20
> Though existing drivers will use MSI framework functions to request MSIs,=
 that
> will result in callbacks to the arch_setup_msi_irqs type functions. These
> functions would need to be updated to find these new ops if they exist, i=
=2Ee. by
> traversing the pci_dev structure up to the RC and finding a suitable stru=
cture.
>=20
> Perhaps the msi ops could live alongside pci_ops in the pci_bus structure=
=2E This
> way when traversing up the buses from the provided pci_dev - the first bu=
s with
> msi ops populated would be used?
>=20
> If no ops are found, the standard arch callbacks can be called - thus pre=
serving
> exiting functionality.

Yes, what you describe is exactly what I had in mind. I've been thinking
about a possible implementation and there may be some details that could
prove difficult to resolve. For instance, we likely need to pass context
around for the MSI ops, or else make sure that they can find the context
=66rom the struct pci_dev or by traversing upwards from it.

I think for the case where the MSI hardware is controlled by the same
driver as the PCI host bridge, doing this is easy because the context
could be part of the PCI host bridge context, which in case of Tegra is
stored in struct pci_bus' sysdata field (which is actually an ARM struct
pci_sys_data and in turn stores a pointer to the struct tegra_pcie in
the .private_data field). Other drivers often just use a global variable
assuming that there will only ever be a single instance of the PCI host
bridge.

If the MSI controller is external to the PCI host bridge, things get a
little more complicated. The easiest way would probably be to store the
context along with the PCI host bridge context and use simple wrappers
around the actual implementations to retrieve the PHB context and pass
the attached MSI context.

Maybe this could even be made more generic by adding a struct msi_ops *
along with a struct msi_chip * in struct pci_bus. Perhaps I should try
and code something up to make things more concrete.

Thierry

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ+F9SAAoJEN0jrNd/PrOhyQkP+wTfHO/r3EvHjV6NFm2t2p9d
v4FQJYigdq8AjiylEO+Aj6wqaNsQKT3+vpJMMw84rB4Z3XvhJuL6HAQ5AfvegbGC
wxMxIfxDjmLWe6fNou+3ypDG7QLJdNbKWuIlBMyQ/+3Q+v5js2pedb4wGk004hsV
P+iK1QoK64E9Ef18Kv9vODyjR6g0aYz0i3HyW2mSHe4DSR+dB2Gvs7f4dSSUo03l
PfgPA88BisX57/qJmxKO0OvvzmwV1TUkxp90b9moBxry5VPUFygS0zMjefw04Y1C
nr37tYbJfehnJf22y0mvg/ygBvR8gYUAEoNSXwEjt7irFJ2y/Ciag94iXvSh5N+a
RIj6wgSaXGyB7bNGOSq2YWlNYMqAt0Ak327CMRAJfwEOAIP544nk5Qex2JIjrdD3
Nv2bB4sYaOASm2jYDT/5RnYvSAwYIUDIP4g4a0gTq73JX4SHDEYOTNI8TK3ohzUY
W00f81qLeiD0eDba2+Q8ZYxGRQ2vweOSy4LqF7Q7IoqHTmaF9Wo23nnpz1rEUIiB
+uMWntqK1gdC81GmsuZoLDv81nJSiFKJm4VVe+d9qj/SGPxgUe93AWKygviPoWRz
chOMuvtwj1QN2Hf+6gOBdxmKfL8SuC2DbvIZe9o5ZU03Q9De5gl1r84ZdeApLz4x
XhygdIv5bEZMPb50qbDt
=E+hm
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
