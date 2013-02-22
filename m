Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab3BVWFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 17:05:22 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6949 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505Ab3BVWFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 17:05:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 22 Feb 2013 14:04:30 -0800
Message-ID: <5127EB96.3000206@nvidia.com>
Date: Fri, 22 Feb 2013 17:05:10 -0500
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC v2 1/3] power_supply: Define Binding for supplied-nodes
References: <1361488272-21010-1-git-send-email-rklein@nvidia.com> <1361488272-21010-2-git-send-email-rklein@nvidia.com> <5127CAF9.1030506@wwwdotorg.org>
In-Reply-To: <5127CAF9.1030506@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/2013 2:46 PM, Stephen Warren wrote:
> On 02/21/2013 04:11 PM, Rhyland Klein wrote:
>> This property is meant to be used in device nodes which represent
>> power_supply devices that wish to provide a list of supplies to
>> which they provide power. A common case is a AC Charger with
>> the batteries it powers.
>> diff --git a/Documentation/devicetree/bindings/power_supply/power_supply.txt b/Documentation/devicetree/bindings/power_supply/power_supply.txt
>> +Optional Properties:
>> + - power-supply : This property is added to a supply in order to list the
>> +   devices which supply it power, referenced by their phandles.
> DT properties that reference resources are usually named in the plural,
> so "power-supplies" would be more appropriate here.
>
> It seems plausible that a single DT node could represent/instantiate
> multiple separate supply objects. I think we want to employ the standard
> pattern of <phandle args*> rather than just <phandle>.
>
> That way, each supply that can supply others would have something like a
> #supply-cells = <n>, where n is the number of cells that the supply uses
> to name the multiple supplies provided by that node. 0 would be a common
> value here. 1 might be used for a node that represents many supplies.
>
> When a client supply uses a providing supply as the supply(!), do you
> need any flags to parameterize the connection? If so, that might be
> cause for a supplier to have a larger #supply-cells, so the flags could
> be represented.
>
> That all said, regulators assume 1 node == 1 regulator, so an
> alternative would be for a multi-supply node to include a child node per
> supply, e.g.:
>
> power@xxx {
>      ...
>      supply1 {
>          ...
>      };
>      supply2 {
>          ...
>      };
> };
>
> client {
>      supplies = <&supply1> <&supply2>;
> };
>
> I don't recall why regulators went for the style above rather than the
> #supply-cells style. Cc Mark Brown for any comment here.
>
> Also, do supplies and regulators need to inter-operate in any way (e.g.
> reference each-other in DT)?
>
>> +Example:
>> +
>> +	usb-charger: power@e {
>> +		compatible = "some,usb-charger";
>> +		...
>> +	};
>> +
>> +	ac-charger: power@e {
>> +		compatible = "some,ac-charger";
>> +		...
>> +	};
>> +
>> +	battery@b {
>> +		compatible = "some,battery";
>> +		...
>> +		power-supply = <&usb-charger>, <&ac-charger>;
>> +	};

The "connection" between supplier and supplies isn't really a hard 
connection.
Essentially, the core code uses the names/nodes in the list and iterates 
over
all the power_supplies that are registered and does matching.

I don't have any experience working with a single node that would spawn 
multiple
supplies, though the situation I am sure is possible. I am interested to 
see what
the consensus is around this design for multiple supplies, as I don't have a
preference either way.

-rhyland

-- 
nvpublic

