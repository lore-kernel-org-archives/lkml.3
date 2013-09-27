Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3I0Bcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 21:32:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:43603 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab3I0Bcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 21:32:41 -0400
Message-ID: <1380245438.28561.86.camel@pasglop>
Subject: Re: [dtc PATCH V2] Warn on node name unit-address presence/absence
 mismatch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Kumar Gala <galak@codeaurora.org>, Jon Loeliger <jdl@jdl.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Olof Johansson <olof@lixom.net>, frowand.list@gmail.com,
        Tomasz Figa <tomasz.figa@gmail.com>, devicetree@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>
Date: Fri, 27 Sep 2013 11:30:38 +1000
In-Reply-To: <5244BF7A.4000100@wwwdotorg.org>
References: <1379613263-32080-1-git-send-email-swarren@wwwdotorg.org>
	 <3D2FE31C-A6BB-4F70-9B3B-C55012CB56B3@codeaurora.org>
	 <5244BF7A.4000100@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-26 at 17:12 -0600, Stephen Warren wrote:
> Well, ePAPR seems pretty specific that unit address and reg are
> related,
> but says nothing about ranges in the section on node naming, nor about
> node naming in the section about ranges.
> 
> I'd claim that the existing PPC trees are nonconforming, and should be
> fixed too:-)

This is tricky, we should probably fix ePAPR here.

If you have a "soc" bus covering a given range of addresses which it
forwards to its children devices but doesn't have per-se its own
registers in that area, then it wouldn't have a "reg" property. I would
thus argue that in the absence of a "reg" property, if a "ranges" one is
present, the "parent address" entry in there is an acceptable substitute
for the "reg" property as far as unit addresses are concerned.

Also don't forget that in real OFW land, the unit address is something
that's somewhat bus specific ... for example, PCI uses "dev,fn" rather
than the full 96-bit number of the "reg" entry :-)

Another option which would more strictly conform to ePAPR and in fact to
of1275 would be to require such bus nodes to have a "reg" property with
the address value set to the beginning of the range and the size value
set to 0 :-)

Cheers,
Ben


