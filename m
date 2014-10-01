Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214AbaJAAIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 20:08:40 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:8793 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbaJAAIi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 20:08:38 -0400
Date: Tue, 30 Sep 2014 17:08:47 -0700
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
Message-ID: <20141001000846.GZ28481@sonymobile.com>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1412037291-16880-4-git-send-email-bjorn.andersson@sonymobile.com>
 <85C5C172-D309-41B4-B511-7820BAFDA017@codeaurora.org>
 <20140930143740.GK28481@sonymobile.com>
 <542B39BD.3030208@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <542B39BD.3030208@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 30 Sep 16:16 PDT 2014, Jeffrey Hugo wrote:

> On 9/30/2014 8:37 AM, Bjorn Andersson wrote:
> > On Tue 30 Sep 06:46 PDT 2014, Kumar Gala wrote:
> >
> >>
> >> On Sep 29, 2014, at 7:34 PM, Bjorn Andersson <Bjorn.Andersson@sonymobile.com> wrote:
> >>
> >>> diff --git a/Documentation/devicetree/bindings/mfd/qcom-rpm-smd.txt b/Documentation/devicetree/bindings/mfd/qcom-rpm-smd.txt
> >>> new file mode 100644
> >>> index 0000000..a846101
> >>> --- /dev/null
> >>> +++ b/Documentation/devicetree/bindings/mfd/qcom-rpm-smd.txt
> >>> @@ -0,0 +1,122 @@
> >>> +Qualcomm Resource Power Manager (RPM) over SMD
> >>> +
> >>> +This driver is used to interface with the Resource Power Manager (RPM) found in
> >>> +various Qualcomm platforms. The RPM allows each component in the system to vote
> >>> +for state of the system resources, such as clocks, regulators and bus
> >>> +frequencies.
> >>> +
> >>> +- compatible:
> >>> +	Usage: required
> >>> +	Value type: <string>
> >>> +	Definition: must be one of:
> >>> +		    "qcom,rpm-msm8974”
> >>
> >> Why not “qcom,rpm-smd”.  I’d like to get Jeff H’s input on how
> >> what we do here for compat and distinguish the A-family RPM support vs
> >> B-family/RPM-SMD support.
> >>
> >
> > I don't see anything indicating changes in the actual communication, but as
> > this also encodes what resources are exposed we have to keep this specific.
> >
> > I'm not sure what you mean with distinguish the A and B family, they are
> > completely different and there are no overlap in compatibles or implementation.
> >
> > The overlap is in how children are communicating with the rpm, but this is an
> > implementation detail - and noted in that patch as a future improvement.
> >
> >
> > I forgot to add Jeff, but did send him a separate email asking for his input on
> > all this.
> >
> 
> Yep.  I saw the series.  Still doing a deep dive.
> 
> The rpm-smd driver (and the A family equivalent) is outside of my area 
> of expertise, but I have some familiarity with it as it is a SMD client. 
>   Internally we have a singular compat for all of B family, but I 
> haven't been able to figure out how that works to expose all of the 
> resources.  I'll talk to my contact later in the week to see what the 
> differences are.
> 

That's right, because you have these tables in devicetree in the caf version.
You have to have this information somewhere!

> Is the per target compat the way to do this though?  The way its 
> currently done means we'll have atleast a dozen tables in 
> qcom-smd-rpm.c, and I can't imagine they will have anything more than 
> minor differences from the msm8x74_resource_table that currently exists 
> in patch 6 of the series.  Why wouldn't one table that is a superset of 
> all supported targets work?
> 

It would work as long as e.g. QCOM_RPM_PM8941_MVS1 always is vsa number 4.

But sure, it's a much better fit than the family a and this rpm would reject
invalid resources, so it might work. But this works without us knowing about
all possible platforms.


But if the case is that multiple platforms expose the same table we can always
tie the same table to multiple compatibles.

Regards,
Bjorn
