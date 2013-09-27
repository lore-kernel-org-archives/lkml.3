Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3I0Peu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:34:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47787 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab3I0Per convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:34:47 -0400
Subject: Re: [dtc PATCH V2] Warn on node name unit-address presence/absence mismatch
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20130927051718.GE2716@voom.fritz.box>
Date: Fri, 27 Sep 2013 10:34:48 -0500
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Jon Loeliger <jdl@jdl.com>,
        Olof Johansson <olof@lixom.net>, frowand.list@gmail.com,
        Tomasz Figa <tomasz.figa@gmail.com>, devicetree@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <2F513172-55DB-4482-8561-872420B07737@codeaurora.org>
References: <1379613263-32080-1-git-send-email-swarren@wwwdotorg.org> <3D2FE31C-A6BB-4F70-9B3B-C55012CB56B3@codeaurora.org> <5244BF7A.4000100@wwwdotorg.org> <1380245438.28561.86.camel@pasglop> <20130927051718.GE2716@voom.fritz.box>
To: David Gibson <david@gibson.dropbear.id.au>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 27, 2013, at 12:17 AM, David Gibson wrote:

> On Fri, Sep 27, 2013 at 11:30:38AM +1000, Benjamin Herrenschmidt wrote:
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
>> 
>> If you have a "soc" bus covering a given range of addresses which it
>> forwards to its children devices but doesn't have per-se its own
>> registers in that area, then it wouldn't have a "reg" property. I would
>> thus argue that in the absence of a "reg" property, if a "ranges" one is
>> present, the "parent address" entry in there is an acceptable substitute
>> for the "reg" property as far as unit addresses are concerned.
> 
> So, that's been accepted practice in fdt world for a while; I think
> ePAPR already permits that, in fact.

Are you saying that the bus binding would cover this case or something else?

>> Also don't forget that in real OFW land, the unit address is something
>> that's somewhat bus specific ... for example, PCI uses "dev,fn" rather
>> than the full 96-bit number of the "reg" entry :-)
>> 
>> Another option which would more strictly conform to ePAPR and in fact to
>> of1275 would be to require such bus nodes to have a "reg" property with
>> the address value set to the beginning of the range and the size value
>> set to 0 :-)

Uugh, that's a bit ugly.  I wonder what breaks if we had reg w/size 0.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

