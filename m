Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150Ab3HNQsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:48:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:54045 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760105Ab3HNQsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:48:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,878,1367996400"; 
   d="scan'208";a="380956945"
Date: Wed, 14 Aug 2013 09:48:27 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [RFC][PATCH 0/5] preempt_count rework
Message-ID: <20130814164827.GN23412@tassilo.jf.intel.com>
References: <20130814131539.790947874@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130814131539.790947874@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 03:15:39PM +0200, Peter Zijlstra wrote:
> These patches optimize preempt_enable by firstly folding the preempt and
> need_resched tests into one -- this should work for all architectures. And
> secondly by providing per-arch preempt_count implementations; with x86 using
> per-cpu preempt_count for fastest access.
> 
> These patches have so far only been compiled for defconfig-x86_64 +
> CONFIG_PREEMPT=y and boot tested with kvm -smp 4 upto wanting to mount root.
> 
> It still needs asm volatile("call preempt_schedule": : :"memory"); as per
> Andi's other patches to avoid the C calling convention cluttering the
> preempt_enable() sites.

FWIW I removed the user_schedule in v2 because I don't need it anymore.
Feel free to pick it up from v1 though.

It needs two patches: the one adding SAVE_ALL for 32bit and
the parts of the put_user() patch adding user_schedule

When it's not used in user_ anymore it should probably 
be renamed too, to preempt_schedule or somesuch,
and probably moved to a different file.

-Andi

