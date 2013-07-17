Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab3GQFH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 01:07:59 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:41494 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3GQFH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 01:07:57 -0400
Date: Wed, 17 Jul 2013 07:07:49 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jingoo Han <jg1.han@samsung.com>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        linux-pci@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V5 1/3] pci: Add PCIe driver for Samsung Exynos
Message-ID: <20130717050748.GD11359@mithrandir>
References: <000b01ce6839$0f0455d0$2d0d0170$@samsung.com>
 <000001ce68d7$ca762200$5f626600$@samsung.com>
 <20130614105310.GA19060@manwe>
 <3309315.fJN6KWK0oA@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LKTjZJSUETSlgu2t"
Content-Disposition: inline
In-Reply-To: <3309315.fJN6KWK0oA@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LKTjZJSUETSlgu2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 14, 2013 at 02:38:49PM +0200, Arnd Bergmann wrote:
> On Friday 14 June 2013 12:53:11 Thierry Reding wrote:
> >=20
> > I think the biggest missing piece is pci_common_exit(), the counterpart
> > of pci_common_init(), to cleanup a host bridge on ARM. I haven't looked
> > in detail at the other architectures, but I suspect there must be some
> > code to call when a host bridge is removed.
> >=20
> > Looking at drivers/pci/remove.c, it seems like pci_remove_root_bus()
> > might be what we're looking at. It isn't exported so it can't be used by
> > modules, but that can be changed. Is that how a host bridge is typically
> > removed from the system?
>=20
> It's fairly new to have host bridges in loadable modules, so I'm pretty
> sure it's not supported by the core yet, but it also doesn't seem hard
> to do. I think you are right with regard to pci_remove_root_bus,
> and Bjorn might be able to provide more information.
>=20
> Ideally we should be able to load and unload the pci host driver
> in a loop indefinitely without crashing or exposing any races
> or leaks, but I would not bet on that working without bugs in the
> core, since that goes beyond the normal pci (device) hotplug case.

I've done some preliminary testing on Tegra using sysfs to unbind and
rebind the device from and to the driver. Some code needs to be added
for this to work, but it doesn't crash and PCI even continues to work
after unbinding and rebinding (tested using gigabit ethernet).

However I haven't looked for leaks yet, and I'm pretty sure some more
code is required to undo some of what pci_common_init() does on ARM.
Looking more closely, I think most (if not all) remaining leaks could
be fixed by keeping the list of pci_sys_data structures around and
cleaning them up properly.

Given the experimental nature of this I don't want to make that part of
the driver for 3.12 and I've opted to just disable any means of removing
the driver for now. But I do want to get back to this after the driver
has been merged.

Thierry

--LKTjZJSUETSlgu2t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5iakAAoJEN0jrNd/PrOhDWUQAKhSWJclEidsxp4PORW1YVAU
zobh2Xrtt4Wqv21HeeEg/J8YBklf52eMQd6xzZM0S6QbBC+l7oWXKe5DSHoqEDBP
8MkYoblEku9/otQ2KLesQabgVTysq5gA6jXwOba6Gxs9Gsx2HFETu0r1M0CDhpkZ
8ro5MG06LhLEsNmSu7mE+723VX8PeTLINxpI8O0KRjR2Gb6grayeiQzV2s5TUgYh
izbtnyxJV9rSW27GoUHDjMZew4k/uFjvSPO6yN7PTiuMXVFYV/3wL+k6X7rpMkS2
PxoQy9a4RbS5u8UV2CQyfx+y/cNLvplLalFeVRCAQdZJ8ft8ncU4dinT15asP0NP
uuRL+JOwzTvSURqTaPNFpDjVvxsPehJaxlun9ImZukBCmYRstJGJTZGxrjn3LDNc
WUgoYPF4OcY2fO1Va7H8Z5QDZMaWKm9hjYjWCRYDjbT6u7WdD+eMz09mRMnKBUAy
pKlLpNCClSJGByKL0qMXeSwmK5MaJtXrMbqbSs6oqcwzL2ML2GY+qs1mFM+23ZRq
OKPzy0pTd48HtoA+8eP2t9d7jlPgZUJUXcqcpgaganfyEEIExlj4kF+kDUEFv3dw
VBUpraqvZW6qxUIR1Pb/sIGCIVRzeCTz+/gCWfk7E6FwG1oCqANJHe6jhB91QtGy
YULcNLf3zoC1RucOahmR
=AEQR
-----END PGP SIGNATURE-----

--LKTjZJSUETSlgu2t--
