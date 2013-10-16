Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934738Ab3JPOWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:22:24 -0400
Received: from b232-35.smtp-out.amazonses.com ([199.127.232.35]:34064 "EHLO
	b232-35.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934280Ab3JPOWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:22:23 -0400
Date: Wed, 16 Oct 2013 14:22:22 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Alex Shi <alex.shi@intel.com>
Subject: Re: [PATCH 3/6] mm: Use raw_cpu ops for determining current NUMA
 node
In-Reply-To: <20131016083813.GQ10651@twins.programming.kicks-ass.net>
Message-ID: <00000141c1a55f44-e50c78e7-4b77-49de-b475-21e04cd4f418-000000@email.amazonses.com>
References: <20131015174722.615394057@linux.com> <20131015174746.244538146@linux.com> <20131016083813.GQ10651@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.127.232.35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013, Peter Zijlstra wrote:


> NAK; smp_processor_id() has the preemption checks; for consistently
> numa_node_id() should have them too, for the very same reason. Who's to
> say the node id is still valid when you return from this function? If
> we're preemptable we could've just been migrated away to another node.
>
> So please introduce raw_numa_node_id() and use that; all fully analogous
> to smp_processor_id().

The code that was here before the use of this_cpu ops did use
raw_smp_processor_id.

