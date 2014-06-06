Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaFFWpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 18:45:53 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44187 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaFFWpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 18:45:50 -0400
Date: Sat, 7 Jun 2014 00:45:45 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, devicetree@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140606224542.GA22188@mithrandir>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This is somewhat off-topic, but given the various concepts discussed in
this thread I'm beginning to wonder how they will be implemented. The
current implementation hooks the IOMMU API into the DMA mapping API, and
the way this is done is by setting a single IOMMU (or rather a set of
IOMMU operations) globally per bus type.

There are two issues that I can see with that: one is that we can't
support multiple IOMMUs in the system at all, and the other is that
there is no context associated with the IOMMU ops, and therefore there
is no way to differentiate between two instances of the same IOMMU. A
few drivers use global variables to keep track of context information
but that won't work with multiple instances, unless they keep a global
list of all instances and then require explicit lookup in each of the
IOMMU operations. That sounds more like a workaround rather than a
proper solution to me.

Discussion in this thread indicates that both of the above will be
required at some point. Have I completely missed something or will we
have to rework (parts of) the IOMMU API to make this work?

One other thing that I have some difficulty understanding is how we can
support things like process isolation using the current IOMMU API. Since
a device will be statically assigned to one IOMMU domain at probe time
there is no way we can change the address space upon a context switch.

Thierry

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTkkSWAAoJEN0jrNd/PrOhnAoP/3dnbiyJe31uxLcJwE0Bm10+
EMBYvkA7Bct+YasVpd/xS3BVCda+L4mG3qDxUWJriU9YZ6ybEnRIrpPhxh1+xoWA
iQXLkPHK+1+0f5NR56vqfOtDlY+NS2YQx2lQZ/CtswpRSzA8dYXGiVZwWXQMjsC/
f+Uj19Wusn+4Qym4AekPP5HclGyqBpYuqmZM8Yp96QHyrd3jEu4YZeRh492Fs9Xv
Xi8R5en3ZHEfU2erAgJIrY1jg0/g8TI6WGaXmGEz5SsTX7QSLde1RaJYsSoLOqsE
zm2icD8FEM3oS95zoAuoFXk5N0zL/xNWDghurLWcmG6A6iHNAeB0qAYebq888HNe
KUUObwgkfy2UaFGcLqf1VmQ8uw4p76yNwgRT1Zv+jNO7zsrZAo7zyzcYFnF4pHrv
BmspaojhXs3CRVXG0PwipcYP2SmKgnV2KpkK4aHnAS6uUMyEHP6ZB2UOqi7/SfOD
57h5Eo6ZczLWbYzYHaLr7JZE2F94p9h2vZg6utUmlaWoVFFgJeowWr+DgpdhiCwH
EFhYz4+YP4f8tEpnMY39Y8BqMJayIYbinqVgmwsbHOQWQnYAV+D3f0UzxxxRnqjP
tYhmNsaC+fiW0ZXAifXcxkddv+Dr1Owg7cEvZ7lFr6CCsIdEsbVfs8aFZ5zHQiCI
p2HYv8e/oeHFxbpX+8wi
=iyXI
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
