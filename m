Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbbAGO3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:29:33 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:38325 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbAGO3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:29:31 -0500
Date: Wed, 7 Jan 2015 15:29:26 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Walmsley <paul@pwsan.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Allen Martin <amartin@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH] clocksource: tegra: wrap arch/arm-specific sections in
 CONFIG_ARM
Message-ID: <20150107142923.GC1621@ulmo>
References: <alpine.DEB.2.02.1412092201200.31750@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tqI+Z3u+9OQ7kwn0"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1412092201200.31750@utopia.booyaka.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tqI+Z3u+9OQ7kwn0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 09, 2014 at 10:07:18PM +0000, Paul Walmsley wrote:
>=20
> Like several of the other files in drivers/clocksource,
> tegra20_timer.c contains code that can only compile when CONFIG_ARM is
> enabled.  This causes obvious problems when trying to compile this
> code for NVIDIA ARM64-based SoCs, such as Tegra132.  The same timer IP
> blocks exist, so it seems appropriate to provide support for them.
>=20
> So until we figure out a better way to partition this code, wrap the
> delay_timer and persistent_clock support code with preprocessor tests
> for CONFIG_ARM.  (The delay_timer code should not be needed at all on
> ARM64 due to the presence of the ARMv8 architected timer.  The
> persistent_clock support code could become important once power
> management modes are implemented that turn off the CPU complex.)
>=20
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
> Cc: Allen Martin <amartin@nvidia.com>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Thierry Reding <treding@nvidia.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> ---
> Applies against next-20141209.
> Intended for v3.20.
> Boot-tested on Tegra124 Jetson TK1 on next-20141209.
> Also boot-tested on Tegra132 Norrin FFD on next-20141209 + extra,=20
> unrelated patches.
>=20
>  drivers/clocksource/tegra20_timer.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)

Daniel, Thomas,

This patch is a build dependency for 64-bit Tegra support that I'd like
to merge for v3.20. Would you be willing to give your Acked-by on this
so that I can take it into the same tree along with some other
dependencies and the patches that enable the 64-bit build?

Thanks,
Thierry

--tqI+Z3u+9OQ7kwn0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUrULDAAoJEN0jrNd/PrOhtNQP/RMd3e3U8SxcubIYD4Sg6Psq
+1/RQoi7V+TOeEP+Xvj0TviwDJ8MvdB1pUYA7y9UaVPm8VlL6pI6eLETGJXkJjA5
SPwU5LUb6yM9ORD9fNE2kXQSI3Qghb3XNxmgabeu9yIrZgZtQgpwRw4nVOFOPezh
u4lTu7yuwjZoehox/bydU/Uj1bTWOHmUu9w7TaSp9ee2FBjJ5iPTBQMe3riHF66a
tUE/iZ/+5FIVpz1IaB2tleiWlx9yBAG+Aq5Rvoj5yqGIkD1SAfQspG/0hl2m9jhm
9BTDp0ICJZIzifUCIi9/mujcSEM6In81zj82cKBYRTechzUbgrdcSklfFGb34RwK
1lrjI8VdStx4z6TfiFL9k6TOqkyBvgeB0hjo7AzG7xFljGlU1rBAl2b4e8BV5VdP
9/eNK/RxLrRRqs0vr2S63sWsHNkA8S49bA+j7J1p1W3OQNy1PGKW7gCVl3n/EY4B
/wvEGSpPBd3Osp06TrbjGDXP2k5oz6cc5IxrcPuVDv/IMEIC2XToM2QAvxWdsZhi
03zIkXFz9JbZonlx105VQectk102iel9xwmKhJILaytu12RCva//8wRqhLHxv7kT
ACBd/Gq9FuELcui0tx/aou43FjbdLma+gE6CRk9CCzZzN2p6RVALTRpZBfeiDw5z
L+1paZDCqDZWY1VPqHVD
=lWvM
-----END PGP SIGNATURE-----

--tqI+Z3u+9OQ7kwn0--
