Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbaIWNNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:13:25 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:65101 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbaIWNNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:13:23 -0400
Date: Tue, 23 Sep 2014 09:13:19 -0400
From: Tejun Heo <tj@kernel.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: lizefan@huawei.com, peterz@infradead.org, mingo@kernel.org,
        miaox@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, keescook@chromium.org
Subject: Re: [PATCH v2 3/3] cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB should
 beatomic flags
Message-ID: <20140923131319.GC14905@mtj.dyndns.org>
References: <54210D3F.2090409@huawei.com>
 <54210DA5.4040606@huawei.com>
 <201409231955.FDB73406.FOOJLOVQMHFSFt@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201409231955.FDB73406.FOOJLOVQMHFSFt@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 07:55:48PM +0900, Tetsuo Handa wrote:
> Zefan Li wrote:
> > Tetsuo reported a hard-to-reproduce kernel crash on RHEL6, which happend
> 
> s/happend/happened/
> 
> > @@ -1972,6 +1973,14 @@ static inline void memalloc_noio_restore(unsigned int flags)
> >  TASK_PFA_TEST(NO_NEW_PRIVS, no_new_privs)
> >  TASK_PFA_SET(NO_NEW_PRIVS, no_new_privs)
> >  
> > +TASK_PFA_TEST(SPREAD_PAGE, spread_page)
> > +TASK_PFA_SET(SPREAD_PAGE, spread_page)
> > +TASK_PFA_CLEAR(SPREAD_PAGE, spread_page)
> > +
> > +TASK_PFA_TEST(SPREAD_SLAB, spread_slab)
> > +TASK_PFA_SET(SPREAD_SLAB, spread_slab)
> > +TASK_PFA_CLEAR(SPREAD_SLAB, spread_slab)
> > +
> 
> I wonder how adding 3 macro lines differs from 3 inlined functions.
> Personally, from LXR (source code browser) point of view, inlined functions
> are more friendly than macros. Also, I wonder about the cost of extracting
> macros in a file which is likely included by every file but referenced
> by few files. Speak of SPREAD_PAGE and SPREAD_SLAB, they should be defined
> as inlined functions in include/linux/cpuset.h rather than as macros in
> include/linux/sched.h ?

I think sched.h is fine along w/ inlines for other flags but yeah we
might be better off just open-coding them.

Thanks.

-- 
tejun
