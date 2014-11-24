Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaKXEKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 23:10:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaKXEKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 23:10:16 -0500
Date: Sun, 23 Nov 2014 23:09:04 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Pranith Kumar <bobby.prani@gmail.com>, dm-devel@redhat.com,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
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
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2] drivers/md: use proper rcu accessor
Message-ID: <20141124040903.GB595@redhat.com>
References: <20141028220944.GA26114@linux.vnet.ibm.com>
 <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1414534202-27312-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20141121133145.GA17245@node.dhcp.inet.fi>
 <546F4C8C.4040904@gmail.com>
 <20141121145817.GA17710@node.dhcp.inet.fi>
 <CAJhHMCCE_p+xTibLZwoS5OqW--NO_uEVsW6tfN6LcgZGBquBTQ@mail.gmail.com>
 <1416760829.17888.19.camel@edumazet-glaptop2.roam.corp.google.com>
 <1416764069.17888.36.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416764069.17888.36.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23 2014 at 12:34pm -0500,
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> From: Eric Dumazet <edumazet@google.com>
> 
> rcu_dereference() should be used in sections protected by rcu_read_lock.
> 
> For writers, holding some kind of mutex or lock,
> rcu_dereference_protected() is the way to go, adding explicit lockdep
> bits.
> 
> In __unbind(), we are the last user of this mapped device, so can use
> the constant '1' instead of a lockdep_is_held(), not consistent with
> other uses of rcu_dereference_protected() which use md->suspend_lock
> mutex.
> 
> Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Fixes: 33423974bfc1 ("dm: Use rcu_dereference() for accessing rcu pointer")
> Cc: Pranith Kumar <bobby.prani@gmail.com>
> Cc: Mike Snitzer <snitzer@redhat.com>

Thanks, I've staged this for 3.19:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.19&id=a12f5d48bdfeb5fe10157ac01c3de29269f457c6
