Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbaLJLPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:15:20 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:9594 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaLJLPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:15:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 10 Dec 2014 03:13:31 -0800
Date: Wed, 10 Dec 2014 12:14:27 +0100
From: Thierry Reding <treding@nvidia.com>
To: Paul Walmsley <paul@pwsan.com>, Thomas Gleixner <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        <linux-tegra@vger.kernel.org>, Allen Martin <amartin@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH] clocksource: tegra: wrap arch/arm-specific sections in
 CONFIG_ARM
Message-ID: <20141210111425.GD15287@ulmo.nvidia.com>
References: <alpine.DEB.2.02.1412092201200.31750@utopia.booyaka.com>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1412092201200.31750@utopia.booyaka.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.2.70.89]
X-ClientProxiedBy: UKMAIL102.nvidia.com (10.26.138.15) To
 drukmail101.nvidia.com (10.25.59.19)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AbQceqfdZEv+FvjW"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--AbQceqfdZEv+FvjW
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

You might want to read the following thread:

	https://lkml.org/lkml/2014/11/7/605

I haven't gotten around to look at this in detail, but it seems like we
may not need to register the RTC early here at all. If that's really the
case we can just get rid of this hackery and do everything within the
RTC driver rather than duplicate some of that code here.

On 32-bit ARM, Tegra114 and Tegra124 also support the architected timer,
so the only remaining issue would be for Tegra20 and Tegra30 hardware.
But I also seem to remember that on most boards the Tegra RTC can't be
used properly because it doesn't have a battery. So while it may still
work while the board is powered it is not very useful as RTC. Or for
timekeeping across suspend/resume for that matter. The majority of
boards seem to have a PMIC with an integrated RTC and will use that
instead.

Otherwise this looks good to me to get things going on 64-bit ARM while
we iron out the other issues. Can I assume that you plan on sending in
patches that enable 64-bit ARM Tegra in the 3.20 timeframe? If so it
might be best to take this patch through the Tegra tree, provided that
Daniel and Thomas have no objections, to make sure we don't have
intermittent build breakage depending on the order in which the trees
get pulled into linux-next and Linus' tree. Even more so because there
are a couple of other, similar patches which makes a stable branches
oriented approach to resolving these dependencies somewhat impractical.

Thierry

--AbQceqfdZEv+FvjW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUiCsRAAoJEN0jrNd/PrOhbvAP/RhKBAkkIYwSJ+gvoyM404bR
qn+Dveanx8vm/vzcFapkuW1y8SXLt+NCIPAzUTpbHRtcbcCVjJBoboezytoO7neQ
sVanYevihKjayZ2xHtWoDD4O44adrX6mp7Bq+ZBzF/ofCmD03Jw7keM3L/Ek3WwP
EBCaa8qWb7NZSR5PSI2Hh2geNatof5bWkf439WxvfaC2CFD1sHorJslIWj1HwbdO
7vS+fwtk0N6FjSJCgMZIl6DelYC5RW6Kl3sGHG4M5ZgOUEgGJEjI8kxfCnaTGskj
B3ccoDt6jrapHH/xZNgFAJLDDBmllzPJk2nZeQcjaV5KjwGBJZNGRrMp/xZ2p12N
YFO1WtHaC2SDbEEvnEMvy7yndcHeUYq3eYePkbcKXOlFJQGxDoFlkeOPDkM9vSIP
Vou/Cqn6BS8G8/jXaBE05HZDCPKD00WXDajnXLUAbBs5L/giAP+ceITY4AfpQrbl
bro05jGGZIsclzQTN1LV8KaYIenJ72Zn2iFe9F5WBfxPUJ8GKpkvqeL2sgEAa9+r
U4a5E9EHB0pUnhKiGBB+0ZSopcp/Z3h5KAIZCjhJW7SwpwKQl/QdP2PQ6c/nltv2
/Yv/QjbVufVERd2E9/S3rVNBZ+L+2GaNs2DqdGdOXaJoF1eVbhlKHhCaXc359W1X
ydHvnTRKP0imV0mfq7ya
=FmiT
-----END PGP SIGNATURE-----

--AbQceqfdZEv+FvjW--
