Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab3AYGQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 01:16:10 -0500
Received: from ozlabs.org ([203.10.76.45]:50365 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab3AYGQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 01:16:08 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>, Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu, Oleg Nesterov <oleg@redhat.com>,
        srivatsa.bhat@linux.vnet.ibm.com, Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 23/32] Generic dynamic per cpu refcounting
In-Reply-To: <20130125005136.GE2373@mtj.dyndns.org>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com> <1356573611-18590-26-git-send-email-koverstreet@google.com> <20130125005136.GE2373@mtj.dyndns.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 25 Jan 2013 16:45:10 +1030
Message-ID: <87libhpz4h.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:
>> It also implements two stage shutdown, as we need it to tear down the
>> percpu counts. Before dropping the initial refcount, you must call
>> percpu_ref_kill(); this puts the refcount in "shutting down mode" and
>> switches back to a single atomic refcount with the appropriate barriers
>> (synchronize_rcu()).
>
> Maybe if we have tryget() which only succeeds if the counter is alive,
> we can replace moulde refcnt with this?  Rusty?

Yes, it's similar (hence my previous interest), though module count is a
bit weird.

Like Tejun, I'd prefer to see it always alloc up-front, because it
avoids the _noalloc variant (which is backwards: please hand gfp_t, so
you don't hide the alloc) and heuristics.

Cheers,
Rusty.
