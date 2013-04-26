Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab3DZH5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 03:57:24 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60141
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754135Ab3DZH5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 03:57:23 -0400
Date: Fri, 26 Apr 2013 09:56:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] Fix perf LBR filtering
Message-ID: <20130426075601.GB8669@dyad.programming.kicks-ass.net>
References: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
 <20130425162535.GA5828@dyad.programming.kicks-ass.net>
 <20130425164100.GC16732@two.firstfloor.org>
 <20130425164837.GD5828@dyad.programming.kicks-ass.net>
 <20130425170037.GD16732@two.firstfloor.org>
 <20130425171842.GA8669@dyad.programming.kicks-ass.net>
 <20130425174211.GE16732@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425174211.GE16732@two.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 07:42:11PM +0200, Andi Kleen wrote:
> There's the non cachable region tracking. But there's no guarantee a
> MMIO has to be in there, driver may still rely just on MTRRs. Also
> there may be MMIOs the kernel doesn't know about which just happen
> to be somewhere in the direct mapping.
> 
> I don't see any reliable way to detect all mmios.

Hmm.. that's unfortunate.

OK, so how about we use something like:

	 is_kernel_text() || is_module_text_address()

And bail if not; that should at least make it work for the simple case or
normal text and not be worse than what you propose for JIT stuff.
