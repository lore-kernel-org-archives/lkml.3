Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599Ab3GEMpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 08:45:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40310 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050Ab3GEMpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 08:45:07 -0400
Date: Fri, 5 Jul 2013 14:45:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH v2 3/7] perf, x86: Introduce x86 special perf event
 context
Message-ID: <20130705124500.GS23916@twins.programming.kicks-ass.net>
References: <1372663387-11754-1-git-send-email-zheng.z.yan@intel.com>
 <1372663387-11754-4-git-send-email-zheng.z.yan@intel.com>
 <20130704124148.GI23916@twins.programming.kicks-ass.net>
 <51D63B43.9050604@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D63B43.9050604@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 11:19:31AM +0800, Yan, Zheng wrote:
> On 07/04/2013 08:41 PM, Peter Zijlstra wrote:
> > It should be *optional*, also wtf is that parent_ctx thing for?
> 
> parent_ctx is for the fork() case, used for checking if the callstack feature
> is enabled for the parent task. If yes, clone  parent task's LBR stack.
> For the simple program below:

So there's a problem with all this; contexts aren't strict per task, we
play games with them in perf_event_context_sched_out(). We'd have to
disable that context switch optimization for LBR stack to work and
that's massively expensive.

If you actually did that, you again fail for not having mentioned this
in your changelog.

I'm starting to not want to read patches from you; going through them is
just too much effort, I might as well write the stuff myself :/
