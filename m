Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbaEVFNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 01:13:55 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46361 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaEVFNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 01:13:53 -0400
Message-ID: <537D8788.8030904@linaro.org>
Date: Thu, 22 May 2014 10:43:44 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Mark Brown <broonie@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 3/4] clk: samsung: Add driver to control CLKOUT line on
 Exynos SoCs
References: <1400604211-9447-1-git-send-email-t.figa@samsung.com> <1400604211-9447-4-git-send-email-t.figa@samsung.com>
In-Reply-To: <1400604211-9447-4-git-send-email-t.figa@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 10:13 PM, Tomasz Figa wrote:
> This patch introduces a driver that handles configuration of CLKOUT pin
> of Exynos SoCs that can be used to output certain clocks from inside of
> the SoC to a dedicated output pin.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  .../devicetree/bindings/arm/samsung/pmu.txt        |  30 ++++
>  drivers/clk/samsung/Makefile                       |   1 +
>  drivers/clk/samsung/clk-exynos-clkout.c            | 153 +++++++++++++++++++++
>  3 files changed, 184 insertions(+)
>  create mode 100644 drivers/clk/samsung/clk-exynos-clkout.c
> 

[ ... ]

> +	clkout->clk_table[0] = clk_register_composite(NULL, "clkout",
> +				parent_names, parent_count, &clkout->mux.hw,
> +				&clk_mux_ops, NULL, NULL, &clkout->gate.hw,
> +				&clk_gate_ops, CLK_SET_RATE_PARENT
> +				| CLK_SET_RATE_NO_REPARENT);

Would you please remove CLK_SET_RATE_NO_REPARENT flag from here? Let me
know if you have reservations against this.

With RFC patches, I am able to do a clk_set_rate() on this clock to
get a 24MHz output to the codec clock. With this flag set, I again have
to rely on the default value set to this register in bootloader.

-- 
Tushar Behera
