Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab3I0PjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:39:10 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48245 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab3I0PjH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:39:07 -0400
Subject: Re: [dtc PATCH V2] Warn on node name unit-address presence/absence mismatch
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1380245438.28561.86.camel@pasglop>
Date: Fri, 27 Sep 2013 10:39:08 -0500
Cc: Stephen Warren <swarren@wwwdotorg.org>, Jon Loeliger <jdl@jdl.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Olof Johansson <olof@lixom.net>, frowand.list@gmail.com,
        Tomasz Figa <tomasz.figa@gmail.com>, devicetree@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <23CCE8D1-AEB2-42C8-B8C6-0B782117C4C2@codeaurora.org>
References: <1379613263-32080-1-git-send-email-swarren@wwwdotorg.org> <3D2FE31C-A6BB-4F70-9B3B-C55012CB56B3@codeaurora.org> <5244BF7A.4000100@wwwdotorg.org> <1380245438.28561.86.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 26, 2013, at 8:30 PM, Benjamin Herrenschmidt wrote:

> On Thu, 2013-09-26 at 17:12 -0600, Stephen Warren wrote:
>> Well, ePAPR seems pretty specific that unit address and reg are
>> related,
>> but says nothing about ranges in the section on node naming, nor about
>> node naming in the section about ranges.
>> 
>> I'd claim that the existing PPC trees are nonconforming, and should be
>> fixed too:-)
> 
> This is tricky, we should probably fix ePAPR here.

I'll poke Stuart to see what's going w/updating ePAPR.

> If you have a "soc" bus covering a given range of addresses which it
> forwards to its children devices but doesn't have per-se its own
> registers in that area, then it wouldn't have a "reg" property. I would
> thus argue that in the absence of a "reg" property, if a "ranges" one is
> present, the "parent address" entry in there is an acceptable substitute
> for the "reg" property as far as unit addresses are concerned.

Either we update the section in general about 'ranges' or at least update the simple-bus binding to state that rules about the node name.

> Also don't forget that in real OFW land, the unit address is something
> that's somewhat bus specific ... for example, PCI uses "dev,fn" rather
> than the full 96-bit number of the "reg" entry :-)
> 
> Another option which would more strictly conform to ePAPR and in fact to
> of1275 would be to require such bus nodes to have a "reg" property with
> the address value set to the beginning of the range and the size value
> set to 0 :-)

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

