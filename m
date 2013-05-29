Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966326Ab3E2V3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 17:29:19 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59157 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935197Ab3E2V3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 17:29:12 -0400
Date: Wed, 29 May 2013 23:29:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulmck@linux.vnet.ibm.com, paulus@samba.org, michael@ellerman.id.au,
        Anton Blanchard <anton@au1.ibm.com>
Subject: Re: [RFC PATCH v3 0/5] powerpc: Support context tracking for Power
 pSeries
Message-ID: <20130529212907.GC17419@somewhere>
References: <1368422493-9831-1-git-send-email-zhong@linux.vnet.ibm.com>
 <1368424306.19924.20.camel@pasglop>
 <1368432193.2618.30.camel@ThinkPad-T5421>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368432193.2618.30.camel@ThinkPad-T5421>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 04:03:13PM +0800, Li Zhong wrote:
> On Mon, 2013-05-13 at 15:51 +1000, Benjamin Herrenschmidt wrote:
> > On Mon, 2013-05-13 at 13:21 +0800, Li Zhong wrote:
> > > These patches try to support context tracking for Power arch, beginning with
> > > 64-bit pSeries. The codes are ported from that of the x86_64, and in each
> > > patch, I listed the corresponding patch for x86.
> > 
> > So that's yet another pile of bloat on all syscall entry/exit and
> > exception entry/exit. What is it used for ? (I haven't followed on
> > x86_64 side).
> 
> To my understanding, it is used to enable RCU user extended quiescent
> state, so RCU on that cpu doesn't need scheduler ticks. And together
> with some other code(already in 3.10), we are able to remove the ticks
> in some cases (e.g. only 1 task running on the cpu, with some other
> limitations).
> 
> Maybe Paul, or Frederic could give some better descriptions. 

That's pretty much it. It helps RCU and cputime accounting infrastructure
to know when we enter/exit userspace. This way we can:

* Consider the CPU as idle from an RCU point of view when we run in userspace,
so RCU won't need the tick to stay alive.

* Account cputime (utime/stime/...) without using the tick. Ok powerpc already
has CONFIG_VIRT_CPU_ACCOUNTING_NATIVE but making it working with full dynticks
would require some tweaks.

All in one this is to support full dynticks.

Thanks.
