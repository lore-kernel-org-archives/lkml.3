Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab3JPPJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:09:15 -0400
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:51821 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074Ab3JPPJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:09:15 -0400
Date: Wed, 16 Oct 2013 15:09:13 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] percpu: Add preemption checks to __this_cpu ops
In-Reply-To: <20131016084920.GT10651@twins.programming.kicks-ass.net>
Message-ID: <00000141c1d04300-e935e477-6669-4388-8109-c77064ee27e7-000000@email.amazonses.com>
References: <20131015174722.615394057@linux.com> <20131015174747.813545438@linux.com> <20131016084920.GT10651@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.16-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013, Peter Zijlstra wrote:

> So I didn't understand what was wrong with:
>
> #define __this_cpu_read(pcp) \
> 	(__this_cpu_preempt_check("read"), raw_this_cpu_read(pcp))
>
> And idem for all others. This is 1) shorter to write; and 2) makes it
> blindingly obvious that the implementations are actually the same.

Nothing wrong with that. It just increases the scope of this patch to
require modifications to arch code and I already have trouble enough
following through on all the issues that were raised so far.

