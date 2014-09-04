Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbaIDP4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:56:18 -0400
Received: from one.firstfloor.org ([193.170.194.197]:34614 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaIDP4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:56:17 -0400
Date: Thu, 4 Sep 2014 17:56:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf/x86/intel: Add Haswell-EP uncore support
Message-ID: <20140904155613.GD4120@two.firstfloor.org>
References: <1408499458-6555-1-git-send-email-zheng.z.yan@intel.com>
 <20140822052926.GM4120@two.firstfloor.org>
 <20140904081928.GL3190@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140904081928.GL3190@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 10:19:28AM +0200, Peter Zijlstra wrote:
> On Fri, Aug 22, 2014 at 07:29:26AM +0200, Andi Kleen wrote:
> > > diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > > index 4785ee8..2485fd9 100644
> > > --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > > +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > > @@ -883,6 +883,8 @@ static int __init uncore_pci_init(void)
> > >  	case 62: /* Ivy Bridge-EP */
> > >  		ret = ivbep_uncore_pci_init();
> > >  		break;
> > > +	case 63: /* Haswell-EP */
> > > +		ret = hswep_uncore_pci_init();
> > 
> > Is the lack of break intentional? If yes please add a /* FALL THROUGH */
> > comment.
> 
> This does look inconsistent with the surrounding code, which does
> suggest it was indeed an oversight and not on purpose.
> 
> Zheng?

Yes it was a bug. Zheng left Intel and I have taken over the driver.
I'll send a version with this and some other issues fixed shortly.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
