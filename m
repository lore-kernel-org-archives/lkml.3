Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab3AMJ6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 04:58:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53465 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab3AMJ6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 04:58:12 -0500
Date: Sun, 13 Jan 2013 10:58:06 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
Message-ID: <20130113095806.GA31966@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130111154516.GA25335@avionic-0098.adnet.avionic-design.de>
 <20130112123640.GA22505@avionic-0098.adnet.avionic-design.de>
 <201301122112.25772.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <201301122112.25772.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:I5RCmD4cD0/e66QRCh2IECmlZEysy38pJwDz3dRVY1N
 9ZZYVEI/26a2jFoRABYM9B4Cdup7ESQimC/Nkl869bzqwHQKKn
 ZXdkzj4Q0quqlZ+zhI4MuMFG6yN66iB+RB8blv8keWjcIoEyNO
 If2haMe4ZMRa4+WQ5D08XEhUre5fBctxa3UH+KRuIijdAxao8R
 Ro34kcK2LnP98RvX/24oPJTTTfd7jH521vHP1pzQJRYH/RA0LL
 cJR2twFRtOJEIDKM3f1ILuNts7hPqfdzNsyTbsQN9Tn4pA1meM
 HQJfQXjx4wP2BCTrGSAMqMmmZNMhnGVaFC0F7jBQ4s+rrBmISe
 DPmlhlqX83PA4AP445Jm46FXgVHkCIspaIzerE8x8INndwCnfH
 7sLsct5BRIGW4t6n+Udr2CehKsiPAUx2PE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 12, 2013 at 09:12:25PM +0000, Arnd Bergmann wrote:
> On Saturday 12 January 2013, Thierry Reding wrote:
> > > I already hinted at that in one of the other subthreads. Having such a
> > > multiplex would also allow the driver to be built as a module. I had
> > > already thought about this when I was working on an earlier version of
> > > these patches. Basically these would be two ops attached to the host
> > > bridge, and the generic arch_setup_msi_irq() could then look that up
> > > given the struct pci_dev that is passed to it and call this new per-
> > > host bridge .setup_msi_irq().
> >=20
> > struct pci_ops looks like a good place to put these. They'll be
> > available from each struct pci_bus, so should be easy to call from
> > arch_setup_msi_irq().
> >=20
> > Any objections?
> >=20
>=20
> struct pci_ops has a long history of being specifically about
> config space read/write operations, so on the one hand it does
> not feel like the right place to put interrupt specific operations,
> but on the other hand, the name sounds appropriate and I cannot
> think of any other place to put this, so it's fine with me.
>=20
> The only alternative I can think of is to introduce a new
> structure next to it in struct pci_bus, but that feels a bit
> pointless. Maybe Bjorn has a preference one way or the other.

The name pci_ops is certainly generic enough. Also the comment above the
structure declaration says "Low-level architecture-dependent routines",
which applies to the MSI functions as well.

Thierry

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ8oUuAAoJEN0jrNd/PrOh4rEQALfqOrL0OPHE/+YrdqpIq6A/
ZXfhGd3dlplQUI44GPrIx+U4fPLbmE5pa3e1/ZhUMqXuSJ5a5Ps9d7wrR7Plnkpf
6ecscHJ+jcJWrDH+CGPfofYsn745WPlYHU3oBFvaHr4ZPraDqLCKOuYldj0ZQgOj
JzQf/zICnZ/dl0QW9ygvbUI6UIWiByPsDDlK4rMwFHuaB8XHGOy4oYk5XboMlxHJ
Wr6+nasApwgKOq0QoDCAPTpT6Rc6N95nHX9/eOvm4H4eBb8UT/1WoZo//nKlXmc2
XAxPmghJ2bTlCd7oJKfIvrS2Ae7QYfYpOQX+3DQXovC/jJfedBC7StASo/ZfO26G
ciFjmHksOxcdN922CUrWdGg6hOvaprEUGKNt6KBwTWGHpyqxSgjAqQutUw24IZ9O
blmaiI3hl1fg5bRThsyVwOMu1cT6uNGh63h2CZJbX0pPS1ohnAU75CHNnIKXbv8Y
CjK1w/LruU6x55c6bonwHvnMGopMilcnYi1JHIkuik2+8pRzJlCi2D/D4zvIv2ew
tskNSePxjeRSjeV/160EH2GCsBFUAs6eaaC7e/r6FicYRXUjGtyGY/7Py3Cx3Tno
nPU4UyKjqmV0Uf8gF6SURmZUwgCvZafFgcmF67rNqGK+lqaZqes7cE5OaeGW87kV
aow/6ojMlxL4WloM/g+i
=Pkxr
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
