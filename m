Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984Ab3GWS4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:56:06 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:17187 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933912Ab3GWS4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:56:03 -0400
X-IronPort-AV: E=Sophos;i="4.89,729,1367971200"; 
   d="scan'208";a="36926745"
Message-ID: <1374605732.6623.162.camel@hastur.hellion.org.uk>
Subject: Re: [PATCH 3/3] MAINTAINERS: Refactor device tree maintainership
From: Ian Campbell <ian.campbell@citrix.com>
To: Rob Herring <robherring2@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, Pawel Moll <pawel.moll@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Date: Tue, 23 Jul 2013 19:55:32 +0100
In-Reply-To: <51EECF1A.40404@gmail.com>
References: <1374290388-19308-1-git-send-email-grant.likely@linaro.org>
	   <1374290388-19308-3-git-send-email-grant.likely@linaro.org>
	   <1374511851.3609.10.camel@hornet> <51ED9018.1020003@gmail.com>
	  <1374599667.25700.92.camel@hornet> <51EEC49A.4080909@wwwdotorg.org>
	 <1374602957.6623.142.camel@hastur.hellion.org.uk>
	 <51EECF1A.40404@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 13:44 -0500, Rob Herring wrote:
> On 07/23/2013 01:09 PM, Ian Campbell wrote:
> > On Tue, 2013-07-23 at 10:59 -0700, Stephen Warren wrote:
> > 
> >> I think the solution is to introduce some new shared/common location for
> >> shared/common *.dtsi files, into the kernel tree, in the interim.
> >>
> >> When *.dts move out of the kernel, this common location can simply be
> >> consumed as part of the DT tree re-organization.
> >>
> >> Or perhaps, we could move *.dts around in the kernel to match the
> >> proposed DT tree structure before that point in time?
> > 
> > FWIW I can easily handle any transformation as part of the automated
> > extraction into the device-tree.git. If it can expressed as a sed script
> > then so much the better, e.g. the current rules are
> > http://xenbits.xen.org/gitweb/?p=people/ianc/device-tree-rebasing.git;a=blob;f=scripts/rewrite-paths.sed;h=f7a157d1b486bac058f50e42cf7bedc8630e54ff;hb=HEAD.
> > If it gets too complicated for sed I can always switch to something
> > else.
> > 
> > I'm already pending a complete rebuild of the export to add in the
> > Documentation/devicetree/bindings sub tree but since it takes an age to
> > run I was waiting for the output of this conversation before kicking
> > that off.
> 
> I'd doubt we could completely script this with a generic rule without a
> bunch of manual transformations.

Right. The advantage of scripting, even if that script is just a big
long list of manual rules, is that we can preserve the history from
linux.git in device-tree.git, so git annotate etc say something useful.

But if I'm going to write a big long list of such rules I'd like to only
do the bulk of the work once, so we need to decide on the layout first.

>  So I think either restructuring in the
> kernel or when we move them out of the kernel makes more sense. We know
> the problem is coming, but it is not yet a major, pressing issue.
> 
> OTOH, you could see how far you get by putting dts files in directories
> by their board level compatible string vendor and put any include files
> where ever they are included from. Of course, that is just my proposed
> layout. I haven't heard any opinions on that layout.

I don't really have a strong opinion on the layout myself, I'm happy to
implement whatever works for people.

The board level compatible string vendor is the top-level compatible,
right? e.g.:
        / {
                model = "Calxeda Highbank";
                compatible = "calxeda,highbank";
"calxeda,highbank" in this case. So you propose s|,|/| on that so the
file ends up in calxeda/highbank.dts?

For the included ecx-common.dtsi I think you are proposing to find all
the files which include it and then find the
deepest-common-subdirectory? In this case the other include is
ecx-2000.dts which is compatible calxeda,ecx-2000
(->calxeda/ecx2000.dts) so the common subdir is calxeda and dtsi would
become calxeda/ecs-2000.dtsi. That works, I should probably have picked
an example which didn't rely on files you are so involved with in case
there is a selection bias at work ;-)

Ian.

