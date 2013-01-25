Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab3AYCJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:09:58 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:42525 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab3AYCJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:09:50 -0500
Date: Thu, 24 Jan 2013 18:09:43 -0800
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu, Oleg Nesterov <oleg@redhat.com>,
        srivatsa.bhat@linux.vnet.ibm.com, Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 23/32] Generic dynamic per cpu refcounting
Message-ID: <20130125020943.GH2373@mtj.dyndns.org>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-26-git-send-email-koverstreet@google.com>
 <20130125005136.GE2373@mtj.dyndns.org>
 <20130125011345.GT26407@google.com>
 <20130125020340.GG2373@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125020340.GG2373@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Thu, Jan 24, 2013 at 06:03:40PM -0800, Tejun Heo wrote:
> Yeah, if we're aiming to replace refcnts in file and kobj, dynamic
> alloc may be justified.  Hopefully, the accounting necessary to decide
> whethre to use percpu isn't too burdensome.

Ooh, I forgot one thing.  We might not gain much by replacing file
refcnt w/ this.  You can't really get cheaper than fget_light().
Also, while kobj destruction can still be considered an infrequent
operation, file destruction is not and people will get mighty unhappy
if you do synchronize_sched/rcu() from fput() synchronously.

So, I'm now back to "do we need dynamic allocation".  What else do we
have to convert?

Thanks.

-- 
tejun
