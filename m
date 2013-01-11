Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab3AKUyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:54:12 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35028 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab3AKUyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:54:10 -0500
Message-ID: <50F07BEF.1080208@wwwdotorg.org>
Date: Fri, 11 Jan 2013 13:54:07 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/9] clk: tegra: add clock support for tegra20
References: <1357890387-23245-1-git-send-email-pgaikwad@nvidia.com> <1357890387-23245-7-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1357890387-23245-7-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 12:46 AM, Prashant Gaikwad wrote:
> Add tegra20 clock support based on common clock framework.

> diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile

> +static void tegra20_pll_init(void)

> +	/* PLLE */
> +	clk = tegra_clk_plle("pll_e", "pll_ref", clk_base, NULL,
> +			     0, 1000000000, &pll_e_params,
> +			     0, pll_e_freq_table, NULL);

That 1000000000 (1GHz) needs to be 100000000 (100MHz). I can fix that up
when applying this.

With that change, everything I tested with this version of the series
works:-)
