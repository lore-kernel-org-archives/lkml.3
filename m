Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbaF3WTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 18:19:38 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:50150 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbaF3WTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 18:19:37 -0400
Date: Mon, 30 Jun 2014 15:19:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Keith Busch <keith.busch@intel.com>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
Subject: Re: [PATCH] x86: ioapic: Fix irq_free_descs count
In-Reply-To: <alpine.LRH.2.03.1406301613100.4699@AMR>
Message-ID: <alpine.DEB.2.02.1406301517480.13545@chino.kir.corp.google.com>
References: <1404142271-18311-1-git-send-email-keith.busch@intel.com> <alpine.DEB.2.02.1406301452060.13545@chino.kir.corp.google.com> <alpine.LRH.2.03.1406301613100.4699@AMR>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014, Keith Busch wrote:

> On Mon, 30 Jun 2014, David Rientjes wrote:
> > On Mon, 30 Jun 2014, Keith Busch wrote:
> > 
> > > Signed-off-by: Keith Busch <keith.busch@intel.com>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: x86@kernel.org
> > 
> > Acked-by: David Rientjes <rientjes@google.com>
> > 
> > This is definitely a fix for "genirq: Provide generic hwirq allocation
> > facility", but the changelog doesn't describe what the problem is and the
> > title that this somehow fixes irq_free_descs() doesn't make any sense.
> 
> My mistake, I used the component from the commit I bisected the bug
> down to.
> 
> > It's the equivalent of just doing
> > 
> > -	irq_free_descs(from, cnt);
> > +	irq_free_descs(from, i - from);
> > 
> > I'd suggest the patch title be changed to
> > 
> > 	genirq: Fix memory leak when calling irq_free_hwirqs()
> > 
> > and the changelog state
> > 
> > irq_free_hwirqs() always calls irq_free_descs() with a cnt == 0 which
> > makes it a no-op since the interrupt count to free is decremented in
> > itself.
> 
> Yes, I like your suggestion. Should I submit a v2, or will maintainer
> replace the changelog?
> 

It's an urgent patch since commit 7b6ef1262549 ("genirq: Provide generic 
hwirq allocation facility") was already released in 3.15.  Unless Thomas 
fixes it up first, I'd reply with a v2 with the fixed title and changelog, 
add a

	Fixes: 7b6ef1262549f6afc5c881aaef80beb8fd15f908

tag along with my acked-by to make his life 0.000000001% easier.
