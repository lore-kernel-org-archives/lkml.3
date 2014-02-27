Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbaB0Bmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:42:53 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:48526 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753702AbaB0Bmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:42:52 -0500
Date: Wed, 26 Feb 2014 20:42:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] tracepoint: Do not waste memory on mods with no
 tracepoints
Message-ID: <20140226204250.36de98b1@gandalf.local.home>
In-Reply-To: <87lhwx2y8k.fsf@rustcorp.com.au>
References: <20140226110313.4d92fb83@gandalf.local.home>
	<87lhwx2y8k.fsf@rustcorp.com.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014 11:00:35 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Steven Rostedt <rostedt@goodmis.org> writes:
> > No reason to allocate tp_module structures for modules that have no
> > tracepoints. This just wastes memory.
> >
> > Fixes: b75ef8b44b1c "Tracepoint: Dissociate from module mutex"
> > Cc: stable@vger.kernel.org # 3.2+
> 
> Really?  CC:stable?  To save an insignificant amount of memory?

I agree that this rational alone is not sufficient for stable. But this
is required for another patch that warns when tracepoints are not
loaded by a module due to taints. We don't want to warn on all modules.


> 
> The definition of stable seems to be shifting away from "fixes for
> problems with significant effects".  I obviously missed the memo.

Not telling users that tracepoints were not activated, but acting in
every other way like they are is to me a "significant effect". This
just happened to be something that fixing this depended on.

-- Steve


