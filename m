Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab3I0QMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:12:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53890 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab3I0QMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:12:17 -0400
Message-ID: <5245AE5B.3010706@wwwdotorg.org>
Date: Fri, 27 Sep 2013 10:12:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jon Loeliger <jdl@jdl.com>, David Gibson <david@gibson.dropbear.id.au>,
        Olof Johansson <olof@lixom.net>, frowand.list@gmail.com,
        Tomasz Figa <tomasz.figa@gmail.com>, devicetree@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>
Subject: Re: [dtc PATCH V2] Warn on node name unit-address presence/absence
 mismatch
References: <1379613263-32080-1-git-send-email-swarren@wwwdotorg.org> <3D2FE31C-A6BB-4F70-9B3B-C55012CB56B3@codeaurora.org> <5244BF7A.4000100@wwwdotorg.org> <1380245438.28561.86.camel@pasglop> <23CCE8D1-AEB2-42C8-B8C6-0B782117C4C2@codeaurora.org>
In-Reply-To: <23CCE8D1-AEB2-42C8-B8C6-0B782117C4C2@codeaurora.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 09:39 AM, Kumar Gala wrote:
> 
> On Sep 26, 2013, at 8:30 PM, Benjamin Herrenschmidt wrote:
> 
>> On Thu, 2013-09-26 at 17:12 -0600, Stephen Warren wrote:
>>> Well, ePAPR seems pretty specific that unit address and reg are
>>> related,
>>> but says nothing about ranges in the section on node naming, nor about
>>> node naming in the section about ranges.
>>>
>>> I'd claim that the existing PPC trees are nonconforming, and should be
>>> fixed too:-)
>>
>> This is tricky, we should probably fix ePAPR here.
> 
> I'll poke Stuart to see what's going w/updating ePAPR.
> 
>> If you have a "soc" bus covering a given range of addresses which it
>> forwards to its children devices but doesn't have per-se its own
>> registers in that area, then it wouldn't have a "reg" property. I would
>> thus argue that in the absence of a "reg" property, if a "ranges" one is
>> present, the "parent address" entry in there is an acceptable substitute
>> for the "reg" property as far as unit addresses are concerned.
> 
> Either we update the section in general about 'ranges' or at least update the simple-bus binding to state that rules about the node name.

I think you'd need to update section 2.2.1.1 which specifies the node
name rather than any other section.

The wording in 2.2.1.1 certainly states that buses can impose specific
rules on the value/format of the unit address in the node name, but I'm
not convinced it allows buses to override the rules that control the
presence/absence of the unit address.

In other words, I would simply replace:

The unit-address must match the first address specified in the reg
property of the node

with:

The unit-address must match the first address specified in the reg
property of the node. If the node has no reg property, the unit-address
must match the first address specified in the ranges property of the node.

and:

If the node has no reg property,

with:

If the node has no reg property or ranges property,
