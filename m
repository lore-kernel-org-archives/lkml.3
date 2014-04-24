Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbaDXVLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:11:16 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:40452 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbaDXVLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:11:14 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 24 Apr 2014 17:14:40 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [perf] yet another 32/64-bit range check failure
In-Reply-To: <20140423102254.GL11096@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1404241712310.9220@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1404222329590.28273@vincent-weaver-1.um.maine.edu> <20140423102254.GL11096@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014, Peter Zijlstra wrote:
> 
> Something like so should do I suppose.
> 
> ---
> Subject: perf: Fix perf_event_open(.flags) test
> 
> Vince noticed that we test the (unsigned long) flags field against an
> (unsigned int) constant. This would allow setting the high bits on 64bit
> platforms and not get an error.
> 
> There is nothing that uses the high bits, so it should be entirely
> harmless, but we don't want userspace to accidentally set them anyway,
> so fix the constants.
> 
> Reported-by: Vince Weaver <vincent.weaver@maine.edu>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Tested-by: Vince Weaver <vincent.weaver@maine.edu>

Your patch fixes the problem, or at least the test I wrote to check the 
issue now fails properly.

Oddly, with this patch applied, it's made it a lot harder (but not 
impossible) to trigger the memory corruption bug, although that might just 
be coincidence.

Vince
