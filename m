Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab3HGKxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:53:14 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:42762 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab3HGKxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:53:12 -0400
X-IronPort-AV: E=Sophos;i="4.89,832,1367971200"; 
   d="scan'208";a="7555910"
Message-ID: <1375872790.619.43.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: Refactor device tree maintainership
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Rob Herring <robherring2@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, Pawel Moll <pawel.moll@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Date: Wed, 7 Aug 2013 11:53:10 +0100
In-Reply-To: <51EECF1A.40404@gmail.com>
References: <1374290388-19308-1-git-send-email-grant.likely@linaro.org>
	   <1374290388-19308-3-git-send-email-grant.likely@linaro.org>
	   <1374511851.3609.10.camel@hornet> <51ED9018.1020003@gmail.com>
	  <1374599667.25700.92.camel@hornet> <51EEC49A.4080909@wwwdotorg.org>
	 <1374602957.6623.142.camel@hastur.hellion.org.uk>
	 <51EECF1A.40404@gmail.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
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
> bunch of manual transformations. So I think either restructuring in the
> kernel or when we move them out of the kernel makes more sense. We know
> the problem is coming, but it is not yet a major, pressing issue.

So in the end I rebuilt with the existing transformation plus rewirting
Documentation/devicetree/bindings/ onto Bindings. I've pushed the new
branches to
        
        http://xenbits.xen.org/gitweb/?p=people/ianc/device-tree-rebasing.git
        git://xenbits.xen.org/people/ianc/device-tree-rebasing.git

In keeping with the name this means that the master and upstream/dts
branches have been rebased and so updates will be non-fastforwarding (as
has the internal filter-state branch). As you would expect the tags have
all changed as well.

> OTOH, you could see how far you get by putting dts files in directories
> by their board level compatible string vendor and put any include files
> where ever they are included from. Of course, that is just my proposed
> layout. I haven't heard any opinions on that layout.

These sorts of more complicated transformation aren't really feasible to
implement in the current automatic conversion process. It tries to
retain full history for the affected files (so git annotate/log/etc are
useful) which is OK for rewriting based solely on the path but once you
have to inspect the actual contents it gets more complicated and
significantly slower (since git rewrite-branch has to checkout every
tree, even without this it takes 2 days or so to convert).

These conversions would be better off done either as a second, probably
also automated, shuffling after (perhaps immediately after) we cut over
to using device-tree.git as the primary home.

If we end up doing some restructuring while these files are still in the
kernel I think I can still cope with that.

Ian.


