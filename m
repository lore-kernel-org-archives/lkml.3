Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbaJXP73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:59:29 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18310 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbaJXP71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:59:27 -0400
Date: Fri, 24 Oct 2014 08:59:38 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Jeffrey Hugo <jhugo@codeaurora.org>
CC: Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 3/7] mfd: devicetree: bindings: Add Qualcomm SMD based RPM
 DT binding
Message-ID: <20141024155937.GG28611@sonymobile.com>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1412037291-16880-4-git-send-email-bjorn.andersson@sonymobile.com>
 <85C5C172-D309-41B4-B511-7820BAFDA017@codeaurora.org>
 <20140930143740.GK28481@sonymobile.com>
 <542B39BD.3030208@codeaurora.org>
 <20141001000846.GZ28481@sonymobile.com>
 <5435B0DA.1000707@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5435B0DA.1000707@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 08 Oct 14:47 PDT 2014, Jeffrey Hugo wrote:

> On 9/30/2014 6:08 PM, Bjorn Andersson wrote:
> > On Tue 30 Sep 16:16 PDT 2014, Jeffrey Hugo wrote:
> >
> >> On 9/30/2014 8:37 AM, Bjorn Andersson wrote:
[..]
> >
> > That's right, because you have these tables in devicetree in the caf version.
> > You have to have this information somewhere!
> 
> True, it must exist somewhere.  However since its information tied 
> directly to the hardware, it seems like its information that would fit 
> right in DT.
> 

For family B it would be reasonable to move this to device tree, replacing my
"reg" property with a "resource" property taking type and id for the resource
(e.g resource = <0x616f646c 17>; for ldo 17).

For family A this does not work thought, but maybe we should just skip the idea
of having a common look in favour of not having the tables.

> I talked to my contact, and it seems like the table attributes vary more 
> than I thought, target to target, so the single table design seems less 
> plausible.  Its my understanding you've had an offline discussion with 
> him and some of our regulator guys to discuss the specifics of our 
> needs.  I'll let them take over as the experts.
> 

Yes, I met with Stephen, David and Mahesh to discuss the matter. The issues
that we discussed was:

1) It must be possible to set the active and sleep state of a resource
independently.

2) Deferring less important writes (e.g. writes to sleep state) to reduce
communication

3) With deferred writes, we need to flush the data when going to sleep and that
requires some special handling - so that we don't wake up again or crash the
rpm.

4) The scalability of the table


I'm working on figuring out how to do 1) in a sane way, as this is needed.

2) gives 3) which gives a bunch of implementation awkwardness and I'm still not
convinced that it is a problem beyond someones KPI, so I will have to do some
measurements. If nothing else it's "just" an optimization that we should be
able to add incrementally later.

I guess 4) is a matter of taste, with the table the client reference a
resource, with all the data in DT it also describes part of how the rpm works.

Regards,
Bjorn
