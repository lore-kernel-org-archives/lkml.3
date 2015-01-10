Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbbAJA1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 19:27:13 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:33681 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbAJA1L (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Fri, 9 Jan 2015 19:27:11 -0500
Message-ID: <1420849621.2565.1.camel@stgolabs.net>
Subject: Re: [PATCH tip/core/rcu 01/14] rcu: Protect rcu_boost() lockless
 accesses with ACCESS_ONCE()
From: Davidlohr Bueso <dave@stgolabs.net>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, Pranith Kumar <bobby.prani@gmail.com>
Date: Fri, 09 Jan 2015 16:27:01 -0800
In-Reply-To: <54B04F1A.1060401@de.ibm.com>
References: <20150107173215.GA897@linux.vnet.ibm.com>
	 <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20150108094102.GD29390@twins.programming.kicks-ass.net>
	 <20150108152230.GL5280@linux.vnet.ibm.com>
	 <1420785714.25454.1.camel@stgolabs.net>
	 <20150109134954.GO5280@linux.vnet.ibm.com>
	 <20150109135614.GI29390@twins.programming.kicks-ass.net>
	 <54B04F1A.1060401@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-09 at 22:58 +0100, Christian Borntraeger wrote:
> When we talk about changing the parameters it might make sense to also think about some comments from George Spelvin and consider a rename to WRITE_ONCE or STORE_ONCE (READ_ONCE --> LOAD_ONCE). Unfortunately there doesnt seem to be a variant that is fool proof (in the sense of Rustys guideline that a good interface cannot be used wrong). So any proposal in that regard would be very welcome.

I think any of those two names are a lot better than what we have now.
I'm a bit inclined towards LOAD/STORE though. That, and reordering the
arguments for stores would make it pretty fool proof imo.

Thanks,
Davidlohr

