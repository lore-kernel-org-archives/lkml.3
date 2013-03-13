Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091Ab3CMTZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:25:57 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8274 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933024Ab3CMTZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:25:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 13 Mar 2013 12:25:55 -0700
Message-ID: <5140D2C1.8020507@nvidia.com>
Date: Wed, 13 Mar 2013 15:25:53 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [Patch v3 3/4] power_supply: tps65090-charger: Add binding doc
References: <1363126089-9071-1-git-send-email-rklein@nvidia.com> <1363126089-9071-4-git-send-email-rklein@nvidia.com> <513FB5D7.5090800@wwwdotorg.org>
In-Reply-To: <513FB5D7.5090800@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/2013 7:10 PM, Stephen Warren wrote:
> On 03/12/2013 04:08 PM, Rhyland Klein wrote:
>> This change adds the binding documentation for the tps65090-charger.
>> diff --git a/Documentation/devicetree/bindings/power_supply/tps65090.txt b/Documentation/devicetree/bindings/power_supply/tps65090.txt
>> +Example:
>> +
>> +	tps65090@48 {
>> +		compatible = "ti,tps65090";
>> +		reg = <0x48>;
>> +		interrupts = <0 88 0x4>;
>> +
>> +		ti,enable-low-current-chrg;
>> +
>> +		regulators {
>> +			...
>> +		};
> I'm a little confused by this binding.
>
> What goes in the regulators sub-node; is that specified by another
> binding file in bindings/regulator/tps65090.txt?
>
> I would expect one of the following:
>
> 1) A single binding file that describes absolutely everything in the
> chip. In this case, the main TPS65909 node wouldn't have child nodes for
> the MFD components, although the regulators sub-node, which in turn
> contains children does still make sense.
>
> 2) A separate binding for each component block, and perhaps also some
> top-level binding that indicates which child bindings can "plug into"
> it. In this case, I'd expect each block to be represented as a sub-node
> in DT. The overall regulator component might then still have a
> regulators child DT node itself, to represent each regulator's
> configuration. In this scenario, each binding document describes the
> entirety of a single node.
>
> I think what you've got here is a hybrid; a single top-level node, but
> different binding documents defining the various properties that are
> relevant to each component block in the device. That seems odd to me.

Yes we started this discussion before and were discussing the proper 
arrangement of
documentation when dealing with devices like these. This is where the 
drivers/ directory
naming in the binding docs might diverge a bit as it might make less 
sense to have
a binding doc for each child component of an mfd.

I was thinking about moving this driver towards #1 above, and using a 
child node for
the charger. I would then also move the regulators to a child node, and 
its structure would
be very similar to the Palmas driver/dt representation. My only concern 
was that, from
what I understood, separating out the child node implied that the child 
functionality
could/might be used somewhere else. Say in this case, that the charger 
functionality might
be duplicated in another pmic from ti. I don't know how much that is the 
case with the
tps65090 and so I am unsure if child nodes are the correct way to go.

As for #2, This would also be fine with me, as logically we are talking 
about a single chip. I
this the only concern here is where to place a single binding document 
in the bindings
directory where it makes sense. Putting regulator documentation under 
charger or vice
versa doesn't make sense. And then for some devices, they might also 
have an rtc, gpio
controller, interrupt controller, etc.. If each of them had a driver and 
their own dt
information, I don't know where a single core place for all that 
documentation would be
right now.

Hence, I was hoping to continue this dicussion and see if we can decide 
on the most logical
choice, whatever that may be.

-rhyland

-- 
nvpublic

