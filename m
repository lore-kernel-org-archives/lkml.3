Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab3FLVXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 17:23:16 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:33456 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab3FLVXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 17:23:14 -0400
Date: Wed, 12 Jun 2013 23:23:10 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 07/12] PCI: tegra: Move PCIe driver to drivers/pci/host
Message-ID: <20130612212308.GA27681@manwe>
References: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
 <1365000318-28256-8-git-send-email-thierry.reding@avionic-design.de>
 <516C46BC.2040707@wwwdotorg.org>
 <20130612122959.GA32444@manwe>
 <51B89D26.9070605@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <51B89D26.9070605@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 12, 2013 at 10:09:10AM -0600, Stephen Warren wrote:
> On 06/12/2013 06:30 AM, Thierry Reding wrote:
> > On Mon, Apr 15, 2013 at 12:28:12PM -0600, Stephen Warren wrote:
> >> On 04/03/2013 08:45 AM, Thierry Reding wrote:
> >>> Move the PCIe driver from arch/arm/mach-tegra into the
> >>> drivers/pci/host directory. The motivation is to collect
> >>> various host controller drivers in the same location in order
> >>> to facilitate refactoring.
> >>>=20
> >>> The Tegra PCIe driver has been largely rewritten, both in order
> >>> to turn it into a proper platform driver and to add MSI (based
> >>> on code by Krishna Kishore <kthota@nvidia.com>) as well as
> >>> device tree support.
> ...
> >>> +static irqreturn_t tegra_pcie_msi_irq(int irq, void *data)
> >> ...
> >>> +	return IRQ_HANDLED;
> >>=20
> >> Shouldn't this function return IRQ_NONE if no MSI status bits
> >> were found set?
> >=20
> > The IRQ isn't marked IRQF_SHARED, so I don't think this is needed.
>=20
> Isn't it still useful to detect unexpected/stuck interrupts?

Yes, you're right. I can't think of a nicer way to do it, though, so
I'll go with a processed IRQ counter or a flag.

> >>> +static int tegra_pcie_probe(struct platform_device *pdev)
> >> ...
> >>> +	pcibios_min_mem =3D 0;
> >>=20
> >> What does that mean/do? I wonder if that should be set to
> >> 0x80000000 by the Tegra30 patches?
> >=20
> > ARM defines PCIBIOS_MIN_MEM to that variable. That macro in turn is
> > only used by pci_bus_alloc_resource() AFAICT, which uses it to
> > override the start of a resource when allocating if res->start =3D=3D
> > 0. As such it designates a lower-bound of valid PCI memory
> > addresses, so 0 on Tegra20 and 0x80000000 on Tegra30 don't seem
> > like good values. Maybe we need to set them to the lowest of the
> > prefetchable and non-prefetchable memory areas as defined in the
> > DT?
> >=20
> > It doesn't currently seem to matter at all, though, since we never
> > pass in a range that's 0, so the start address of resources can
> > never be 0 and therefore PCIBIOS_MIN_MEM is never used.
>=20
> Hmmm. I guess ignore it then. If the value won't ever be used, 0 is as
> good a value as any?

Alright, I'll do that then.

Thierry

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRuOa8AAoJEN0jrNd/PrOh+bkP/jn3lGBiGbjNi027XeevREsp
DkwcxH4QnBbAUP+pGCm319oquZuLiptR865uEx60r02QC2N+HpWBVtd/zcjfGs+x
drQZ4SrEO53ZqSuWHxu1hZvWE2U1cmr6FfchKOD6KXhaURr8g4rlMQClu7fuGsgL
22TD9m40R/0LasWk54/oYuFH+H1A/06dTiHYABgQGCK2YpXK/iyo4gAWqPgmuufU
4VdTZLnmi50lGQqjOrMG4rdwI0FbKqut0c2eejXm5PgPEkUfG/OkryvIjmfR7IKw
EKBolfOC1g6Uk0kRKSF4bOGhrHKN7sPyZRVzaMisAXpddlhb/ehsprrfM+J9BDfk
sluOcOJsrCXinuSudHsTHlKbc5hP+cjkgOKqI1mmkGIKl34BBSvycThoi+kVj8rw
LK3MyWK3xo3nG9Jinmdc3UaWLnZ+gCSbOOh1mSNtx9kx+u3ALAENJS0XwN71njoK
BZB6JuM/jBn4nQ7+avMMB1D3BFx4KPy4vQvs0Usd1v+eqNjMkSOvXzCCMso8Idv3
mheOhkI1PFhhZvHSfZ2SkG+pClA84vBqd+CJ5nXMfz4z5EYslV6//BgoWCKyXklN
4cOI+1Ef05egOfYAAcNy4MvOmtedtuQih1I7NnqttTwYcxSePh4P/gXBrlEtBLcj
mpF1VcqVjw32JldQNaCt
=lrtv
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
