Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab3AJVGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 16:06:18 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62942 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab3AJVGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 16:06:17 -0500
X-IronPort-AV: E=Sophos;i="4.84,446,1355126400"; 
   d="scan'208";a="19123947"
Message-ID: <50EF2D48.2080004@codeaurora.org>
Date: Thu, 10 Jan 2013 13:06:16 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] clk: Add composite clock type
References: <1357278706-28149-1-git-send-email-pgaikwad@nvidia.com> <50E75538.5010706@codeaurora.org> <50E794D0.7040907@nvidia.com>
In-Reply-To: <50E794D0.7040907@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/13 18:49, Prashant Gaikwad wrote:
> On Saturday 05 January 2013 03:48 AM, Stephen Boyd wrote:
>> On 01/03/13 21:51, Prashant Gaikwad wrote:
>>> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
>>> index f0b269a..baf7608 100644
>>> --- a/drivers/clk/Makefile
>>> +++ b/drivers/clk/Makefile
>>> @@ -2,7 +2,8 @@
>>>   obj-$(CONFIG_HAVE_CLK)        += clk-devres.o
>>>   obj-$(CONFIG_CLKDEV_LOOKUP)    += clkdev.o
>>>   obj-$(CONFIG_COMMON_CLK)    += clk.o clk-fixed-rate.o clk-gate.o \
>>> -                   clk-mux.o clk-divider.o clk-fixed-factor.o
>>> +                   clk-mux.o clk-divider.o clk-fixed-factor.o \
>>> +                   clk-composite.o
>> This list is getting a little out of hand. Should we sort it
>> alphabetically and put each file on one line?
>
> Do you want me to do it in this patch?
>
>

No.

>>> +static u8 clk_composite_get_parent(struct clk_hw *hw)
>>> +{
>>> +    struct clk_composite *composite = to_clk_composite(hw);
>>> +    const struct clk_ops *mux_ops = composite->mux_ops;
>>> +    struct clk_hw *mux_hw = composite->mux_hw;
>>> +
>>> +    mux_hw->clk = hw->clk;
>> Looks like this is already done down in the register function. Why are
>> we doing it again here and in each op?
>
> Some ops gets called during clk_init which is before clk_register
> returns.
>
>

Hmm. Ok.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

