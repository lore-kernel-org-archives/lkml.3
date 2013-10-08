Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab3JHMuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:50:22 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:16571 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3JHMuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:50:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 08 Oct 2013 05:46:08 -0700
Message-ID: <52540559.6030406@nvidia.com>
Date: Tue, 8 Oct 2013 18:45:05 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: "broonie@linaro.org" <broonie@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2] clk: palmas: add clock driver for palmas
References: <1381154751-4565-1-git-send-email-ldewangan@nvidia.com> <20131008010237.7445.32387@quantum>
In-Reply-To: <20131008010237.7445.32387@quantum>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 October 2013 06:32 AM, Mike Turquette wrote:
> Quoting Laxman Dewangan (2013-10-07 07:05:51)
>> +               if (!ret) {
>> +                       switch (prop) {
>> +                       case 1:
>> +                               prop = PALMAS_EXT_CONTROL_ENABLE1;
>> +                               break;
>> +                       case 2:
>> +                               prop = PALMAS_EXT_CONTROL_ENABLE2;
>> +                               break;
>> +                       case 3:
>> +                               prop = PALMAS_EXT_CONTROL_NSLEEP;
>> +                               break;
> Can magic numbers be replaced with defines?
Fine, will do in V3.

>
>
> +
> +       ret = palmas_update_bits(palmas_clks->palmas, PALMAS_RESOURCE_BASE,
> +                       cinfo->clk_desc->control_reg,
> +                       cinfo->clk_desc->sleep_mask, 0);
> What does this call to palmas_update_bits do?

This APIs update the selected bits based on mask. This is wrapper over 
the regmap_update_bits() to provide the interface at the Palmas register 
access.
The palmas registers are paged on different i2c address and offset. The 
i2c address and offset is decided based on base_address and offset.
This APIs does all calculation to get the correct i2c slave address and 
offset address based on argument.

>> +static int palmas_clks_remove(struct platform_device *pdev)
>> +{
>> +       of_clk_del_provider(pdev->dev.of_node);
> I'll be taking Sylwester's clock deregistration series after he
> publishes the next version, so if you want to call clk_unregister here
> (based on the new call) you could.
>
> If you want to add that in a later patch it is OK.

Thanks for pointing me this changes. I like to add this on my follow on 
(later) patch, not on this. -- 1.7.1.1

