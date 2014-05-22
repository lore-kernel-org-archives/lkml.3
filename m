Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaEVMNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:13:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39286 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbaEVMNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:13:31 -0400
Date: Thu, 22 May 2014 14:13:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] intel_rapl: Correct hotplug correction
Message-ID: <20140522121328.GI4383@pd.tnic>
References: <1400750624-19238-1-git-send-email-bp@alien8.de>
 <537DC6D2.8040305@linux.vnet.ibm.com>
 <20140522100820.GE4383@pd.tnic>
 <537DE579.6000505@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <537DE579.6000505@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 05:24:33PM +0530, Srivatsa S. Bhat wrote:
> That was just me trying to explain the current mess, not justifying
> it! :-/

Yes, it is a mess - thanks for explaining it.

> I think Oleg had a proposed patch to use per-cpu rwsem in CPU hotplug to
> drastically simplify this whole locking scheme. I think we could look at
> that again.

And that is my question: why can't all be made to use a single dumb lock
allowing only one task and lock everything hotplug with it?

Maybe it is an oversimplification but why do I care about hotplug
operations scaling - they're not on the fastpath anyway.

And yes, we're trying to remove CPU_POST_DEAD - I have one user in
MCE which I'm testing a removal patch for - and then we can all use
get_/put_online_cpus() like we used to do and be happy.

Having 2 + 1 aliased hotplug sync APIs is beyond insane and is simply
not needed IMHO.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
