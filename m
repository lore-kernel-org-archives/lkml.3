Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbaDOT45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:56:57 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:46343
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938AbaDOT44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:56:56 -0400
Date: Tue, 15 Apr 2014 14:56:53 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: srivastava@debian.org
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vince Weaver <vincent.weaver@maine.edu>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [bisected] broken make-kpkg kernel build in 3.15-rc1
In-Reply-To: <20140415194319.GV24070@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.10.1404151456130.29234@gentwo.org>
References: <alpine.DEB.2.10.1404150940250.14106@vincent-weaver-1.um.maine.edu> <534D4A59.6080401@suse.cz> <alpine.DEB.2.10.1404151146530.26562@gentwo.org> <534D6510.3070509@suse.cz> <alpine.DEB.2.10.1404151221360.26992@gentwo.org> <20140415182653.GR24070@n2100.arm.linux.org.uk>
 <alpine.DEB.2.10.1404151507290.15528@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404151530050.15528@vincent-weaver-1.um.maine.edu> <20140415193116.GU24070@n2100.arm.linux.org.uk> <alpine.DEB.2.10.1404151539110.15528@vincent-weaver-1.um.maine.edu>
 <20140415194319.GV24070@n2100.arm.linux.org.uk>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manoj: what is the right fix here?



On Tue, 15 Apr 2014, Russell King - ARM Linux wrote:

> On Tue, Apr 15, 2014 at 03:39:47PM -0400, Vince Weaver wrote:
> > On Tue, 15 Apr 2014, Russell King - ARM Linux wrote:
> > >
> > > Hmm, any ideas what HAVE_INST_PATH is set to?  It would be good to have
> > > the complete picture on this bug. :)
> >
> > In debian/ruleset/misc/version_vars.mk
> >
> > HAVE_INST_PATH  =$(call doit,grep -E '\(INSTALL_PATH\)' Makefile 2>/dev/null )
>
> Ah, so that would match on:
>
> export INSTALL_DTBS_PATH ?= $(INSTALL_PATH)/dtbs/$(KERNELRELEASE)
>                              ^^^^^^^^^^^^^^
>
> So it's matching on use of INSTALL_PATH not whether INSTALL_PATH has been
> defined.  Interesting concept. :p
>
>
