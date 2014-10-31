Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbaJaQCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:02:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:24498 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753327AbaJaQCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:02:15 -0400
Date: Fri, 31 Oct 2014 12:01:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [for-next][PATCH 1/4] ftrace/x86: Add dynamic allocated
 trampoline for ftrace_ops
Message-ID: <20141031120158.1f648f7a@gandalf.local.home>
In-Reply-To: <54531BC7.4030307@hitachi.com>
References: <20141027182702.778680710@goodmis.org>
	<20141027182948.284867581@goodmis.org>
	<54531BC7.4030307@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014 14:19:03 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:


> > +	/* Load the contents of ptr into the callback parameter */
> > +	offset = (unsigned long)ptr;
> > +	offset -= (unsigned long)trampoline + op_offset + OP_REF_SIZE;
> > +
> > +	op_ptr.offset = offset;
> > +
> > +	/* put in the new offset to the ftrace_ops */
> > +	memcpy(trampoline + op_offset, &op_ptr, OP_REF_SIZE);
> 
> Would we better call flush_icache_range here?

Do we need to? We just allocated memory to execute. It shouldn't be in
any CPU cache on the machine.

-- Steve


> 
> Thank you,
> 
> > +
> > +	/* ALLOC_TRAMP flags lets us know we created it */
> > +	ops->flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
> > +
> > +	return (unsigned long)trampoline;
> > +}
> 
> 

