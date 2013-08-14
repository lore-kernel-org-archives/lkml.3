Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052Ab3HNRMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 13:12:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:3316 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759356Ab3HNRMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 13:12:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,878,1367996400"; 
   d="scan'208";a="386337309"
Date: Wed, 14 Aug 2013 10:12:16 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [RFC][PATCH 0/5] preempt_count rework
Message-ID: <20130814171216.GP23412@tassilo.jf.intel.com>
References: <20130814131539.790947874@chello.nl>
 <20130814164827.GN23412@tassilo.jf.intel.com>
 <20130814165505.GB21191@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130814165505.GB21191@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 06:55:05PM +0200, Peter Zijlstra wrote:
> On Wed, Aug 14, 2013 at 09:48:27AM -0700, Andi Kleen wrote:
> 
> > FWIW I removed the user_schedule in v2 because I don't need it anymore.
> > Feel free to pick it up from v1 though.
> 
> Ah, I had a quick look through your v2 because I got a link into it from
> Ingo but didn't find it. I'll have to ask Google to locate this v1. I

Sorry, it's the thread starting with

http://permalink.gmane.org/gmane.linux.kernel/1541950

I also pushed the branch to git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git

uaccess-opt311 is v1
uaccess-opt311-2 is v2 (without user_schedule)


> suppose that's what's wrong with my last patch. It directly does a call
> preempt_schedule -- which I had hoped would work due to its asmlinkage,
> but apparently there's more to it.

preempt_schedule does not preserve registers, so yes that would
explain a lot of problems.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
