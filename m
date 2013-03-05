Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047Ab3CETMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:12:43 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11351 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab3CETMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:12:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 05 Mar 2013 11:06:44 -0800
Message-ID: <513643A6.4020109@nvidia.com>
Date: Tue, 5 Mar 2013 14:12:38 -0500
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>, Anton Vorontsov <cbou@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] power_supply: tps65090-charger: Add binding doc
References: <1362423709-29596-1-git-send-email-rklein@nvidia.com> <1362423709-29596-4-git-send-email-rklein@nvidia.com> <5136364B.7000506@wwwdotorg.org>
In-Reply-To: <5136364B.7000506@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/5/2013 1:15 PM, Stephen Warren wrote:
> On 03/04/2013 12:01 PM, Rhyland Klein wrote:
>> This change adds the binding documentation for the tps65090-charger.
>> diff --git a/Documentation/devicetree/bindings/power_supply/tps65090.txt b/Documentation/devicetree/bindings/power_supply/tps65090.txt
> ...
>> +Example:
>> +
>> +	tps65090@48 {
> ...
>> +		regulators {
>> +			...
>> +		};
>>
> The "regulators" node in the example isn't mentioned in the list of
> properties/nodes that's above. What goes in there? You probably want to
> include text similar to what I've quoted below from
> Documentation/devicetree/bindings/regulator/tps6586x.txt:
>
>> - regulators: A node that houses a sub-node for each regulator within the
>>    device. Each sub-node is identified using the node's name (or the deprecated
>>    regulator-compatible property if present), with valid values listed below.
>>    The content of each sub-node is defined by the standard binding for
>>    regulators; see regulator.txt.
>>    sys, sm[0-2], ldo[0-9] and ldo_rtc
The reason I didn't bother documenting the regulators node was that 
since this is a child device
driver of an mfd device, there is already a child driver for the 
regulators with its own documentation

https://patchwork.kernel.org/patch/2051381/

I wasn't sure how I should handle this, as splitting the bindings to 
make logic sense in the binding
layout (charger under power_supply, and  regulators under regulator) or 
combine them somehow
into a single documentation entry common to the device. The latter seems 
to make more sense to me,
but since there aren't any dt specific entries for the core mfd part 
currently, it doesn't have its own
documentation, and sticking the charger info under the regulators seemed 
backwards to me.

I thought doing it this way would be a good way of starting a discussion 
around how to handle this.

thanks for starting it Stephen :)

-rhyland

-- 
nvpublic

