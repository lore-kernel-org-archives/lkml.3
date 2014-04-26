Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaDZBxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 21:53:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56579 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaDZBxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 21:53:07 -0400
Message-ID: <535B1181.4010209@codeaurora.org>
Date: Fri, 25 Apr 2014 18:53:05 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2] clk: qcom: Add support for IPQ8064's global clock
 controller (GCC)
References: <1396642749-12979-1-git-send-email-galak@codeaurora.org>
In-Reply-To: <1396642749-12979-1-git-send-email-galak@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/14 13:19, Kumar Gala wrote:
> +
> +#define P_PXO	0
> +#define P_PLL8	1
> +#define P_CXO	2
> +#define P_PLL3	3

This #define needs to be 1. Unfortunately the way we do this mapping
requires that they match the parents string array. If you have a better
idea I'm all for it.

> +
> +static const u8 gcc_pxo_pll8_map[] = {
> +	[P_PXO]		= 0,
> +	[P_PLL8]	= 3,
> +};
> +
> +static const char *gcc_pxo_pll8[] = {
> +	"pxo",
> +	"pll8_vote",
> +};
> +
> +static const u8 gcc_pxo_pll8_cxo_map[] = {
> +	[P_PXO]		= 0,
> +	[P_PLL8]	= 3,
> +	[P_CXO]		= 5,
> +};
> +
> +static const char *gcc_pxo_pll8_cxo[] = {
> +	"pxo",
> +	"pll8_vote",
> +	"cxo",
> +};
> +
> +static const u8 gcc_pxo_pll3_map[] = {
> +	[P_PXO]		= 0,
> +	[P_PLL3]	= 1,
> +};
> +
> +static const char *gcc_pxo_pll3[] = {
> +	"pxo",
> +	"pll3",
> +};
> +

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

