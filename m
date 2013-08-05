Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3HES3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:29:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:5610 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699Ab3HES3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:29:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,820,1367996400"; 
   d="scan'208";a="376507597"
Message-ID: <51FFEEEC.5060902@linux.intel.com>
Date: Mon, 05 Aug 2013 11:29:00 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
References: <1375721715.22073.80.camel@gandalf.local.home>   <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>  <1375725328.22073.101.camel@gandalf.local.home>  <51FFEC56.6040206@linux.intel.com> <1375727010.22073.110.camel@gandalf.local.home>
In-Reply-To: <1375727010.22073.110.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 11:23 AM, Steven Rostedt wrote:
> On Mon, 2013-08-05 at 11:17 -0700, H. Peter Anvin wrote:
>> On 08/05/2013 10:55 AM, Steven Rostedt wrote:
>>>
>>> Well, as tracepoints are being added quite a bit in Linux, my concern is
>>> with the inlined functions that they bring. With jump labels they are
>>> disabled in a very unlikely way (the static_key_false() is a nop to skip
>>> the code, and is dynamically enabled to a jump).
>>>
>>
>> Have you considered using traps for tracepoints?  A trapping instruction
>> can be as small as a single byte.  The downside, of course, is that it
>> is extremely suppressed -- the trap is always expensive -- and you then
>> have to do a lookup to find the target based on the originating IP.
> 
> No, never considered it, nor would I. Those that use tracepoints, do use
> them extensively, and adding traps like this would probably cause
> heissenbugs and make tracepoints useless.
> 
> Not to mention, how would we add a tracepoint to a trap handler?
> 

Traps nest, that's why there is a stack.  (OK, so you don't want to take
the same trap inside the trap handler, but that code should be very
limited.)  The trap instruction just becomes very short, but rather
slow, call-return.

However, when you consider the cost you have to consider that the
tracepoint is doing other work, so it may very well amortize out.

	-hpa


