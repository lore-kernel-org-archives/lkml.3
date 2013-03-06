Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab3CFKb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:31:29 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:62989 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab3CFKb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:31:26 -0500
Date: Wed, 6 Mar 2013 11:31:20 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] perf: remove include of cgroup.h from perf_event.h
Message-ID: <20130306103120.GA16827@gmail.com>
References: <513568A0.6020804@huawei.com>
 <CABPqkBTTn6E=FS6WiCWopcScHDVa9F6bu5-pw8Ma7TK2aunkvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTTn6E=FS6WiCWopcScHDVa9F6bu5-pw8Ma7TK2aunkvQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> > - * This is a per-cpu dynamically allocated data structure.
> > - */
> > -struct perf_cgroup_info {
> > -       u64                             time;
> > -       u64                             timestamp;
> > -};
> > -
> > -struct perf_cgroup {
> > -       struct                          cgroup_subsys_state css;
> > -       struct                          perf_cgroup_info *info; /* timing info, one per cpu */
> > -};
> > -#endif
> > -
> > +struct perf_cgroup;
> 
> The problem is that you have struct perf_cgroup in the struct perf_event 
> structure. Today, this field is not referenced outside of kernel/events/core.c But 
> it is available outside this file. If someday the field is reference, your changes 
> will have to do reverted. So I am wondering what is the point of the change right 
> now?

It's standard practice to not define the type for task_struct or other kernel 
subsystems.

For example slab caches can be created via kmem_cache_create() anywhere in the tree, 
but the internal structure is only known to the SLAB subsystem.

Thanks,

	Ingo
