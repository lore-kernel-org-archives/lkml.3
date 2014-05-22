Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaEVRWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 13:22:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43979 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaEVRWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 13:22:45 -0400
Message-ID: <537E3263.7090706@codeaurora.org>
Date: Thu, 22 May 2014 10:22:43 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Georgi Djakov <gdjakov@mm-sol.com>
CC: mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v1 3/5] clk: gcc: Add APQ8084 Global Clock Controller
 support
References: <1400775885-10296-1-git-send-email-gdjakov@mm-sol.com> <1400775885-10296-4-git-send-email-gdjakov@mm-sol.com>
In-Reply-To: <1400775885-10296-4-git-send-email-gdjakov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/14 09:24, Georgi Djakov wrote:
> diff --git a/drivers/clk/qcom/gcc-msm8974.c b/drivers/clk/qcom/gcc-msm8974.c
> index 58cb2f5..c2a8d77 100644
> --- a/drivers/clk/qcom/gcc-msm8974.c
> +++ b/drivers/clk/qcom/gcc-msm8974.c
> @@ -204,6 +204,12 @@ static const struct freq_tbl ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk[] = {
>  	{ }
>  };
>  
> +static const struct freq_tbl ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk_apq8084[] = {
> +	F(19200000, P_XO, 1, 0, 0),
> +	F(50000000, P_GPLL0, 12, 0, 0),
> +	{ }
> +};
> +

Just merge this with the other blsp1_2_qup table.

>  static struct clk_rcg2 blsp1_qup1_i2c_apps_clk_src = {
>  	.cmd_rcgr = 0x0660,
>  	.hid_width = 5,
> @@ -768,6 +774,27 @@ static struct clk_rcg2 ce2_clk_src = {
>  	},
>  };
>  
> +static const struct freq_tbl ftbl_gcc_ce3_clk_apq8084[] = {
> +	F(50000000, P_GPLL0, 12, 0, 0),
> +	F(85710000, P_GPLL0, 7, 0, 0),
> +	F(100000000, P_GPLL0, 6, 0, 0),
> +	F(171430000, P_GPLL0, 3.5, 0, 0),
> +	{ }
> +};
> +

Ditto.

> +static struct clk_rcg2 ce3_clk_src_apq8084 = {

Please drop all the _apq8084 stuff. I imagine if we support other chips
in this same driver this won't make any sense.

> +	.cmd_rcgr = 0x1d10,
> +	.hid_width = 5,
> +	.parent_map = gcc_xo_gpll0_map,
> +	.freq_tbl = ftbl_gcc_ce3_clk_apq8084,
> +	.clkr.hw.init = &(struct clk_init_data){
> +		.name = "ce3_clk_src",
> +		.parent_names = gcc_xo_gpll0,
> +		.num_parents = 2,
> +		.ops = &clk_rcg2_ops,
> +	},
> +};
> +
>  static const struct freq_tbl ftbl_gcc_gp_clk[] = {
>  	F(4800000, P_XO, 4, 0, 0),
>  	F(6000000, P_GPLL0, 10, 1, 10),
> @@ -780,6 +807,12 @@ static const struct freq_tbl ftbl_gcc_gp_clk[] = {
>  	{ }
>  };
>  
> +static const struct freq_tbl ftbl_gcc_gp_clk_apq8084[] = {
> +	F(19200000, P_XO, 1, 0, 0),
> +	F(100000000, P_GPLL0, 6, 0, 0),
> +	F(200000000, P_GPLL0, 3, 0, 0),
> +	{ }
> +};

Merge with other GP table?

>  
>  static struct clk_rcg2 gp1_clk_src = {
>  	.cmd_rcgr = 0x1904,
> @@ -966,6 +999,11 @@ static const struct freq_tbl ftbl_gcc_usb_hs_system_clk[] = {
>  	{ }
>  };
>  
> +static const struct freq_tbl ftbl_gcc_usb_hs_system_clk_apq8084[] = {
> +	F(75000000, P_GPLL0, 8, 0, 0),
> +	{ }
> +};
> +

ditto.

>  static struct clk_rcg2 usb_hs_system_clk_src = {
>  	.cmd_rcgr = 0x0490,
>  	.hid_width = 5,
> @@ -1029,6 +1067,11 @@ static const struct freq_tbl ftbl_gcc_usb_hsic_system_clk[] = {
>  	{ }
>  };
>  
> +static const struct freq_tbl ftbl_gcc_usb_hsic_system_clk_apq8084[] = {
> +	F(75000000, P_GPLL0, 8, 0, 0),
> +	{ }
> +};
> +

ditto.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

