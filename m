Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaELErJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 00:47:09 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46723 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaELErH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 00:47:07 -0400
Message-ID: <53705243.1030704@linaro.org>
Date: Mon, 12 May 2014 10:16:59 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        t.figa@samsung.com, kgene.kim@samsung.com, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org
Subject: Re: [PATCH 1/4] clk: samsung: out: Add infrastructure to register
 CLKOUT
References: <1399640410-30957-1-git-send-email-tushar.behera@linaro.org> <1399640410-30957-2-git-send-email-tushar.behera@linaro.org> <536DA243.6000600@samsung.com>
In-Reply-To: <536DA243.6000600@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2014 09:21 AM, Pankaj Dubey wrote:
> On 05/09/2014 10:00 PM, Tushar Behera wrote:
>> All SoC in Exynos-series have a clock with name XCLKOUT to provide
>> debug information about various clocks available in the SoC. The register
>> controlling the MUX and GATE of this clock is provided within PMU domain.
>> Since PMU domain can't be dedicatedly mapped by every driver, the
>> register
>> needs to be handled through a regmap handle provided by PMU syscon
>> controller. Right now, CCF doesn't allow regmap based MUX and GATE
>> clocks,
>> hence a dedicated clock provider for XCLKOUT is added here.
>>
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> CC: Tomasz Figa <t.figa@samsung.com>
>> ---
>>   drivers/clk/samsung/Makefile  |    2 +-
>>   drivers/clk/samsung/clk-out.c |  181
>> +++++++++++++++++++++++++++++++++++++++++
>>   drivers/clk/samsung/clk.h     |   33 ++++++++
>>   3 files changed, 215 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/clk/samsung/clk-out.c
>>

[ ... ]

>> +/**
>> + * struct samsung_clkout_soc_data: SoC specific register details
>> + * @reg: Offset of CLKOUT register from PMU base
> 
> how about naming this variable as "offset" instead of "reg".
> 

Okay, I will change that.

[ ... ]

>> +u8 samsung_clkout_get_parent(struct clk_hw *hw)
>> +{
>> +    struct samsung_clkout *clkout = to_clk_out(hw);
>> +    const struct samsung_clkout_soc_data *soc_data = clkout->soc_data;
>> +    unsigned int parent_mask = BIT(soc_data->mux_width) - 1;
>> +    unsigned int val;
>> +    int ret;
>> +
>> +    ret = regmap_read(clkout->regmap, soc_data->reg, &val);
> 
> Do we really need to keep return value in "ret" as I can't see you are
> using it anywhere?
> 

Right, we are not using that and can be removed.

>> +
>> +    return (val >> soc_data->mux_shift) & parent_mask;
>> +}
>> +

[ ... ]

>> +/* All existing Exynos serial of SoCs have common values for this
>> offsets. */
> typo: serial/series/

Sure. Thanks for your review.

-- 
Tushar Behera
