Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab3E3MzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 08:55:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46978 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab3E3MzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 08:55:11 -0400
Message-ID: <51A74C0D.6030205@ti.com>
Date: Thu, 30 May 2013 18:24:37 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <ldewangan@nvidia.com>, <sameo@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <gg@slimlogic.co.uk>,
        <ian@slimlogic.co.uk>, <balbi@ti.com>
Subject: Re: [RFC PATCH] regulator: palmas: enable all modes for SMPS10
References: <1369911393-25747-1-git-send-email-kishon@ti.com> <20130530113247.GI5180@sirena.org.uk>
In-Reply-To: <20130530113247.GI5180@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 30 May 2013 05:02 PM, Mark Brown wrote:
> On Thu, May 30, 2013 at 04:26:33PM +0530, Kishon Vijay Abraham I wrote:
>
>> Only compile tested. Just sent a patch to get some comments
>> /ideas on how to handle such one off regulators.
>> to handle
>
> What's unclear or confusing?  This all looks really basic...

For instance mapping of regulator modes to smps10 modes is unclear.
>
>> +	palmas_smps_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
>> +	reg &= ~PALMAS_SMPS10_CTRL_MODE_ACTIVE_MODE_MASK;
>> +
>> +	if (mode == REGULATOR_MODE_NORMAL)
>> +		reg |= SMPS10_BOOST_EN;
>> +
>> +	if (mode == REGULATOR_MODE_FAST)
>> +		reg |= SMPS10_SWITCH_EN;
>> +
>> +	if (mode == REGULATOR_MODE_IDLE)
>> +		reg |= SMPS10_BYPASS_EN;
>> +
>> +	palmas_smps_write(pmic->palmas, palmas_regs_info[id].ctrl_addr, reg);
>> +	return 0;
>
> This looks like a switch statement and isn't there an update bits
> operation?

There can be multiple modes set at the same time. Having switch 
statement means we would need to call the same API multiple times to set 
the mode. There isn't a palmas wrapper to regmap_update_bits. I can send 
a patch to add a palmas wrapper.

Thanks
Kishon
