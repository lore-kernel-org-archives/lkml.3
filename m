Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3HLJYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 05:24:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50332 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab3HLJYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 05:24:08 -0400
Date: Mon, 12 Aug 2013 11:23:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: paulus@samba.org, Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        Tejun Heo <tj@kernel.org>, cl@linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, trinity@vger.kernel.org
Subject: Re: perf, percpu: panic in account_event
Message-ID: <20130812092353.GC27162@twins.programming.kicks-ass.net>
References: <520016D6.8010603@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520016D6.8010603@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 05:19:18PM -0400, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running latest -next kernel,
> I've stumbled on the following spew.
> 
> It seems to happen on the following line in account_event():
> 
> 	if (event->attr.freq)
> 		atomic_inc(&per_cpu(perf_freq_events, cpu));  <--- here
> 

Right, Frederic even send a fix for this already. I suppose holidays got
in the way of getting it merged quickly though, sorry for that.

Merged his fix, will hopefully get it into tip soon.
