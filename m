Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbaJWMjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:39:11 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39119 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbaJWMjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:39:06 -0400
Date: Thu, 23 Oct 2014 14:38:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 18/20] perf: Allocate ring buffers for inherited
 per-task kernel events
Message-ID: <20141023123855.GC12706@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1413207948-28202-19-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413207948-28202-19-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 04:45:46PM +0300, Alexander Shishkin wrote:
> Normally, per-task events can't be inherited parents' ring buffers to
> avoid multiple events contending for the same buffer. And since buffer
> allocation is typically done by the userspace consumer, there is no
> practical interface to allocate new buffers for inherited counters.
> 
> However, for kernel users we can allocate new buffers for inherited
> events as soon as they are created (and also reap them on event
> destruction). This pattern has a number of use cases, such as event
> sample annotation and process core dump annotation.
> 
> When a new event is inherited from a per-task kernel event that has a
> ring buffer, allocate a new buffer for this event so that data from the
> child task is collected and can later be retrieved for sample annotation
> or core dump inclusion. This ring buffer is released when the event is
> freed, for example, when the child task exits.
> 

This causes a pinned memory explosion, not at all nice that.

I think I see why and all, but it would be ever so good to not have to
allocate so much memory.
