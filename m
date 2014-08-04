Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaHDTfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:35:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaHDTfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:35:44 -0400
Date: Mon, 4 Aug 2014 21:32:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140804193258.GA23904@redhat.com>
References: <20140731215445.GA21933@linux.vnet.ibm.com> <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com> <20140802145616.GA18195@redhat.com> <20140802225757.GB8101@linux.vnet.ibm.com> <20140803133318.GB671@redhat.com> <20140803220535.GH8101@linux.vnet.ibm.com> <20140804133221.GC18722@redhat.com> <20140804192810.GR8101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804192810.GR8101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04, Paul E. McKenney wrote:
>
> OK, so I checked out my earlier concern about the group leader going away.
> It looks like the group leader now sticks around until all threads in
> the group have exited, which is a nice change from the behavior I was
> (perhaps incorrectly) recalling!

Ah, I didn't know you were worried about a zombie leader ;)

Yes, this case was always fine. Ignoring the fact while_each_thread() was
always buggy ;) Fortunately for_each_thread() should be fine.

Oleg.

