Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab3DZTqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 15:46:39 -0400
Received: from one.firstfloor.org ([193.170.194.197]:43745 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500Ab3DZTqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 15:46:36 -0400
Date: Fri, 26 Apr 2013 21:46:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] Fix perf LBR filtering
Message-ID: <20130426194633.GF16732@two.firstfloor.org>
References: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
 <20130425162535.GA5828@dyad.programming.kicks-ass.net>
 <20130425164100.GC16732@two.firstfloor.org>
 <20130425164837.GD5828@dyad.programming.kicks-ass.net>
 <20130425170037.GD16732@two.firstfloor.org>
 <20130425171842.GA8669@dyad.programming.kicks-ass.net>
 <20130425174211.GE16732@two.firstfloor.org>
 <20130426075601.GB8669@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426075601.GB8669@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> OK, so how about we use something like:
> 
> 	 is_kernel_text() || is_module_text_address()

is_module_text_address() has to walk all modules.
A random system with a distro kernel I checked has 101 modules loaded.

16 * 101 = too much

I don't think you want to spend that many cycles in the NMI
handler for a dubious feature.  Ok in theory you could
add something with binary search, but that would be quite
a bit of effort and it would be probably challenging 
to do that all NMI safe.

Also it wouldn't work for all these new kernel JITs people 
are doing of course.

Still think my patch is the best so far? (plus the missing
root check)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
