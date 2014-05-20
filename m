Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaETLtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 07:49:46 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17638 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbaETLto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 07:49:44 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-f3-537b41558366
Message-id: <537B4153.8030203@samsung.com>
Date: Tue, 20 May 2014 13:49:39 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc: mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        grant.likely@linaro.org, mark.rutland@arm.com, galak@codeaurora.org,
        pawel.moll@arm.com, kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC V6 2/2] clk: Add handling of clk parent and rate
 assigned from DT
References: <1400520171-6698-1-git-send-email-s.nawrocki@samsung.com>
 <1400520171-6698-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1400520171-6698-3-git-send-email-s.nawrocki@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t/xq7qhjtXBBn+uClrMP3KO1aL/zUJW
	iwN/djBanG16w26x6fE1VovLu+awWdy+zGux9shddoul1y8yWTydcJHNYsL0tSwWrXuPsFvM
	mPySzWL9jNcsDnwea+atYfRoae5h87jc18vksWlVJ5vHnWt72Dw2L6n36NuyitHj8ya5AI4o
	LpuU1JzMstQifbsErozjcw4yF5xgqbjRcZC9gfECcxcjJ4eEgInE0tbJjBC2mMSFe+vZuhi5
	OIQEljJKvD5+Bsr5xCixYv5PsCpeAS2JF5+6wbpZBFQlfl3ZBBZnEzCU6D3aB2RzcIgKREg8
	viAEUS4o8WPyPRYQW0TARaLzwTowm1lgMZPEgV+RILawQLTErc3PmCB2NTJK3N79mB0kwSng
	JvFqwkkmiAYdif2t09ggbHmJzWveMk9gFJiFZMcsJGWzkJQtYGRexSiaWppcUJyUnmuoV5yY
	W1yal66XnJ+7iRESR192MC4+ZnWIUYCDUYmH18G2KliINbGsuDL3EKMEB7OSCK+2bXWwEG9K
	YmVValF+fFFpTmrxIUYmDk6pBsbZhTe7vl5I1HWpdA3tjHW/V9O4zV5dZun2D68yp8fPOWvT
	eZMzJdVm14bjLMc/nQps3rbaTf00z7eVU9i2BMiwR3d+2/dnaS1rk0Sx5zTJtmuyHKfzr7yr
	E2IvzLg//fzNc7+Ez5eETtYqWvDjx4Epjzs6/mkxFvR2RnKYMNRa/H5suyrXa5ESS3FGoqEW
	c1FxIgAG3dzegQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/05/14 19:22, Sylwester Nawrocki wrote:
> @@ -2620,7 +2639,10 @@ void __init of_clk_init(const struct of_device_id *matches)
>  		list_for_each_entry_safe(clk_provider, next,
>  					&clk_provider_list, node) {
>  			if (force || parent_ready(clk_provider->np)) {
> +
>  				clk_provider->clk_init_cb(clk_provider->np);
> +				of_clk_set_defaults(np, true);

There is an error in this patch, this line should read:

+				of_clk_set_defaults(clk_provider->np, true);

>  				list_del(&clk_provider->node);
>  				kfree(clk_provider);
>  				is_init_done = true;

