Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965017Ab3FTCXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:23:21 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:41268 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935570Ab3FTCXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:23:17 -0400
Date: Wed, 19 Jun 2013 19:23:12 -0700
From: Tejun Heo <tj@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH percpu/for-3.11 1/2] percpu-refcount: add __must_check to
 percpu_ref_init() and don't use ACCESS_ONCE() in percpu_ref_kill_rcu()
Message-ID: <20130620022312.GA26127@htj.dyndns.org>
References: <20130613035201.GD9451@mtj.dyndns.org>
 <87y5a6n71o.fsf@rustcorp.com.au>
 <20130619082123.GD30681@mtj.dyndns.org>
 <878v25mwag.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878v25mwag.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 20, 2013 at 10:29:51AM +0930, Rusty Russell wrote:
> Now seems to get abused by lazy coders who blame users for their own
> broken APIs.  And Ubuntu, who turn it on by default in their gcc when
> optimizing.  Yeah, it's a sore point :)

How is the API broken?  It is a function which either succeeds or
fails and, if it fails during boot, like any other allocation failures
during boot, the boot fails.  It's not different from kmalloc()
returning NULL on failure.

>         	if (system(command))
>         		doesnt_matter();

It *does* matter.

> Sorry, I was unclear.  If you fail the percpu allocation, you have a
> counter which is always in atomic mode.
> 
> This saves everyone a headache.  init doesn't fail, no poorly-tested
> failure paths, no whining Rusty.

How does that save a headache?  It *should* fail if allocation fails.
Having untraceable persistent slow down after heavy memory pressure is
no fun to track down.  If you're worried about not being able to
detect bugs in error path, the right thing to do would be inducing
allocation failures regularly so that those paths can be tested, which
we already do.

Thanks.

-- 
tejun
