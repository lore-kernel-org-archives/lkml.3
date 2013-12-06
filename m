Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab3LFGap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 01:30:45 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8275 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab3LFGal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 01:30:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 05 Dec 2013 22:23:57 -0800
Message-ID: <52A16E65.70908@nvidia.com>
Date: Fri, 6 Dec 2013 11:57:49 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ashwini Ghuge <aghuge@nvidia.com>
Subject: Re: [PATCH 4/4] pinctrl: tegra: add pinmux controller driver for
 Tegra124
References: <1386241070-4350-1-git-send-email-ldewangan@nvidia.com> <1386241070-4350-5-git-send-email-ldewangan@nvidia.com> <52A10C7B.8070406@wwwdotorg.org>
In-Reply-To: <52A10C7B.8070406@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 December 2013 05:00 AM, Stephen Warren wrote:
> On 12/05/2013 03:57 AM, Laxman Dewangan wrote:
>> From: Ashwini Ghuge <aghuge@nvidia.com>
>>
>> This adds a driver for the Tegra124 pinmux, and required
>> parameterization data for Tegra124.
>>
>> The driver uses the common Tegra pincontrol driver utility
>> functions to implement the majority of the driver.
>>
>> This driver is not compatible with the earlier NVIDIA's SoCs,
>> hence add new compatibile as "nvidia,tegra124-pinmux".
>>
>> Originally written by Ashwini Gguhe.
>> ldewangan:
>>          - cleanup the patches,
>>          - Fix address issue.
> IIRC, Thierry mentioned he had some fixes in his local branch for this
> driver. Thierry, can you please confirm/deny this?
>
> I made the following comment on the version Ashwini posted, which hasn't
> been addressed yet:
>
> A day or two ago during upstream review:

Yes, we have some missing entry and I responded into other mail thread. 
I will post the diff here to complete.


>>> +static const struct tegra_function  tegra124_functions[] = {
>> ...
>>> +	FUNCTION(i2c1),
>>> +	FUNCTION(i2c2),
>>> +	FUNCTION(i2c3),
>>> +	FUNCTION(i2c4),
>>> +	FUNCTION(i2cpwr),
>> Is that complete? Tegra124 apparently has 6 I2C controllers. Are the
>> pins for the new sixth controller (0x7000d100) not affected by the pinmux?
> That said, if we find things are missing, I suppose we can add them
> later without breaking existing ABI. Breakage would only happen if we
> had to change/remove something.
>
> During downstream review quite a while ago I also said:

I2C6 pinmux is not in this controller, it is dpaux controller and we 
have not supported this. This require little bit different handling. I 
have already downstream bug for support this. Will add you in loop so 
that single fix can work for mainline and downstream.

Other than I2C6, some other mux are missing.


>>>> +static const struct pinctrl_pin_desc  tegra124_pins[] = {
>>> There are two spaces before "tegra124_pins[]".
>>>
>>>> +static const char * const gmi_groups[] = {
>>>> +	"uart2_cts_n_pj5",
>>>> +	"uart2_rts_n_pj6",
>>>> +	"uart3_txd_pw6",
>>>> +	"uart3_rxd_pw7",
>>>> +	"uart3_cts_n_pa1",
>>>> +	"uart3_rts_n_pc0",
>>>> +
>>>> +	"pu0",
>>> It'd be best not to have blank lines in the middle of arrays. The same comment exists elsewhere in the
>>> file, so make sure you search the whole file.
> Nits:
>
> - There are some cases of multiple blank lines back-to-back.
> - There's a blank line at the end of the file.
>
> Aside from those minor issues, patches 1/4 and 4/4,
> Acked-by: Stephen Warren <swarren@nvidia.com>
>
> (BTW, those 2 patches would go through the pinctrl tree, and patches 2/4
> and 3/4 would go through the Tegra tree. You generally shouldn't posted
> patches that will be applied to different trees in the same series,
> since there aren't dependencies).
Fine.
Should I sent the diff or full change? I think full change as this need 
to go on pincontrol subsystem, not in Tegra.

Thanks,
Laxman


