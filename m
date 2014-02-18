Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaBRUVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:21:49 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:42695 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbaBRUVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:21:46 -0500
Date: Tue, 18 Feb 2014 12:21:42 -0800
From: Jens Axboe <axboe@kernel.dk>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 10/12] block: Substitute
 rcu_access_pointer() for rcu_dereference_raw()
Message-ID: <20140218202142.GE25515@kernel.dk>
References: <20140217213533.GA5387@linux.vnet.ibm.com>
 <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1392672959-6386-10-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392672959-6386-10-git-send-email-paulmck@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17 2014, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> (Trivial patch.)
> 
> If the code is looking at the RCU-protected pointer itself, but not
> dereferencing it, the rcu_dereference() functions can be downgraded to
> rcu_access_pointer().  This commit makes this downgrade in blkg_destroy()
> and ioc_destroy_icq(), both of which simply compare the RCU-protected
> pointer against another pointer with no dereferencing.

Thanks Paul, applied.

-- 
Jens Axboe

