Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab3GRIln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:41:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57126 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3GRIli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:41:38 -0400
Date: Thu, 18 Jul 2013 10:41:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [PATCH] perf, x86: Add Silvermont (22nm Atom) support
Message-ID: <20130718084129.GC27075@twins.programming.kicks-ass.net>
References: <1374125767-9411-1-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374125767-9411-1-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 01:36:07PM +0800, Yan, Zheng wrote:

> @@ -1305,7 +1452,7 @@ static void intel_fixup_er(struct perf_event *event, int idx)
>  		event->hw.extra_reg.reg = MSR_OFFCORE_RSP_0;
>  	} else if (idx == EXTRA_REG_RSP_1) {
>  		event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
> -		event->hw.config |= 0x01bb;
> +		event->hw.config |= x86_pmu.extra_regs[1].event;
>  		event->hw.extra_reg.reg = MSR_OFFCORE_RSP_1;
>  	}
>  }

When you do the split up, please make this consistent and use
x86_pmu.extra_regs[0].event as well.

Also, ideally we'd use EXTRA_REG_RSP_[01] instead of the 0 and 1.
