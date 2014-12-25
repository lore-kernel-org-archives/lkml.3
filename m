Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaLYNVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 08:21:08 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:57231 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaLYNVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 08:21:04 -0500
Date: Thu, 25 Dec 2014 14:20:59 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Dana Elifaz <Dana.Elifaz@amd.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        iommu@lists.linux-foundation.org,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 0/2] Change order of linkage in kernel makefiles for
 amdkfd
Message-ID: <20141225132058.GA32005@mithrandir>
References: <1419246435-7050-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <1419246435-7050-1-git-send-email-oded.gabbay@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 22, 2014 at 01:07:13PM +0200, Oded Gabbay wrote:
> This small patch-set, was created to solve the bug described at=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D89661 (Kernel panic when=20
> trying use amdkfd driver on Kaveri). It replaces the previous patch-set c=
alled=20
> [PATCH 0/3] Use workqueue for device init in amdkfd
> (http://lists.freedesktop.org/archives/dri-devel/2014-December/074401.htm=
l)
>=20
> That bug appears only when radeon, amdkfd and amd_iommu_v2 are compiled=
=20
> inside the kernel (not as modules). In that case, the correct loading=20
> order, as determined by the exported symbol used by each driver, is=20
> not enforced anymore and the kernel loads them based on who was linked=20
> first. That makes radeon load first, amdkfd second and amd_iommu_v2=20
> third.
>=20
> Because the initialization of a device in amdkfd is initiated by radeon,=
=20
> and can only be completed if amdkfd and amd_iommu_v2 were loaded and=20
> initialized, then in the case mentioned above, this initalization fails=
=20
> and there is a kernel panic as some pointers are not initialized but=20
> used nontheless.
>=20
> To solve this bug, this patch-set moves iommu/ before gpu/ in drivers/Mak=
efile=20
> and also moves amdkfd/ before radeon/ in drivers/gpu/drm/Makefile.
>=20
> The rationale is that in general, AMD GPU devices are dependent on AMD IO=
MMU=20
> controller functionality to allow the GPU to access a process's virtual m=
emory=20
> address space, without the need for pinning the memory. That's why it mak=
es=20
> sense to initialize the iommu/ subsystem ahead of the gpu/ subsystem.

I strongly object to this patch set. This makes assumptions about how
the build system influences probe order. That's bad because seemingly
unrelated changes could easily break this in the future.

We already have ways to solve this kind of dependency (driver probe
deferral), and I think you should be using it to solve this particular
problem rather than some linking order hack.

Coincidentally there's a separate thread currently going on that deals
with IOMMUs and probe order. The solution being worked on is currently
somewhat ARM-specific, so adding a couple of folks for visibility. It
looks like we're going to need something more generic since this is a
problem that even the "big" architectures need to solve.

Thierry

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUnA85AAoJEN0jrNd/PrOhOhQP/R2/gjyWpSmrLjCdAmt2V1os
8zRPbOetLNjLMPX/BZF9B1nmldGR7rVeXIwFtbd1rb79mJ1Lqi+E1c8r5gJjB6JL
VYvEV7EDmhz9wk7ffpNmP4dIjb/pAdRlEdh9LgHO3Z6yXXo1gzvmdbhwCl/5XQJW
17WUvFtGcVtbiyHVmShmtXB8kBjT1TFfecez91e03kL4br+A4lCW7GdNluEtgmKG
G2tP2H+Bd2UJ0P4IV8qu3W4xM33FyQTs9RC9ejy7h6nhEJ+yjflxdFWYL11M4hEg
da2DBh1DEs8UwVtblB+Sh8I/tXoqZukdZpUZZrhroUxdUCjtDNrHXUcGsE4GiT7H
qqybCotE+JNnJb6VVx6I7/60elxYnnBbhviGbweztoQHtg5R2R1+1+z0/sPYzZm2
7H2UpeBK6odTVMt0s6BykxrDSIcGF5z+y0E7cJZhfOsdqcqxmm7Rdai7s37c4soL
r+vIa9jgWL82L17qEVsQWyhl68BdsMTZmsLKKLyxzpW2OMAGqF3K4Vs4FeNGZDQi
snNdka12KJmb1Gi2k/75vxzUwvHAZ/OgW9RkBrAPFNg/6n0Ku12iYx1qwwdlj9Xo
2jzdxzSn66XTB2uO7HseaJ5iOFeo1Y1ZnIbTbsE6sgO4sQhEiyqw4O27Ygkc6SNI
TFemNK1eWgMyI4yWtMAT
=FLwM
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
