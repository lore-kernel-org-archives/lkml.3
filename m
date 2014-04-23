Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbaDWPJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:09:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42353 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbaDWPJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:09:17 -0400
Date: Wed, 23 Apr 2014 17:09:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Venkatesh Srinivas <venkateshs@google.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH] perf/x86/intel: Use rdmsrl_safe when initializing RAPL
 PMU.
Message-ID: <20140423150912.GO11096@twins.programming.kicks-ass.net>
References: <1394739386-22260-1-git-send-email-venkateshs@google.com>
 <CABPqkBRm8Ux15UY2+hF1TZdVsgVbYV+9XPiuh9m497Mr3oJ0Wg@mail.gmail.com>
 <20140423144538.GN11096@twins.programming.kicks-ass.net>
 <CABPqkBT5xg+zQ45dugHiXM5XFYi+V3gsBmANevx25fE0S0iNXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBT5xg+zQ45dugHiXM5XFYi+V3gsBmANevx25fE0S0iNXA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 04:49:55PM +0200, Stephane Eranian wrote:
> On your machine, booted with 3.15-rc2, do you have /sys/devices/power?
> If not, and you have at least an SNB, you should have RAPL and that
> RAPL_UNIT MSR.
> 
> Proof is that if you read that MSR using /dev/cpu/msr it works just fine:
> # modprobe msr
> # rdmsr 0x606
> a1003
> 
> So something is broken somewhere.

I've not got SNB+ class hardware (for testing). But I believe you that
there's something funny, I just do not understanding how *msr_safe()
could cause this.
