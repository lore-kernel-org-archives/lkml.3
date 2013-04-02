Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761089Ab3DBIl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:41:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44589 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757101Ab3DBIl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:41:57 -0400
Date: Tue, 2 Apr 2013 09:41:39 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 03/10] ARM: smp_twd: Divorce smp_twd from local timer
 API
Message-ID: <20130402084138.GG30477@e106331-lin.cambridge.arm.com>
References: <1363198676-30417-1-git-send-email-sboyd@codeaurora.org>
 <1363198676-30417-4-git-send-email-sboyd@codeaurora.org>
 <20130328152255.GD30477@e106331-lin.cambridge.arm.com>
 <5154A37B.1070407@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5154A37B.1070407@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 08:09:31PM +0000, Stephen Boyd wrote:
> On 03/28/13 08:22, Mark Rutland wrote:
> > This works on my A9x4 coretile, bringing CPUs up and down via
> > /sys/devices/system/cpu/*/online, so:
> >
> > Tested-by: Mark Rutland <mark.rutland@arm.com>
> 
> Thanks. I still need to resolve patch #1 though.
> 
> >
> > Otherwise, is there any reason we couldn't now use the twd driver on a UP
> > system? Or would the overhead of handling frequency change make this pointless?
> 
> I don't see why not but I don't have any interest in pursuing it.

Ok.

> 
> >
> > On Wed, Mar 13, 2013 at 06:17:49PM +0000, Stephen Boyd wrote:
> >> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> >> index 5b71469..5ad2ccf 100644
> >> --- a/arch/arm/Kconfig
> >> +++ b/arch/arm/Kconfig
> >> @@ -1527,6 +1527,7 @@ config SMP
> >>  	depends on HAVE_SMP
> >>  	depends on MMU
> >>  	select HAVE_ARM_SCU if !ARCH_MSM_SCORPIONMP
> >> +	select HAVE_ARM_TWD if (!ARCH_MSM_SCORPIONMP && !EXYNOS4_MCT)
> > Could you not depend on your "Push selects for TWD/SCU into machine entries"
> > for this?
> 
> Right now the patches don't depend on the push down patch. Are you
> saying it would be better to depend on that patch?

It just seemed odd to me that the two series should conflict (though
trivially) here.

Mark.
