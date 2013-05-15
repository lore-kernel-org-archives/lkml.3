Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640Ab3EOQv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:51:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37586 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759373Ab3EOQv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:51:57 -0400
Date: Wed, 15 May 2013 18:51:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] perf, x86: Blacklist all MEM_*_RETIRED events for IVB
Message-ID: <20130515165152.GB13916@laptop.home>
References: <20130503121122.931661809@chello.nl>
 <20130503121256.083340271@chello.nl>
 <20130503143507.GP19487@tassilo.jf.intel.com>
 <20130503170007.GA30733@dyad.programming.kicks-ass.net>
 <CABPqkBSTMJebZLjvLhdQ1hiemoqvO2t=vi+CG=yLjkFabOr8XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSTMJebZLjvLhdQ1hiemoqvO2t=vi+CG=yLjkFabOr8XQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 04:20:46PM +0200, Stephane Eranian wrote:
> Hi,
> 
> Based on our testing, it appears the corruption occurs only
> when the MEM_* events are used and only on the sibling
> counter. In other words, if HT0 has MEM_* in cntr0, then
> HT1 cntr0 cannot be used, otherwise whatever is there may
> get corrupted.

Ah, great. That is the least horrid case :-)

> So I think we could enhance Andi's initial patch
> to handle this case instead of blacklist those events. They are
> very important events.

Will you take a stab at it? I suppose you'll have to make each counter
have a shared resource and have the mem_*_retired events mark the
resource taken.

Also, did you test what happens when you turn SMT off in the BIOS so you
get double the amount of counters; do we then leak into CNTn+4 or is all
well again?


