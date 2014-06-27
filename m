Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaF0LBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:01:16 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:46117 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaF0LBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:01:14 -0400
Date: Fri, 27 Jun 2014 13:01:10 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Hiroshi DOyu <hdoyu@nvidia.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <AMartin@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 10/10] mmc: sdhci-tegra: Add IOMMU support
Message-ID: <20140627110109.GC2797@ulmo>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
 <1403815790-8548-11-git-send-email-thierry.reding@gmail.com>
 <20140627124602.53d046dae5d7e269815e56a0@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Content-Disposition: inline
In-Reply-To: <20140627124602.53d046dae5d7e269815e56a0@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 27, 2014 at 12:46:02PM +0300, Hiroshi DOyu wrote:
>=20
> Thierry Reding <thierry.reding@gmail.com> writes:
>=20
> > From: Thierry Reding <treding@nvidia.com>
> >
> > Attach to the device's master interface of the IOMMU at .probe() time.
> > IOMMU support becomes available via the DMA mapping API interoperation
> > code, but this explicit attachment is necessary to ensure proper probe
> > order.
> >
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> >  drivers/mmc/host/sdhci-tegra.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-te=
gra.c
> > index 33100d10d176..b884614fa4e6 100644
> > --- a/drivers/mmc/host/sdhci-tegra.c
> > +++ b/drivers/mmc/host/sdhci-tegra.c
> > @@ -15,6 +15,7 @@
> >  #include <linux/err.h>
> >  #include <linux/module.h>
> >  #include <linux/init.h>
> > +#include <linux/iommu.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/clk.h>
> >  #include <linux/io.h>
> > @@ -237,6 +238,11 @@ static int sdhci_tegra_probe(struct platform_devic=
e *pdev)
> >  	match =3D of_match_device(sdhci_tegra_dt_match, &pdev->dev);
> >  	if (!match)
> >  		return -EINVAL;
> > +
> > +	rc =3D iommu_attach(&pdev->dev);
> > +	if (rc < 0)
> > +		return rc;
> > +
>=20
> I thought that, if we consider that ->probe() should include minimal H/W
> probing so that DMA API call in ->probe() could be deferred after
> ->probe() and till it's in use actually, like opening a device node. For
> me this decision(minimal h/w probe) seemed logical but it would add a
> new restriction. One advantage is that we could still keep all drivers
> wihtout any IOMMU code if it doesn't call DMA API in ->probe().

This isn't immediately apparent in this case, but I think that in the
future we may need to have this kind of explicit attachment to an IOMMU
for example once devices start to appear that have multiple master
interfaces (possibly on different IOMMUs). For easy cases like this
SDMMC driver we may be able to get away more easily by hooking this up
within the driver core for example. I'd have to look into how exactly
this would work, though.

Thierry

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrU71AAoJEN0jrNd/PrOhQ4IP/Aye8pmLcGCp1W3h6GU+WArt
LVfDFsTczvAEsS6fFDTWz4h/KkcDZTfFzbTFjBDpaOSVfasPG9oW5XSgFgj8hO6Y
KwLJonjt+8Qb1ec/yKFqtk/cjsbEEqZDAuw2TlkE9EQoykvbdpto0n3Nbpex3ED9
Cvbrx04xVk7tn4fOSfz/X5j+/6xjoW9fA5KWdsw1pyN+kVtBBvXe9TF4JBN8LTQ5
YT5bur6957IFSrDYXkLP7Z0IeMWcX3M0LusIGyVVmRud0dFRuN/hvUAAe3uYGxOy
QdFgMwIP/m5LNe9nwXPFmVlE+HFrd7PXz+YxpPtdwxenU4GLOHFtg2dy2z1hxR2W
i2Es8ofpBMrFo8h9FNmlnnDG0sNMaHSDPLl3VJdWO8AJrE8BHZ2/cjtjXxnT7cvU
6CR8y7QtKgau8/XDHqLz+Ch5v0agdUV4ILzA6u7+3NXYMcJvuCdBoEsNodXimHTV
jUXhlERtBhOUKei3Ssiv9/mt8lRZJlLhJ1ydFUZm1d7N0jJz2FFhESKFIMyV82VP
OJXys9n+XLeiASTQSwp3Ol2lU1047+7w6+dWdlLXgBUVKbSrCYnwgpu/aHKA0ZZ8
giq3LHXL6BoRMxaat26YPEptfaD5stGmIsmaJROjcLZekkY+S4dDZdblsIjLPyxw
a/v4ijIjnzTE/x3sBjR3
=G25q
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--
