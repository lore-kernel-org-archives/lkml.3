Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab3FSIWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:22:09 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:57371 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab3FSIV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:21:27 -0400
Date: Wed, 19 Jun 2013 01:21:23 -0700
From: Tejun Heo <tj@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH percpu/for-3.11 1/2] percpu-refcount: add __must_check to
 percpu_ref_init() and don't use ACCESS_ONCE() in percpu_ref_kill_rcu()
Message-ID: <20130619082123.GD30681@mtj.dyndns.org>
References: <20130613035201.GD9451@mtj.dyndns.org>
 <87y5a6n71o.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5a6n71o.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 12:25:14PM +0930, Rusty Russell wrote:
> But it's quite OK to ignore OOM errors in builtin init functions.

I think it'd be cleaner to let those use cases use BUG_ON() around it.
We really want most users to be checking its return value.

> It would be neatest to have it fail into slow mode, of course, but it's
> probably not worth the pain.

percpu allocation is always GFP_KERNEL, so it can't get any slower
without deadlocking.

Thanks.

-- 
tejun
