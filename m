Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbbASOBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:01:09 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:38328 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbbASOBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:01:06 -0500
Date: Mon, 19 Jan 2015 15:01:01 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: Store tegra_resume() address in IRAM
Message-ID: <20150119140059.GE23778@ulmo.nvidia.com>
References: <1421319545-23920-1-git-send-email-digetx@gmail.com>
 <1421319545-23920-3-git-send-email-digetx@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jTMWTj4UTAEmbWeb"
Content-Disposition: inline
In-Reply-To: <1421319545-23920-3-git-send-email-digetx@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jTMWTj4UTAEmbWeb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2015 at 01:58:58PM +0300, Dmitry Osipenko wrote:
> Commit 7232398abc6a ("ARM: tegra: Convert PMC to a driver") changed tegra=
_resume()
> location storing from late to early and, as a result, broke suspend on Te=
gra20.
> PMC scratch register 41 is used by tegra LP1 resume code for retrieving s=
tored
> physical memory address of common resume function and in the same time us=
ed by
> tegra20_cpu_shutdown() (shared by Tegra20 cpuidle driver and platform SMP=
 code),
> which is storing CPU1 "resettable" status. It implies strict order of scr=
atch
> register usage, otherwise resume function address is lost on Tegra20 after
> disabling non-boot CPU's on suspend. Fix it by storing tegra_resume() phy=
sical
> address in IRAM instead of PMC scratch register.
>=20
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> Fixes: 7232398abc6a (ARM: tegra: Convert PMC to a driver)
> Cc: <stable@vger.kernel.org> # v3.17+
> ---
>  arch/arm/mach-tegra/pm.c            |  3 +++
>  arch/arm/mach-tegra/reset-handler.S |  4 ++++
>  arch/arm/mach-tegra/reset.h         |  4 ++++
>  arch/arm/mach-tegra/sleep-tegra20.S |  7 ++++---
>  arch/arm/mach-tegra/sleep-tegra30.S |  7 ++++---
>  drivers/soc/tegra/pmc.c             | 19 -------------------
>  6 files changed, 19 insertions(+), 25 deletions(-)

I don't think this is a good variant. I'm sure it'll work, but storing a
pointer to tegra_resume() is actually the documented purpose of the PMC
scratch 41 register. That is, some software (like bootloaders and
whatnot) may actually rely on this behaviour.

Thierry

--jTMWTj4UTAEmbWeb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUvQ4bAAoJEN0jrNd/PrOhEq0QAIbOqwSoLUJdyKmB5gLoJ9eD
TWtACxINVQW+8zXcfz7aVvMYOrv7AJnIIjLGmV3e9vIQCp6igQ5jMcZtiFrSEHe3
0nPtbeAwUMrZ5H95ouHsTmKPAN/Er4TirhaFFT5HG0ts0zrFMZqha1A9/lKz/BNx
d6fprKk249sbTqst4IizXnjv6xQecEdlWH+YsGeLlF3YUHySt18N+sOLl3otwPQu
c08D7l5W2j6R2E2gD9uNc9r2WC9J0VxtcEZzaNzE98aKApU/+giXzZWdVV+KSJY/
wB0lyYd6Zx9YJXfAzw5B2jXs56BK5DMCzayAwXHfoxdweNLHqD+v0yW9fKUM1QP1
Y5Nwf6cPwWRfN75xjfyUYe2GmtbSTHr7YdugsV/SrdnfolWVO44wgeHfLQrJDMeX
tNOChN5mhtXGdG8ckPr5VO4KACfeUtm29ZNBr/DXVZZk0Ean2OKnrAgRiMX4nA2p
unT86kPhDu/N20CnN8ArzyEZXwFPbqK9hCYfIYCDnqa77jPTlFLFocNSAM7AfFSa
y/X26N/RTam8sShF1B0jkDB6VZogNJbWnreYVLcudCsJ2Dx1JM2EY+rpfPfD/uhd
2cEnO4E7lWOdv+WQady9+s9YWt9noPnpClVDhK1jKcKWuVsUabebOv41NRQuDdIe
ddoWnkVIHugTml0gMP2k
=vcfL
-----END PGP SIGNATURE-----

--jTMWTj4UTAEmbWeb--
