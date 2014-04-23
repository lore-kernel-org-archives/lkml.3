Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbaDWNaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:30:35 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:43580 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbaDWNab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:30:31 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.um.maine.edu>
Date: Wed, 23 Apr 2014 09:33:56 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [perf] yet another 32/64-bit range check failure
In-Reply-To: <20140423101038.GK11096@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1404230930090.29827@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1404222329590.28273@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404230011280.28524@vincent-weaver-1.um.maine.edu> <20140423101038.GK11096@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014, Peter Zijlstra wrote:
> 
> So perf_event_open() -> err_alloc: -> free_event() -> __free_event() ->
> call_rcu() -> free_event_rcu() -> kfree().
> 
> Would explain that, right? The memory is RCU freed, which means we need
> to wait a grace period before releasing it.

ah yes, RCU.  That does make debugging this issue a lot harder.

Back to trying to get the bug to trigger in a useful location while ftrace 
is running.  I keep triggering it immediately after the compiler generates 
helpful code like
	mov    0x40(%rbx),%rbx
so the address is lost and the register dump just holds 0x6b6b6b6b6b6b6b6b.

Vince

