Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbaEOFDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 01:03:46 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:38977 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaEOFDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 01:03:45 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 15 May 2014 01:07:34 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [perf] yet another 32/64-bit range check failure
In-Reply-To: <alpine.DEB.2.10.1404241712310.9220@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.10.1405150106410.30079@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1404222329590.28273@vincent-weaver-1.um.maine.edu> <20140423102254.GL11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404241712310.9220@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014, Vince Weaver wrote:

> On Wed, 23 Apr 2014, Peter Zijlstra wrote:
> > 
> > Something like so should do I suppose.
> > 
> > ---
> > Subject: perf: Fix perf_event_open(.flags) test
> > 
> > Vince noticed that we test the (unsigned long) flags field against an
> > (unsigned int) constant. This would allow setting the high bits on 64bit
> > platforms and not get an error.
> > 
> > There is nothing that uses the high bits, so it should be entirely
> > harmless, but we don't want userspace to accidentally set them anyway,
> > so fix the constants.
> > 
> > Reported-by: Vince Weaver <vincent.weaver@maine.edu>
> > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> 
> Tested-by: Vince Weaver <vincent.weaver@maine.edu>
> 
> Your patch fixes the problem, or at least the test I wrote to check the 
> issue now fails properly.

Even though this isn't as pressing an issue as the other perf_event 
problems, I wanted to make sure this patch didn't get forgotten...

Vince
