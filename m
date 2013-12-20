Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab3LTMha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:37:30 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:64633 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130Ab3LTMh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:37:28 -0500
Date: Fri, 20 Dec 2013 13:35:55 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mark Zhang <nvmarkzhang@gmail.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        swarren@nvidia.com, will.deacon@arm.com, grant.likely@linaro.org,
        robherring2@gmail.com, joro@8bytes.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, lorenzo.pieralisi@arm.com,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        galak@codeaurora.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv7 06/12] ARM: tegra: create a DT header defining SWGROUP
 ID
Message-ID: <20131220123554.GQ27787@ulmo.nvidia.com>
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
 <1386835033-4701-7-git-send-email-hdoyu@nvidia.com>
 <52B1568F.1050305@gmail.com>
 <52B1CCF1.2040907@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/YnR2r17TIEndSCI"
Content-Disposition: inline
In-Reply-To: <52B1CCF1.2040907@wwwdotorg.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/YnR2r17TIEndSCI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2013 at 09:27:29AM -0700, Stephen Warren wrote:
> On 12/18/2013 01:02 AM, Mark Zhang wrote:
> > On 12/12/2013 03:57 PM, Hiroshi Doyu wrote:
> >> Create a header file to define the swgroup IDs used by the IOMMU(SMMU)
> >> binding. "swgroup" is a group of H/W clients which a Tegra SoC
> >> supports. This unique ID can be used to calculate MC_SMMU_<swgroup
> >> name>_ASID_0 register offset and MC_<swgroup name>_HOTRESET_*_0
> >> register bit. This will allow the same header to be used by both
> >> device tree files, and drivers implementing this binding, which
> >> guarantees that the two stay in sync. This also makes device trees
> >> more readable by using names instead of magic numbers. For HOTRESET
> >> bit shifting we need another conversion table, which will come later.
>=20
> >> diff --git a/include/dt-bindings/memory/tegra-swgroup.h b/include/dt-b=
indings/memory/tegra-swgroup.h
>=20
> >> +#define TEGRA_SWGROUP_MPE	11	/* 0x264 */
> >> +#define TEGRA_SWGROUP_MSENC	SWGROUP_MPE
> >=20
> > Need to change this to:
> >=20
> > #define TEGRA_SWGROUP_MSENC	11
> >=20
> > The reason is that, this makes "TEGRA_SWGROUP_BIT" doesn't work. So if I
> > write "TEGRA_SWGROUP_CELLS(MSENC)" in dt, that causes a dt compiling er=
ror.
>=20
> I guess it's because TEGRA_SWGROUP_BIT needs to expand its argument
> twice, which can be done.
>=20
> That all said, just defining all the names directly to constants is
> probably the most direct fix.

Erm... isn't this simply a typo, where:

	#define TEGRA_SWGROUP_MSENC	SWGROUP_MPE

should simply be

	#define TEGRA_SWGROUP_MSENC	TEGRA_SWGROUP_MPE

?

That certainly works for me.

Thierry

--/YnR2r17TIEndSCI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJStDmqAAoJEN0jrNd/PrOh9BIQALPILmOS+sOZHWzYK2s4I/Ge
8hsKWaHXgXODuRBhvOX0rqtGeK0QuvLZxtHTm1dW6wAjVvV4S/0cGAEM096dpkG8
vcCacog+nBn/WO5uC/6ZWrCGPohWw0QbcASq4X9WA45LQp2bEqdJVV2d6DB0NMWz
8l5ZLeQQJait6hEFgGxnT3elU7g431ujpfZLjUHLJbQcLuNF+8JAIFHn0bgNT/fQ
/TUwDPUa6ylCYihrZ1DrJWgdqqg9gJDaUsGWlVeKfHg3PLSMHWryl5MV8HLWLTyr
Pvt+pNPKcAkKUWxhfxFyzsYysarPUAAPgwctwDHOAhzE2NhtfFv71oU58o8o9VtR
3AyTpRB3OkcFmIbdWYSjRdnrQSoftHcSCXB88VULTcN13C1bdD1IOu7RsjvATrEn
UE8ReuMLe1cikhZU/C6a3NZZRC2Wjd4U86zwB3mHaW+Sfg4Ju4wNpZADJjB7Xupe
wR4wY2r4FT5c5vDhIIX6qEM7FUVv3pEgYZPp2u++70DqPz5L4gCDhPEbGvurcMlC
4Km3bSpdCIhoNSkJ8tSnYe0Ly3MYzYss4hFrSkV6VT8GqBrSaR8qI00e3NMBkoHa
1TsjNWwRIfG0AXDFHTW6B73KLKSSvrroSw78v1JoI8H90duaHCgRxdy/fApd64Y6
6zzBadJliF6TBspY7sTw
=12YX
-----END PGP SIGNATURE-----

--/YnR2r17TIEndSCI--
