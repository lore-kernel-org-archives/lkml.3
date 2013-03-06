Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab3CFXUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:20:06 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1247 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab3CFXUB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:20:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 06 Mar 2013 15:20:01 -0800
From: Andrew Chew <AChew@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 6 Mar 2013 15:20:00 -0800
Subject: RE: [PATCH] clk: tegra: provide dummy cpu car ops
Thread-Topic: [PATCH] clk: tegra: provide dummy cpu car ops
Thread-Index: Ac4Kwwor0tKqsWgZTgGiTbxKqNunOwP/WlyA
Message-ID: <643E69AA4436674C8F39DCC2C05F7638629CA50C97@HQMAIL03.nvidia.com>
References: <1360853581-9756-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1360853581-9756-1-git-send-email-pdeschrijver@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH] clk: tegra: provide dummy cpu car ops
> 
> tegra_boot_secondary() relies on some of the car ops. This means having an
> uninitialized tegra_cpu_car_ops will lead to an early boot panic.
> Providing a dummy struct avoids this and makes adding Tegra114 clock
> support in a bisectable way a lot easier.
> 
> --
> 
> Stephen,
> 
> Should this be a separate patch or should I make this part of new release of
> the Tegra114 clock series?
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>  drivers/clk/tegra/clk.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c index
> a603b9a..f6c141f 100644
> --- a/drivers/clk/tegra/clk.c
> +++ b/drivers/clk/tegra/clk.c
> @@ -22,7 +22,8 @@
>  #include "clk.h"
> 
>  /* Global data of Tegra CPU CAR ops */
> -struct tegra_cpu_car_ops *tegra_cpu_car_ops;

Sorry for bringing this up so late...
Shouldn't the above be "struct tegra_cpu_car_ops tegra_cpu_car_ops;"?

> +static struct tegra_cpu_car_ops *dummy_car_ops; struct
> +tegra_cpu_car_ops *tegra_cpu_car_ops = &dummy_car_ops;
> 
>  void __init tegra_init_dup_clks(struct tegra_clk_duplicate *dup_list,
>  				struct clk *clks[], int clk_max)
> --
> 1.7.7.rc0.72.g4b5ea.dirty
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
