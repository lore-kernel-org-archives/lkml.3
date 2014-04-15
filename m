Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaDOTcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:32:01 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35587 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751748AbaDOTb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:31:59 -0400
Date: Tue, 15 Apr 2014 20:31:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Christoph Lameter <cl@linux.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [bisected] broken make-kpkg kernel build in 3.15-rc1
Message-ID: <20140415193116.GU24070@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.10.1404150940250.14106@vincent-weaver-1.um.maine.edu> <534D4A59.6080401@suse.cz> <alpine.DEB.2.10.1404151146530.26562@gentwo.org> <534D6510.3070509@suse.cz> <alpine.DEB.2.10.1404151221360.26992@gentwo.org> <20140415182653.GR24070@n2100.arm.linux.org.uk> <alpine.DEB.2.10.1404151507290.15528@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404151530050.15528@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404151530050.15528@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 03:30:15PM -0400, Vince Weaver wrote:
>   ifeq ($(strip $(HAVE_INST_PATH)),)
>         test ! -f System.map ||  cp System.map                         \
>                         $(TMPTOP)/$(IMAGEDIR)/System.map-$(KERNELRELEASE);
>         test ! -f System.map ||  chmod 644                             \
>                         $(TMPTOP)/$(IMAGEDIR)/System.map-$(KERNELRELEASE);
>         cp $(kimagesrc) $(kimagedest)
>   else
>         $(restore_upstream_debianization)
>         $(MAKE) $(EXTRAV_ARG) INSTALL_MOD_PATH=$(INSTALL_MOD_PATH)           \
>                 INSTALL_FW_PATH=$(INSTALL_MOD_PATH)/lib/firmware/$(KERNELRELEASE)  \
>                 INSTALL_PATH=$(INT_IMAGE_DESTDIR) $(CROSS_ARG) $(KPKG_KBUILD_INSTALL_TARGET)
>   endif
> 
> 
> So in the good case it goes down the if, in the bad case down the else.
> 
> 
> I'm assuming that the ($(strip $(HAVE_INST_PATH)),) is being confused by
> the INSTALL_DTBS_PATH introduced by the changeset.
> 
> So I guess that makes this a debian bug?

Hmm, any ideas what HAVE_INST_PATH is set to?  It would be good to have
the complete picture on this bug. :)

Thanks.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
