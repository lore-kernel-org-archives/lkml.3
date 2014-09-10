Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaIJOkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:40:19 -0400
Received: from one.firstfloor.org ([193.170.194.197]:52362 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaIJOkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:40:15 -0400
Date: Wed, 10 Sep 2014 16:40:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, eranian@google.com, tglx@linutronix.de,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, x86: Fall back to vmalloc for BTS buffer
 allocation
Message-ID: <20140910144012.GI4120@two.firstfloor.org>
References: <1410307401-12401-1-git-send-email-andi@firstfloor.org>
 <20140910075722.GL6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910075722.GL6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We did this once, and that blew up big time.
> 
> Even now, vmalloc_fault() has a very explicit:
> 
>   WARN_ON_ONCE(in_nmi());
> 
> So this isn't going to happen until you fix that.

Good point.

We just need to call vmalloc_sync_all at allocation time,
no need to change vmalloc_fault.

-Andi



-- 
ak@linux.intel.com -- Speaking for myself only.
