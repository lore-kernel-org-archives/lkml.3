Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741Ab3JOUaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:30:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59883 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759432Ab3JOU37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:29:59 -0400
Message-ID: <525DA5C3.5070903@wwwdotorg.org>
Date: Tue, 15 Oct 2013 14:29:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 5/7] clk: tegra124: Add support for Tegra124 clocks
References: <1381850098-12357-1-git-send-email-pdeschrijver@nvidia.com> <1381850098-12357-6-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1381850098-12357-6-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 09:14 AM, Peter De Schrijver wrote:
> Implement clock support for Tegra124.

> diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c

> +static struct pdiv_map pll12g_ssd_esd_p[] = {
> +	{ .pdiv = 1, .hw_val = 0 },
> +	{ .pdiv = 2, .hw_val = 1 },
...
> +	{ .pdiv = 24, .hw_val = 13 },
> +	{ .pdiv = 32, .hw_val = 14 },
> +	{ .pdiv = 0, .hw_val = 15 },
> +};

I'm curious why that last entry doesn't have .hw_val = 0, since I think
it's a sentinel value. For example, the last entry in pllxc_p[] does
have .hw_val = 0.

> diff --git a/include/dt-bindings/clock/tegra124-car.h b/include/dt-bindings/clock/tegra124-car.h

I think you also need to create
Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt in this
patch. All the other SoCs have their own binding file. That said, given
all the clock IDs have moved into <dt-bindings/clock/tegraNNN-car.h>,
perhaps we should just have a separate patch that removes the separate
bindings for Tegra30 and Tegra114, and simply add their compatible
values into the existing nvidia,tegra20-car.txt (and also make the
header file reference in that file more generic so it applies to any
Tegra SoC)?

> @@ -0,0 +1,341 @@
> +/*
> + * This header provides constants for binding nvidia,tegra124-car.
> + *
> + * The first 185 clocks are numbered to match the bits in the CAR's CLK_OUT_ENB
> + * registers.

Shouldn't that be 192 (== 185 * 32)? Perhaps some bits aren't allocated,
but in previous SoCs, I rounded the ID space for peripheral clocks up to
whole registers. I see that as far as the clock IDs, this is already
fine; it's just this description that says 185 not 192.
