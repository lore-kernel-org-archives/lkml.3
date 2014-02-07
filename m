Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaBGVTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 16:19:10 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58985 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaBGVTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 16:19:09 -0500
Date: Fri, 7 Feb 2014 13:19:07 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] ARM: msm: kill off hotplug.c
Message-ID: <20140207211907.GE12815@codeaurora.org>
References: <1391553532-27001-1-git-send-email-galak@codeaurora.org>
 <1391553532-27001-2-git-send-email-galak@codeaurora.org>
 <20140204230707.GD20528@codeaurora.org>
 <CE29C478-50CA-4CC8-9E80-AA9C22D9B17F@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CE29C478-50CA-4CC8-9E80-AA9C22D9B17F@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Kumar Gala wrote:
> 
> On Feb 4, 2014, at 5:07 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> 
> > On 02/04, Kumar Gala wrote:
> >> diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
> >> index 3721b31..251a91e 100644
> >> --- a/arch/arm/mach-msm/platsmp.c
> >> +++ b/arch/arm/mach-msm/platsmp.c
> >> @@ -29,6 +29,13 @@ extern void secondary_startup(void);
> >> 
> >> static DEFINE_SPINLOCK(boot_lock);
> >> 
> >> +#ifdef CONFIG_HOTPLUG_CPU
> >> +static void __ref msm_cpu_die(unsigned int cpu)
> > 
> > We shouldn't need __ref anymore either right?
> 
> I think we might as cpu_die is still marked __ref so I think we need it.
> 

Someone should remove __ref from cpu_die() as well. It was only
ever there for __cpuinit but now that __cpuinit is gone it's
useless.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
