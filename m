Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaIDITx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 04:19:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59972 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaIDITu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 04:19:50 -0400
Date: Thu, 4 Sep 2014 10:19:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, acme@infradead.org, eranian@google.com
Subject: Re: [PATCH 1/2] perf/x86/intel: Add Haswell-EP uncore support
Message-ID: <20140904081928.GL3190@worktop.ger.corp.intel.com>
References: <1408499458-6555-1-git-send-email-zheng.z.yan@intel.com>
 <20140822052926.GM4120@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822052926.GM4120@two.firstfloor.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 07:29:26AM +0200, Andi Kleen wrote:
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > index 4785ee8..2485fd9 100644
> > --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > @@ -883,6 +883,8 @@ static int __init uncore_pci_init(void)
> >  	case 62: /* Ivy Bridge-EP */
> >  		ret = ivbep_uncore_pci_init();
> >  		break;
> > +	case 63: /* Haswell-EP */
> > +		ret = hswep_uncore_pci_init();
> 
> Is the lack of break intentional? If yes please add a /* FALL THROUGH */
> comment.

This does look inconsistent with the surrounding code, which does
suggest it was indeed an oversight and not on purpose.

Zheng?
