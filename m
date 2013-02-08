Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977Ab3BHHrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 02:47:42 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:57033 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab3BHHrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 02:47:40 -0500
Date: Fri, 8 Feb 2013 09:47:20 +0200
From: Felipe Balbi <balbi@ti.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, <arnd@arndb.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ARM: tegra: Unify tegra{20,30,114}_init_early()
Message-ID: <20130208074720.GB21879@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1360308574-19658-1-git-send-email-hdoyu@nvidia.com>
 <1360308574-19658-2-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fba/0zbH8Xs+Fj9o"
Content-Disposition: inline
In-Reply-To: <1360308574-19658-2-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 08, 2013 at 09:29:31AM +0200, Hiroshi Doyu wrote:
> @@ -56,18 +56,21 @@ int tegra_cpu_disable(unsigned int cpu)
>  	return cpu =3D=3D 0 ? -EPERM : 0;
>  }
> =20
> -#ifdef CONFIG_ARCH_TEGRA_2x_SOC
> -extern void tegra20_hotplug_shutdown(void);
> -void __init tegra20_hotplug_init(void)
> +void __init tegra_hotplug_init(void)
>  {
> -	tegra_hotplug_shutdown =3D tegra20_hotplug_shutdown;
> -}
> +	switch (tegra_chip_id) {
> +#ifdef CONFIG_ARCH_TEGRA_2x_SOC
> +	case TEGRA20:
> +		tegra_hotplug_shutdown =3D tegra20_hotplug_shutdown;
> +		break;
>  #endif
> -
> -#ifdef CONFIG_ARCH_TEGRA_3x_SOC
> -extern void tegra30_hotplug_shutdown(void);
> -void __init tegra30_hotplug_init(void)
> -{
> -	tegra_hotplug_shutdown =3D tegra30_hotplug_shutdown;
> -}
> +#if defined(CONFIG_ARCH_TEGRA_3x_SOC)

how about using:

#if IS_BUILTIN(CONFIG_ARCH_TEGRA_3x_SOC)

instead ?

> diff --git a/arch/arm/mach-tegra/sleep.h b/arch/arm/mach-tegra/sleep.h
> index 4ffae54..970ebd5 100644
> --- a/arch/arm/mach-tegra/sleep.h
> +++ b/arch/arm/mach-tegra/sleep.h
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (c) 2010-2012, NVIDIA Corporation. All rights reserved.
> + * Copyright (c) 2010-2013, NVIDIA Corporation. All rights reserved.
>   *
>   * This program is free software; you can redistribute it and/or modify =
it
>   * under the terms and conditions of the GNU General Public License,
> @@ -124,11 +124,11 @@ int tegra_sleep_cpu_finish(unsigned long);
>  void tegra_disable_clean_inv_dcache(void);
> =20
>  #ifdef CONFIG_HOTPLUG_CPU
> -void tegra20_hotplug_init(void);
> -void tegra30_hotplug_init(void);
> +void tegra20_hotplug_shutdown(void);
> +void tegra30_hotplug_shutdown(void);

aren't these two called only by tegra_hotplug_init() now ? That means
they don't need to be exposed.

--=20
balbi

--Fba/0zbH8Xs+Fj9o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRFK2IAAoJEIaOsuA1yqREh1EP/229kuSGNVelXDtla3Y8B07T
8bMwvhjjAJw8SFhsWoimPxjGROjqMZyl5uJQpTZPKPIGwt8e/zSg6wu/0pBn17rt
ehC89NHwH3GitM9K9Vo4IKQBmQw05XAdeuvROpYHRxKdytfXsHdZ5GifHc9lQcnq
rQEso6itvJlE63OkNJJSU37gmnltFjzQTvkKLdzpDnZMEhazySV2A7gtm+8H7pFM
Rdvyo+r3ZNTDB0JUztq1bAu66q/Vo3panJeHZue1gVuJKRYuqDFXPdvHA+GgMbsq
Wub9CFGoUgsmNXnFmPjsjrq+nKd2gJuuNp4+TU0KgsPQsx6eVtbQeWQlRHUi9Ho5
s4IHAnxtNsTzhDCcKkU2mH59VGgL6u6hxfZZPmY9LfMTL/dDLBJWrroVAgdSzQcr
yJm/YgSVziP6O2xgOnydQ+1EdSMMM56s6s+w9Z+rJjNrqXqOuhjd0XmI5iyjYxcN
CyIrB9iSnIPea6Vf0AzCZnL48RsIo8ymwouDPcEx4MQuOxWCcp9sD9rOZStBLIZa
aP14vCU/WARHt+4xeUaW+k0LgpkQwuhSOq/j4uGi/TC6cTdcojlTsrAblLQtjKkk
Rd7NaE4HMCPgQ3RbhMBfnwkhiOFr4Pr8bS5RQvICmE4+cFSGyQxQ7ecPJi00hdnU
4LC0TBWtpG2DRsBx7Icu
=AGIZ
-----END PGP SIGNATURE-----

--Fba/0zbH8Xs+Fj9o--
