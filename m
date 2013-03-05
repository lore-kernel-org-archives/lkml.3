Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab3CETZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:25:35 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39204 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab3CETZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:25:33 -0500
Message-ID: <513646A9.7000502@wwwdotorg.org>
Date: Tue, 05 Mar 2013 12:25:29 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rhyland Klein <rklein@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Anton Vorontsov <cbou@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] power_supply: tps65090-charger: Add binding doc
References: <1362423709-29596-1-git-send-email-rklein@nvidia.com> <1362423709-29596-4-git-send-email-rklein@nvidia.com> <5136364B.7000506@wwwdotorg.org> <513643A6.4020109@nvidia.com>
In-Reply-To: <513643A6.4020109@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 12:12 PM, Rhyland Klein wrote:
> On 3/5/2013 1:15 PM, Stephen Warren wrote:
>> On 03/04/2013 12:01 PM, Rhyland Klein wrote:
>>> This change adds the binding documentation for the tps65090-charger.
>>> diff --git
>>> a/Documentation/devicetree/bindings/power_supply/tps65090.txt
>>> b/Documentation/devicetree/bindings/power_supply/tps65090.txt
>> ...
>>> +Example:
>>> +
>>> +    tps65090@48 {
>> ...
>>> +        regulators {
>>> +            ...
>>> +        };
>>
>> The "regulators" node in the example isn't mentioned in the list of
>> properties/nodes that's above. What goes in there? You probably want to
>> include text similar to what I've quoted below from
>> Documentation/devicetree/bindings/regulator/tps6586x.txt:
>>
>>> - regulators: A node that houses a sub-node for each regulator within the
>>>    device. Each sub-node is identified using the node's name (or the deprecated
>>>    regulator-compatible property if present), with valid values listed below.
>>>    The content of each sub-node is defined by the standard binding for
>>>    regulators; see regulator.txt.
>>>    sys, sm[0-2], ldo[0-9] and ldo_rtc
>
> The reason I didn't bother documenting the regulators node was that
> since this is a child device
> driver of an mfd device, there is already a child driver for the
> regulators with its own documentation
> 
> https://patchwork.kernel.org/patch/2051381/

Ah, I see.

> I wasn't sure how I should handle this, as splitting the bindings to
> make logic sense in the binding
> layout (charger under power_supply, and  regulators under regulator) or
> combine them somehow
> into a single documentation entry common to the device. The latter seems
> to make more sense to me,

Yes, given we're talking about properties in the same node, rather than
a binding for a new child node that could be plugged into arbitrary
parent nodes, I think everything should be documented in a single file.

> but since there aren't any dt specific entries for the core mfd part
> currently, it doesn't have its own
> documentation, and sticking the charger info under the regulators seemed
> backwards to me.

Hmmm. That's a good question. I'm not really sure where the best
location for that file would be. Admittedly regulators does seem
slightly over-specific, but short of creating a new bindings/mfd/
directory, it doesn't seem to unreasonable to just put the whole binding
in the existing file in bindings/regulators/.

Perhaps Grant or Rob can comment on what their preference would be.
