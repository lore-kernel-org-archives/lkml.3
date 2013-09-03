Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275Ab3ICSK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 14:10:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52982 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760244Ab3ICSKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 14:10:55 -0400
Message-ID: <52262629.8010605@wwwdotorg.org>
Date: Tue, 03 Sep 2013 12:10:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-tegra@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] clk: tegra: convert Tegra114 gate clocks to table
References: <1378215105-12145-1-git-send-email-pdeschrijver@nvidia.com> <1378215105-12145-3-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1378215105-12145-3-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 07:31 AM, Peter De Schrijver wrote:
> This patch converts the Tegra114 gate clock registration to be table driven
> like the periph clocks. The same struct tegra_periph_init_data is used for the
> table, but some fields are unused. This makes the code easier to read and also
> paves the way to share clock data between Tegra SoCs.

> diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c

> +static const char *clk_32k[] = {
> +	"clk_32k",
> +};


I think those new arrays of strings are only used ...

> @@ -2114,6 +2023,26 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)

> +	for (i = 0; i < ARRAY_SIZE(tegra_periph_gate_clk_list); i++) {
> +		int reg_bank;
> +
> +		data = &tegra_periph_gate_clk_list[i];
> +		reg_bank = get_reg_bank(data->periph.gate.clk_num);
> +
> +		if (reg_bank >= 0) {
> +			clk = tegra_clk_register_periph_gate(data->name,
> +					data->parent_names[0],

... here. If so, why make them arrays? Surely they could just be a const
char * inside tegra_periph_gate_clk_list[i]?
