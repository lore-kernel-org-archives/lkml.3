Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbaE3Hcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:32:47 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:51235 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbaE3Hcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:32:43 -0400
Date: Fri, 30 May 2014 09:30:08 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, devicetree@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140530073006.GA24748@ulmo>
References: <1400877395-4235-1-git-send-email-thierry.reding@gmail.com>
 <538757B6.4010109@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <538757B6.4010109@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2014 at 09:52:22AM -0600, Stephen Warren wrote:
> On 05/23/2014 02:36 PM, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > This commit introduces a generic device tree binding for IOMMU devices.
> > Only a very minimal subset is described here, but it is enough to cover
> > the requirements of both the Exynos System MMU and Tegra SMMU as
> > discussed here:
> >=20
> >     https://lkml.org/lkml/2014/4/27/346
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> > Apologies for the noise, but apparently I mistyped one of the email
> > addresses, should be fixed now.
> >=20
> > Changes in v2:
> > - add notes about "dma-ranges" property (drop note from commit message)
> > - document priorities of "iommus" property vs. "dma-ranges" property
> > - drop #iommu-cells in favour of #address-cells and #size-cells
>=20
> I think this is a mistake. address-cells/size-cells are for transactions
> flowing down the bus (from the CPU to date). Describing a connection
> from a device to an IOMMU is something completely different, and should
> therefore simply use an iommu-cells property to describe any necessary
> information. If we start re-using properties for different things in
> different contexts, how is anyone going to know what they mean, and how
> will conflicts be resolved. For example, what if there's a single HW
> module that both acts as a regular register bus with children (where
> address-cells/size-cells defines how transactions reach the children
> from the parent), and is also an IOMMU (where according to this binding
> proposal, address-cells/size-cells represent some aspect of the IOMMU
> feature). Using different properties for different things is the only
> sane way to keep different concepts separate. Another alternative would
> be to represent the single HW module as separate nodes in DT, but I
> think that will only make our lives harder, and where I've done that in
> the past, I've regretted it.

There was some back-and-forth on this topic and the latest concensus
when I wrote the second version was that #address-cells and #size-cells
were to be used.

But there was some bore back-and-forth after that, and it seems like
Arnd no longer thinks that using #address-cells and #size-cells is a
good idea either[0].

Arnd, can you take another look at this binding and see if there's
anything else missing? If not I'll go through the document again and
update all #address-cells/#size-cells references with #iommu-cells as
appropriate and submit v3.

Thanks,
Thierry

[0]: https://lkml.org/lkml/2014/5/20/609

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTiDN+AAoJEN0jrNd/PrOhrpwP/28UxOr3xF30hFVjZUvRegoA
QxLOiXKgYfLiDpVTqR6XiJHbnhFv/I7gfwOC5jphjDH3MkH4HN3sMn1pFjzqlcu1
rbiUksPkuqGhuHSuHD2+9IY7RdgKrsYE+5afTSAR5q3PLXPIDdIoyRukuJa17oI0
bcQUWsK+uQ4T9NkelSQPFQZhHLPA0csPGzA5L4l/3Dz3ZVrWyIgrs0ZGmm9yI5Q3
uBP4gtRsOpLB7OEmR70nXVn90W/Ndz2U2mb7T2N57R+oLADcGoMGe7W8n5szy/bu
fWoJ/4Quw7ZMqXN9cGRbnb4aDxfefhDIVIR7gLOciosVQltDOwRMxnnGkJgQ4okN
BZrxJ2zKIjNm9eus5LIKvjydNAkPjUnw9k455b8NNEQT6pLdldUa2XCiRs4VFSuy
iNk9HeBTVykQtyyZCGC4g4wA9HsLYgNFSqX1MjI0yDZk4FCsbaUXwTiaKJRBwVtf
85khJ4TTHVdeTaBvpDGCDmyx8L7s3ZPWrSIxKY9K/1dwCFe49Fb5dmJzokiyd72i
O/eXjDSKcE5bGgYCRdWliL8qvS5BnpayrR2hY70lyr6ROSX3L6inofh4E62urUIH
PJUSnlM2YVTn1mwg+WGq41gin6wiEy7xArEOkrcD0k7nxlsl+Y2S1toWf8gHn9QV
akEZa3AIOH+rQ/U7/MjP
=Ifqv
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
