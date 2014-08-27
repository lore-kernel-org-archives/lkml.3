Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935418AbaH0Qnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 12:43:35 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:65434 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934674AbaH0Qnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 12:43:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140827162113.GA2663@linux.vnet.ibm.com>
References: <CAJhHMCC6XUo0erp6mPyjiz5614DQq_+gfVaLR5s9YZkP=jPVCw@mail.gmail.com>
 <20140827044350.GD13052@grmbl.mre> <20140827162113.GA2663@linux.vnet.ibm.com>
From: Pranith Kumar <pranith@gatech.edu>
Date: Wed, 27 Aug 2014 12:43:01 -0400
X-Google-Sender-Auth: 9T80BSEHLkWravl0XPHsl5TnD-8
Message-ID: <CAJhHMCBhhObL9hb9P_BCLBiVxn5z5MHawk=Xs=VMx2EqpnzUHA@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Amit Shah <amit.shah@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Silas Boyd-Wickizer <sbw@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 12:21 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Wed, Aug 27, 2014 at 10:13:50AM +0530, Amit Shah wrote:

>>
>> Yes, this patch helps my case as well.
>
> Very good!!!
>
> Pranith, I can take this patch, but would you be willing to invert
> the sense of ->nocb_leader_wake (e.g., call it ->nocb_leader_sleep or
> some such)?  This field is only used in eight places in the source code.
>
> The idea is that inverting the sense of the field allows the normal C
> initialization of zero to properly initialize this field, plus it gets
> rid of a few lines of code.
>

Sure, that is indeed a good idea. I will send a new patch.

-- 
Pranith
