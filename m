Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab3HEStq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:49:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33474 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab3HEStp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:49:45 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pFOAptgLnqcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pvQ05lsfB1wA:10 a=Y9KW_Q12ipOsNPKX39gA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375728583.22073.118.camel@gandalf.local.home>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Mon, 05 Aug 2013 14:49:43 -0400
In-Reply-To: <51FFEEEC.5060902@linux.intel.com>
References: <1375721715.22073.80.camel@gandalf.local.home>
	   <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
	  <1375725328.22073.101.camel@gandalf.local.home>
	  <51FFEC56.6040206@linux.intel.com>
	 <1375727010.22073.110.camel@gandalf.local.home>
	 <51FFEEEC.5060902@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 11:29 -0700, H. Peter Anvin wrote:

> Traps nest, that's why there is a stack.  (OK, so you don't want to take
> the same trap inside the trap handler, but that code should be very
> limited.)  The trap instruction just becomes very short, but rather
> slow, call-return.
> 
> However, when you consider the cost you have to consider that the
> tracepoint is doing other work, so it may very well amortize out.

Also, how would you pass the parameters? Every tracepoint has its own
parameters to pass to it. How would a trap know what where to get "prev"
and "next"?

-- Steve


