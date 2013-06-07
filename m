Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab3FGQxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:53:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43036 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab3FGQxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:53:42 -0400
Message-ID: <51B21012.2030302@wwwdotorg.org>
Date: Fri, 07 Jun 2013 10:53:38 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Paul Walmsley <pwalmsley@nvidia.com>, Hiroshi Doyu <hdoyu@nvidia.com>
CC: linux-tegra@vger.kernel.org, mturquette@linaro.org,
        Andrew Chew <achew@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Matthew Longnecker <mlongnecker@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] clk: tegra: T114: add DFLL source clocks
References: <20130607121505.21868.72360.stgit@dusk.lan> <20130607121858.21868.73882.stgit@dusk.lan>
In-Reply-To: <20130607121858.21868.73882.stgit@dusk.lan>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 06:19 AM, Paul Walmsley wrote:
> Add the input clocks needed by the DFLL IP blocks.  Initialize them to
> 51MHz (as required by the DFLL GFD) and to use the PLL_P clock source.
> 
> This patch is a collaboration with Peter De Schrijver
> <pdeschrijver@nvidia.com>.
> 
> Thanks to Laxman Dewangan <ldewangan@nvidia.com> for identifying the
> requirement to keep the DFLL clocks enabled to resolve PWR_I2C timeout
> issues.

> diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c

> @@ -792,6 +794,7 @@ enum tegra114_clk {
>  	audio1, audio2, audio3, audio4, spdif, clk_out_1, clk_out_2, clk_out_3,
>  	blink, xusb_host_src = 252, xusb_falcon_src, xusb_fs_src, xusb_ss_src,
>  	xusb_dev_src, xusb_dev, xusb_hs_src, sclk, hclk, pclk, cclk_g, cclk_lp,
> +	dfll_ref = 264, dfll_soc,

Those values need to be added to the DT binding documentation, or rather
the header file that now defines the constants for that binding.

BTW, I was rather hoping that Hiroshi would have converted the clock
drivers to actually use that header file by now... Then this requirement
would have been a lot more obvious. Hiroshi, are patches for that coming
soon? Paul, if not, are you able to do that?

For reference, include/dt-bindings/clock/tegra*-car.h.
