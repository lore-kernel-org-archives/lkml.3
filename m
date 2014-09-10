Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaIJQgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:36:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43324 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaIJQgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:36:06 -0400
Date: Wed, 10 Sep 2014 18:35:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        tglx@linutronix.de, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, x86: Fall back to vmalloc for BTS buffer allocation
Message-ID: <20140910163556.GE4783@worktop.ger.corp.intel.com>
References: <1410307401-12401-1-git-send-email-andi@firstfloor.org>
 <20140910075722.GL6758@twins.programming.kicks-ass.net>
 <20140910144012.GI4120@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910144012.GI4120@two.firstfloor.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 04:40:12PM +0200, Andi Kleen wrote:
> > We did this once, and that blew up big time.
> > 
> > Even now, vmalloc_fault() has a very explicit:
> > 
> >   WARN_ON_ONCE(in_nmi());
> > 
> > So this isn't going to happen until you fix that.
> 
> Good point.
> 
> We just need to call vmalloc_sync_all at allocation time,
> no need to change vmalloc_fault.

Somehow that wasn't considered adequate, but lemme try and dig out that
thread. It should be somewhere...

https://lkml.org/lkml/2010/7/14/465


