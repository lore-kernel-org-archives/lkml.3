Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbbASKcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:32:17 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56012 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbbASKcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:32:16 -0500
Message-ID: <54BCDD2A.90208@codeaurora.org>
Date: Mon, 19 Jan 2015 16:02:10 +0530
From: Archit Taneja <architt@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
CC: galak@codeaurora.org, linux-kernel@vger.kernel.org, agross@codeaurora.org
Subject: Re: [PATCH 1/5] clk: qcom: Add EBI2 clocks for IPQ806x
References: <1421419702-17812-1-git-send-email-architt@codeaurora.org> <1421419702-17812-2-git-send-email-architt@codeaurora.org> <54B9890C.2080506@codeaurora.org>
In-Reply-To: <54B9890C.2080506@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/17/2015 03:26 AM, Stephen Boyd wrote:
> On 01/16/2015 06:48 AM, Archit Taneja wrote:
>> The NAND controller within EBI2 requires EBI2_CLK and EBI2_ALWAYS_ON_CLK clocks.
>> Create structs for these clocks so that they can be used by the NAND controller
>> driver. Add an entry for EBI2_AON_CLK in the gcc-ipq806x DT binding document.
>>
>> Cc: Stephen Boyd <sboyd@codeaurora.org>
>> Signed-off-by: Archit Taneja <architt@codeaurora.org>
>
> Looks ok. I couldn't find this used in the downstream sources though.
> Can you point me to it? I'm mostly worried that this is a shared
> resource that never should be turned off, so exposing it to drivers may
> not be the right idea.

I'll share the sources.

>
>> +static struct clk_branch ebi2_aon_clk = {
>> +	.hwcg_reg = 0x3b00,
>> +	.hwcg_bit = 6,
>> +	.halt_reg = 0x2fcc,
>> +	.halt_bit = 0,
>> +	.clkr = {
>> +		.enable_reg = 0x3b00,
>> +		.enable_mask = BIT(8),
>> +		.hw.init = &(struct clk_init_data){
>> +			.name = "ebi2_always_on_clk",
>>
>
> Can this be ebi2_aon_clk to match the macro?
>

I'll fix this.

Thanks,
Archit

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
