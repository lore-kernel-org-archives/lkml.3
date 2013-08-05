Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab3HESvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:51:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:13092 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738Ab3HESvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:51:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,820,1367996400"; 
   d="scan'208";a="278022178"
Message-ID: <51FFF430.1060701@linux.intel.com>
Date: Mon, 05 Aug 2013 11:51:28 -0700
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
References: <1375721715.22073.80.camel@gandalf.local.home>    <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>   <1375725328.22073.101.camel@gandalf.local.home>   <51FFEC56.6040206@linux.intel.com>  <1375727010.22073.110.camel@gandalf.local.home>  <51FFEEEC.5060902@linux.intel.com> <1375728583.22073.118.camel@gandalf.local.home>
In-Reply-To: <1375728583.22073.118.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 11:49 AM, Steven Rostedt wrote:
> On Mon, 2013-08-05 at 11:29 -0700, H. Peter Anvin wrote:
> 
>> Traps nest, that's why there is a stack.  (OK, so you don't want to take
>> the same trap inside the trap handler, but that code should be very
>> limited.)  The trap instruction just becomes very short, but rather
>> slow, call-return.
>>
>> However, when you consider the cost you have to consider that the
>> tracepoint is doing other work, so it may very well amortize out.
> 
> Also, how would you pass the parameters? Every tracepoint has its own
> parameters to pass to it. How would a trap know what where to get "prev"
> and "next"?
> 

How do you do that now?

You have to do an IP lookup to find out what you are doing.

(Note: I wonder how much the parameter generation costs the tracepoints.)

	-hpa


