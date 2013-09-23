Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab3IWSQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:16:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57758 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab3IWSQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:16:23 -0400
Message-ID: <52408572.2030907@wwwdotorg.org>
Date: Mon, 23 Sep 2013 12:16:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 06/12] clk: tegra: add common infra for DT clocks
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com> <1379515331-19427-7-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1379515331-19427-7-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 08:40 AM, Peter De Schrijver wrote:
> Introduce a common infrastructure for registering DT IDs for tegra clocks and
> sharing clock initialization between SoCs. Move Tegra114 to this new
> infrastructure.

> diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c

> +static struct tegra_clk __initdata tegra114_clks[tegra_clk_max] = {
> +	[tegra_clk_rtc] = { .dt_id = TEGRA114_CLK_RTC, .present = true },
> +	[tegra_clk_timer] = { .dt_id = TEGRA114_CLK_TIMER, .present = true },

It seems rather odd for a patch that adds "common infrastructure" to be
adding a Tegra114-specific table of clock IDs, especially since this new
table isn't actually used at all. I think I would expect a separate
patch for the common infra-structure and the Tegra114-specific table.
Hopefully there will be Tegra20-/30-specific tables added too in that
second patch?
