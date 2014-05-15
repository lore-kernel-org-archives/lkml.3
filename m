Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaEOJRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:17:42 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:52013 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaEOJRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:17:40 -0400
Message-ID: <5374862F.2020205@gmail.com>
Date: Thu, 15 May 2014 11:17:35 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: Kishon Vijay Abraham I <kishon@ti.com>, Arnd Bergmann <arnd@arndb.de>
CC: =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com, tj@kernel.org
Subject: Re: [PATCH v3 1/6] phy: add a driver for the Berlin SATA PHY
References: <1400060942-10588-1-git-send-email-antoine.tenart@free-electrons.com> <20140514165722.GA18495@kwain> <5373AE9A.3050008@gmail.com> <5764751.ffUj9rhnMd@wuerfel> <5373B908.5090904@gmail.com> <537462A2.5020607@ti.com> <5374668F.4060109@gmail.com> <53747F03.5030206@ti.com>
In-Reply-To: <53747F03.5030206@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 10:46 AM, Kishon Vijay Abraham I wrote:
> On Thursday 15 May 2014 12:32 PM, Sebastian Hesselbarth wrote:
>> On 05/15/2014 08:45 AM, Kishon Vijay Abraham I wrote:
>>> On Thursday 15 May 2014 12:12 AM, Sebastian Hesselbarth wrote:
>>>> On 05/14/2014 08:12 PM, Arnd Bergmann wrote:
>>>>> On Wednesday 14 May 2014 19:57:46 Sebastian Hesselbarth wrote:
>>>>>> Let's assume we have one dual-port SATA controller and one PCIe
>>>>>> controller with either x1 or x2 support. The only sane DT binding,
>>>>>> I can think of then would be:
>>>>>>
>>>>>> berlin2q.dtsi:
>>>>>>
>>>>>> genphy: lvds@ea00ff {
>>>>>> 	compatible = "marvell,berlin-lvds-phy";
>>>>>> 	reg = <0xea00ff 0x100>;
>>>>>> 	#phy-cells = <2>;
>>>>>> };
[...]
>>
>> Depends on what you call PHY. In the example above the PHY is what
>> allows you to control both lanes.
>>
>> So you want sub-nodes for each individual lane given the nomenclature
>> of the example?
>>
>> Or like it is used in the example above, a single PHY node with an index
>> in the phy-specifier to pick an individual lane.
>>
>> IMHO, having both phy-specifier index _and_ PHY sub-node per lane
>> has no benefit at all. You cannot even use the PHY sub-nodes for any
>> setup properties, as they depend on the consumer claiming the lane.
>
> IMO the dt data should completely describe the HW. So just by looking at the
> PHY node, we won't be able to tell the no of PHYs implemented in the IP if we
> have a single PHY node (In this case the lanes in the IP).
>
> However if you think it's an overkill for having sub-nodes for each lane then
> single PHY node is fine too.

Yeah, I see your point. I just wonder how many Marvell PHYs we may hit
that require the _same_ magic setup inside but have _different_ number
of lanes. And even if, we can deal with it using a different compatible
string.

Currently, I feel a single PHY provider node and a set of compatibles
will be most likely, i.e. no per-lane sub-nodes. OTOH, the per-lane
sub-nodes is more generic as it allows us to deal PHYs that may
suddenly skip one lane in the numbering scheme. The difference for the
driver is marginal, i.e. some SoC-specific struct with a field for the
number of lanes vs. of_count_child_nodes() and a reg = <n> property for
the per-lane sub-nodes.

I used to agree to "DT should descibe HW", but with no datasheet
available, it quickly becomes fuzzy what it really looks like.

Anyway, I'll have some discussion with Antoine and Alexandre to sort out
the differences and the things in common for the PHY and SoCs in
question.

Sebastian
