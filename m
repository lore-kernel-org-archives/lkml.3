Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab3LMGgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 01:36:03 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7198 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab3LMGgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 01:36:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Dec 2013 22:38:36 -0800
Message-ID: <52AAAA0B.7010307@nvidia.com>
Date: Fri, 13 Dec 2013 12:02:43 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Kerwin Wan <kerwinw@nvidia.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 1/2] of: add support for reading s32 property value
References: <1386854693-10871-1-git-send-email-ldewangan@nvidia.com> <52A9FA00.7080506@wwwdotorg.org>
In-Reply-To: <52A9FA00.7080506@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 December 2013 11:31 PM, Stephen Warren wrote:
> On 12/12/2013 06:24 AM, Laxman Dewangan wrote:
>> Add of_property_read_s32() to read the signed 32bit number
>> from dt property value. This supports to pass the -ve numbers
>> from dt. Use 2's complement method for represnting negative number
>> and passed as u32 from dts. When reading back the value, again
>> converted to 2's complement if msb shows as 1.
>> diff --git a/include/linux/of.h b/include/linux/of.h
>> +static inline int of_property_read_s32(const struct device_node *np,
>> +				       const char *propname,
>> +				       s32 *out_value)
>> +{
>> +	u32 val;
>> +	int ret;
>> +
>> +	ret = of_property_read_u32(np, propname, &val);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* 2's complement if MSB is 1 */
>> +	*out_value = (val & 0x80000000U) ? -((val ^ 0xFFFFFFFFU) + 1) : val;
> I may not be thinking straight today since I have a cold, but doesn't
> patch 2/2 encode negative values as 2's complement, and an s32 variable
> in the kernel is also encoded as 2's complement, so all you need here is
> a cast:
>
> 	*out_value = (s32)val;
>
> ... since the cast doesn't change the binary representation?

This is correct if all architecture follows the 2's complement for -Ve 
number representation.
If this is true then the patch will become more easy.
