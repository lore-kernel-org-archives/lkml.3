Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbbA1BBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:01:47 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:42444 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759648AbbA1BBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:01:45 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        "Michal Simek" <michal.simek@xilinx.com>,
        "Stephen Boyd" <sboyd@codeaurora.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1422385549-2550-1-git-send-email-soren.brinkmann@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Soren Brinkmann" <soren.brinkmann@xilinx.com>, stable@vger.kernel.org
References: <1422385549-2550-1-git-send-email-soren.brinkmann@xilinx.com>
Message-ID: <20150128010130.22722.42627@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v2] clk: zynq: Force CPU_2X clock to be ungated
Date: Tue, 27 Jan 2015 17:01:30 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Soren Brinkmann (2015-01-27 11:05:27)
> The CPU_2X clock does not have a classical in-kernel user, but is,
> amongst other things, required for OCM and debug access. Make sure this
> clock is not mistakenly disabled during boot up by enabling it in the
> platform's clock driver.
> 
> Cc: stable@vger.kernel.org # 3.11+
> Fixes: 0ee52b157b8e 'clk: zynq: Add clock controller driver'
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Applied to clk-next.

Regards,
Mike

> ---
> v2:
>  - Fixed some typo's in the commit message
>  - added Fixes and Cc tags to commit message
> 
> As reference, the v1 submission: https://patchwork.kernel.org/patch/5698251/
> ---
>  drivers/clk/zynq/clkc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
> index 9037bebd69f7..f870aad57711 100644
> --- a/drivers/clk/zynq/clkc.c
> +++ b/drivers/clk/zynq/clkc.c
> @@ -303,6 +303,7 @@ static void __init zynq_clk_setup(struct device_node *np)
>         clks[cpu_2x] = clk_register_gate(NULL, clk_output_name[cpu_2x],
>                         "cpu_2x_div", CLK_IGNORE_UNUSED, SLCR_ARM_CLK_CTRL,
>                         26, 0, &armclk_lock);
> +       clk_prepare_enable(clks[cpu_2x]);
>  
>         clk = clk_register_fixed_factor(NULL, "cpu_1x_div", "cpu_div", 0, 1,
>                         4 + 2 * tmp);
> -- 
> 2.2.2.1.g63c5777
> 
