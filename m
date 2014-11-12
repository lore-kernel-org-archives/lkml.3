Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaKLQSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:18:17 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61570 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbaKLQSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:18:14 -0500
Date: Wed, 12 Nov 2014 17:18:11 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-tegra@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        mikko.perttunen@kapsi.fi, acourbot@nvidia.com,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 11/13] clk: tegra: Add EMC clock driver
Message-ID: <20141112161809.GA17305@ulmo>
References: <1415779051-26410-1-git-send-email-tomeu.vizoso@collabora.com>
 <1415779051-26410-12-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <1415779051-26410-12-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 12, 2014 at 08:56:34AM +0100, Tomeu Vizoso wrote:
[...]
> diff --git a/drivers/clk/tegra/clk-emc.c b/drivers/clk/tegra/clk-emc.c
[...]
> +#include <linux/clk-provider.h>
> +#include <linux/clk.h>
> +#include <linux/clkdev.h>
> +#include <linux/delay.h>
> +#include <linux/module.h>
> +#include <linux/of_address.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +#include <linux/sort.h>
> +#include <linux/string.h>
> +
> +#include <soc/tegra/fuse.h>
> +#include <soc/tegra/memory.h>

You should include "clk.h" here to avoid a sparse warning.

> +
> +#define CLK_SOURCE_EMC 0x19c
> +
> +#define CLK_SOURCE_EMC_EMC_2X_CLK_DIVISOR_SHIFT 0
> +#define CLK_SOURCE_EMC_EMC_2X_CLK_DIVISOR_MASK 0xff
> +#define CLK_SOURCE_EMC_EMC_2X_CLK_DIVISOR(x) (((x) & CLK_SOURCE_EMC_EMC_2X_CLK_DIVISOR_MASK) << \
> +					      CLK_SOURCE_EMC_EMC_2X_CLK_DIVISOR_SHIFT)
> +
> +#define CLK_SOURCE_EMC_EMC_2X_CLK_SRC_SHIFT 29
> +#define CLK_SOURCE_EMC_EMC_2X_CLK_SRC_MASK 0x7
> +#define CLK_SOURCE_EMC_EMC_2X_CLK_SRC(x) (((x) & CLK_SOURCE_EMC_EMC_2X_CLK_SRC_MASK) << \
> +					  CLK_SOURCE_EMC_EMC_2X_CLK_SRC_SHIFT)
> +
> +const char *emc_parent_clk_names[] = {

This can be static.

> +	"pll_m", "pll_c", "pll_p", "clk_m", "pll_m_ud",
> +	"pll_c2", "pll_c3", "pll_c_ud"
> +};
> +
> +/*
> + * List of clock sources for various parents the EMC clock can have.
> + * When we change the timing to a timing with a parent that has the same
> + * clock source as the current parent, we must first change to a backup
> + * timing that has a different clock source.
> + */
> +
> +#define EMC_SRC_PLL_M 0
> +#define EMC_SRC_PLL_C 1
> +#define EMC_SRC_PLL_P 2
> +#define EMC_SRC_CLK_M 3
> +#define EMC_SRC_PLL_C2 4
> +#define EMC_SRC_PLL_C3 5
> +const char emc_parent_clk_sources[] = {

This can be static. And a blank line between the above two would be good
aswell.

> +const struct clk_ops tegra_clk_emc_ops = {

This can be static.

Thierry

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUY4hBAAoJEN0jrNd/PrOh16YQAIQJJkYy4clPCovgcMz6DJO+
hpa/H8HUVSb1HSVgxwC5Pirk/Ce3nY5iaJ8Hs3NdsNXc2KW5RInC+0SHBtFJKMa2
a6L2KJKWD+flaVE2mASkh4vTTjYqeSnhY9C62/XChURba2XAOhrREkVsh4iTry+P
AEX7SrMg5q7F8S2xba8MF7cohP04evt/WYLC+5Us8x9N2/6zSp69vTRjM4SxgPCo
6E0Mrt55pFMVP18mPAT058d9GsVkjMs6SNKLCD+ZLlegiBwcHfRrSulzUSU6Sazt
hreMUZ9/0kVTYGb21Bhra7VbAW1GSDKLssDFyUIJ2b9HngGTsUTiQIjaiiWIqwfd
UiHoK5N9ymJcBRgfVVEfJN6BAyKIsxancQzAYv3vfjzMwh+nktWc7iYiMfF8FbWh
2wyVDM4oXw1Q6DlzWjl9pnNgeYD8JZaNzKL2U55DAhQ4isu8x125P+K7h5qjM1my
nNlk51T9i1MO71QIdxnPJaieP/DG5wp6orpsDY29AE3wCXlS6sHCcRn3Au8SzcZy
a8fBJjj/ELsXzejstYYxMt5ZLuSA++jmZXwNCihiYmK+eB0q+3WdS/7z2TwikNGq
Qg4LgMA5//CaazEn9nCOHu67+mI7hSG7mX+OmkO4PbSxDbMAyZ4z8ed/2sWQLT3S
4kEa0Z8Y3FT6FiCxKQB6
=THP4
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
