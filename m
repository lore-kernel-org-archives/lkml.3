Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbbAIGmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 01:42:10 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:40015 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbbAIGmJ (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Fri, 9 Jan 2015 01:42:09 -0500
Message-ID: <1420785714.25454.1.camel@stgolabs.net>
Subject: Re: [PATCH tip/core/rcu 01/14] rcu: Protect rcu_boost() lockless
 accesses with ACCESS_ONCE()
From: Davidlohr Bueso <dave@stgolabs.net>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, bobby.prani@gmail.com
Date: Thu, 08 Jan 2015 22:41:54 -0800
In-Reply-To: <20150108152230.GL5280@linux.vnet.ibm.com>
References: <20150107173215.GA897@linux.vnet.ibm.com>
	 <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20150108094102.GD29390@twins.programming.kicks-ass.net>
	 <20150108152230.GL5280@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-08 at 07:22 -0800, Paul E. McKenney wrote:
> > Didn't we just obsolete ACCESS_ONCE with that {READ,WRITE}_ONCE stuff?
> 
> Indeed we did!  But that was after I did this commit back on October 29th.
> 
> I am planning a bulk change to READ_ONCE() and ASSIGN_ONCE() either as
> the last patch for 3.20 or as the first one for 3.21.  Probably as the
> first for 3.21 to minimize rebasing hassles with any needed 3.20 fixes.

That reminds me, I think the new conversion for stores will most likely
introduce silly arg bugs:

-       ACCESS_ONCE(a) = b;
+       ASSIGN_ONCE(b, a);

Thanks,
Davidlohr

