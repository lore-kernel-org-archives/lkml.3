Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaF0LIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:08:19 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37528 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaF0LIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:08:17 -0400
Date: Fri, 27 Jun 2014 13:08:12 +0200
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
Subject: Re: [RFC 04/10] memory: Add Tegra124 memory controller support
Message-ID: <20140627110811.GD2797@ulmo>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
 <1403815790-8548-5-git-send-email-thierry.reding@gmail.com>
 <20140627124638.7ec150cca163c89727b8953f@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
Content-Disposition: inline
In-Reply-To: <20140627124638.7ec150cca163c89727b8953f@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 27, 2014 at 12:46:38PM +0300, Hiroshi DOyu wrote:
>=20
> Thierry Reding <thierry.reding@gmail.com> writes:
>=20
> > From: Thierry Reding <treding@nvidia.com>
> >
> > The memory controller on NVIDIA Tegra124 exposes various knobs that can
> > be used to tune the behaviour of the clients attached to it.
> >
> > Currently this driver sets up the latency allowance registers to the HW
> > defaults. Eventually an API should be exported by this driver (via a
> > custom API or a generic subsystem) to allow clients to register latency
> > requirements.
> >
> > This driver also registers an IOMMU (SMMU) that's implemented by the
> > memory controller.
> >
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> >  drivers/memory/Kconfig                   |    9 +
> >  drivers/memory/Makefile                  |    1 +
> >  drivers/memory/tegra124-mc.c             | 1945 ++++++++++++++++++++++=
++++++++
> >  include/dt-bindings/memory/tegra124-mc.h |   30 +
> >  4 files changed, 1985 insertions(+)
> >  create mode 100644 drivers/memory/tegra124-mc.c
> >  create mode 100644 include/dt-bindings/memory/tegra124-mc.h
>=20
> I prefer reusing the existing SMMU and having MC and SMMU separated
> since most of SMMU code are not different from functionality POV, and
> new MC features are quite independent of SMMU.
>=20
> If it's really convenient to combine MC and SMMU into one driver, we
> could move "drivers/iomm/tegra-smmu.c" here first, and add MC features
> on the top of it.

I'm not sure if we can do that, since the tegra-smmu driver is
technically used by Tegra30 and Tegra114. We've never really made use of
it, but there are device trees in mainline releases that contain the
separate SMMU node.

Perhaps one of the DT folks can comment on whether it would be possible
to break compatibility with existing DTs in this case, given that the
SMMU on Tegra30 and Tegra114 have never been used.

Either way, I do see advantages in incremental patches, but at the same
time the old driver and architecture was never enabled (therefore not
tested either) upstream and as shown by the Tegra DRM example can't cope
with more complex cases. So I'm not completely convinced that an
incremental approach would be the best here.

Thierry

--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrVCbAAoJEN0jrNd/PrOhvbwP/jRt3vshZDONx45I9YYV8PGt
zzvV3YoYcDqCeHLXPVZNC/HRv4oLQ3yNJK91vUt9Zgc8kGEose9FZaYYvC76OtMZ
XcCvXhSGo3N8wy+4SvIovdVC2FXEzZfRPiizoL5vuyBlwHhb2emaBJwjEJaWk7GI
j4EtmVMnXv/11VSYiwAkyV9bkRYyaQZ6i7PNB0gmj9TH2RmFAIbNsRbHhPo/dovN
oKf8+tXQZmoGAey64URLlTfXZFU1P5Fz9ejNbF6ZD3mf8GyRghRjk3ypxl/2oUH9
RqVFhWnEeqH3723V3uMOgFrIRz2QgTUS8GFrHPmH2LWdYAFBmW3h3RfOzvJXlnvQ
yZkcOV7+8kNOXuxWLZG3+tj6QHD+jbhAk8qS9/HSKYPm5Lp6YsUCmf/f3dsyUgRZ
JCittXDjBZgkJA8aq4l/om7Ts6IOPWVK+2TwRv3w3wgxjzno6krN5i42kGCy4s41
nRIWUfXxOwe3VVE2WUA5ukKRc/ON8JPUZZ1SLQfnPmnMgqo1+jGkR7LViDv1yit7
U/Y3Dgl/ihIWOJBYmVUhg3G6M1e7DZJdshIHbcj4adIxOPUK/wqbtc8h6l4uCqh1
tzgCra21tMiqWzW9n6To7EK/Sqe2+W9gcQnTo4bsidUXM4F31UAMGpKr6T6jKNiW
j0FMUh6TTRPRhp/b8RgY
=m2wZ
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--
