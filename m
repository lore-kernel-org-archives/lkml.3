Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbaDOToE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:44:04 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35603 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751920AbaDOToB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:44:01 -0400
Date: Tue, 15 Apr 2014 20:43:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Christoph Lameter <cl@linux.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [bisected] broken make-kpkg kernel build in 3.15-rc1
Message-ID: <20140415194319.GV24070@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.10.1404150940250.14106@vincent-weaver-1.um.maine.edu> <534D4A59.6080401@suse.cz> <alpine.DEB.2.10.1404151146530.26562@gentwo.org> <534D6510.3070509@suse.cz> <alpine.DEB.2.10.1404151221360.26992@gentwo.org> <20140415182653.GR24070@n2100.arm.linux.org.uk> <alpine.DEB.2.10.1404151507290.15528@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404151530050.15528@vincent-weaver-1.um.maine.edu> <20140415193116.GU24070@n2100.arm.linux.org.uk> <alpine.DEB.2.10.1404151539110.15528@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404151539110.15528@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 03:39:47PM -0400, Vince Weaver wrote:
> On Tue, 15 Apr 2014, Russell King - ARM Linux wrote:
> > 
> > Hmm, any ideas what HAVE_INST_PATH is set to?  It would be good to have
> > the complete picture on this bug. :)
> 
> In debian/ruleset/misc/version_vars.mk
> 
> HAVE_INST_PATH  =$(call doit,grep -E '\(INSTALL_PATH\)' Makefile 2>/dev/null )

Ah, so that would match on:

export INSTALL_DTBS_PATH ?= $(INSTALL_PATH)/dtbs/$(KERNELRELEASE)
                             ^^^^^^^^^^^^^^

So it's matching on use of INSTALL_PATH not whether INSTALL_PATH has been
defined.  Interesting concept. :p

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
