Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbaHYXF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 19:05:57 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:12297 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756691AbaHYXF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 19:05:56 -0400
Date: Mon, 25 Aug 2014 19:05:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andreea-Cristina Bernat <bernat.ada@gmail.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: trace_syscalls: Replace rcu_assign_pointer()
 with RCU_INIT_POINTER()
Message-ID: <20140825190554.36ebafe7@gandalf.local.home>
In-Reply-To: <20140825225654.GG2663@linux.vnet.ibm.com>
References: <20140822142822.GA32391@ada>
	<20140822113758.172eb474@gandalf.local.home>
	<20140825225654.GG2663@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2014 15:56:54 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

 
> > I guess I can add this. It's a very slow path thus it isn't critical.
> > 
> > Although, I hate the name. Perhaps we should add another macro called
> > RCU_CLEAR_POINTER() or something that just nulls it. That way it
> > documents the use. To me, INIT means the pointer is being initialized,
> > where in reality it's just being cleared. I guess one could argue that
> > the pointer is being "re-initialized".
> 
> I considered that, but there end up being three separate use cases
> for this thing:
> 
> 1.	NULLing the pointer, as in this case.
> 
> 2.	Initializing the pointer at a time when no readers have a
> 	reference to that pointer.  (In this case, there is presumably
> 	a later rcu_assign_pointer() that makes the whole thing visible
> 	to readers.)
> 
> 3.	Rearranging data that is already visible to readers, the usual
> 	example being removing an element -- readers can already see
> 	the successor in this case.
> 
> Having three different APIs for identical macros seemed like overkill
> to me.  Especially given that people already complain about the RCU
> API being too big.  :-(
> 

Yeah, understood. But I think CLEAR is better than INIT as it says
what it's doing more than what it is for. In all three above, we want
to clear the pointer, but in only one case we want to initialize it.

But this is bikeshedding, and not worth the time of this dicussion.

No need to look further. Nothings going on here. Move along people or
I'll have to get my pepper spray out.

-- Steve
