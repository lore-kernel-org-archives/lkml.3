Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab3CEWov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:44:51 -0500
Received: from mail-gh0-f180.google.com ([209.85.160.180]:54788 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab3CEWot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:44:49 -0500
Date: Tue, 5 Mar 2013 14:44:44 -0800
From: Tejun Heo <tj@kernel.org>
To: Ryan Mallon <rmallon@gmail.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, axboe@kernel.dk,
        jmoyer@redhat.com, zab@redhat.com,
        kbuild test robot <fengguang.wu@intel.com>
Subject: Re: [PATCH v2 16/31] workqueue: introduce workqueue_attrs
Message-ID: <20130305224444.GC1227@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <1362194662-2344-17-git-send-email-tj@kernel.org>
 <20130304183742.GI30413@htj.dyndns.org>
 <513671CF.5050705@gmail.com>
 <20130305223327.GA1227@htj.dyndns.org>
 <20130305223434.GB1227@htj.dyndns.org>
 <51367470.5040909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51367470.5040909@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Mar 06, 2013 at 09:40:48AM +1100, Ryan Mallon wrote:
> > Ooh, right, and that cpumask_t is going away and you can't statically
> > allocate cpumask_var_t, so it needs an allocation and error check from
> > it anyway.
> 
> Not sure I follow. I mean drop the pointer, eg:
> 
> 	struct workqueue_attr attrs;
> 
> Since, at least in this patch, struct worker_pool appears to always
> alloc the attrs field. You do still of course need the cpumask_t
> initialisation. Am I missing something?

So, new usages of cpumask_t is frowned upon and we gotta use
cpumask_var_t which needs alloc_cpumask_var() which may fail, so we
have try-to-alloc-and-check-for-failure no matter what.  Now, if we
want to embed workqueue_attrs, we have to separate out initialization
of allocated attrs from the actaul allocation.  ie. we'll need
init_workqueue_attrs() and alloc_workqueue_attrs() and as the former
may fail too, it doesn't really simplify pool initilaization path.
So, we end up with more code.  The added code is minor but it also
doesn't buy anything.

Thanks.

-- 
tejun
