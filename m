Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbaFZScT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:32:19 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:33911 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaFZScS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:32:18 -0400
Message-ID: <53AC6737.5010507@cogentembedded.com>
Date: Thu, 26 Jun 2014 22:32:23 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: tegra: export clock names for debugging
References: <1403797705-26910-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1403797705-26910-1-git-send-email-pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/26/2014 07:48 PM, Peter De Schrijver wrote:

> When writing a module for testing or debugging purposes, there is no way to
> get hold of clk handles. This patch solves this by exposing all valid clocks
> as clkdev's for the virtual device tegra-clk-debug.

> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>   drivers/clk/tegra/clk.c |    6 ++++++
>   1 files changed, 6 insertions(+), 0 deletions(-)

> diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
> index c0a7d77..3315fca 100644
> --- a/drivers/clk/tegra/clk.c
> +++ b/drivers/clk/tegra/clk.c
> @@ -277,6 +277,12 @@ void __init tegra_register_devclks(struct tegra_devclk *dev_clks, int num)
>   	for (i = 0; i < num; i++, dev_clks++)
>   		clk_register_clkdev(clks[dev_clks->dt_id], dev_clks->con_id,
>   				dev_clks->dev_id);
> +
> +	for (i = 0; i < clk_num; i++) {
> +		if (!IS_ERR(clks[i]) || !clks[i])

    Are you sure it should be || here, not &&? The following code doesn't seem 
to make much sense this way... Perhaps you meant !IS_ERR_OR_NULL(clks[i])?

> +			clk_register_clkdev(clks[i], __clk_get_name(clks[i]),
> +				"tegra-clk-debug");
> +	}
>   }

WBR, Sergei


