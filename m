Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3INFyE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 01:54:04 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:47475 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab3INFyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 01:54:02 -0400
Date: Sat, 14 Sep 2013 07:53:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hung_task: change sysctl_hung_task_check_count to int
Message-ID: <20130914055359.GB364@gmail.com>
References: <5233CE5E.7040004@huawei.com>
 <5233CFBF.4000803@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5233CFBF.4000803@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizefan@huawei.com> wrote:

> Cc: Ingo, as this touched include/linux/sched/.
> 
> On 2013/9/14 10:47, Li Zefan wrote:
> > As sysctl_hung_task_check_count is unsigned long, when this value is
> > assigned to max_count in check_hung_uninterruptible_tasks(), it's
> > truncated to int type.
> > 
> > Therefore if we write 2^32 to sysctl.hung_task_check_count, hung task
> > detection will be effectively disabled.
> > 
> > Not a big deal, but still it's better to fix this inconsistency.
> > 
> > Signed-off-by: Li Zefan <lizefan@huawei.com>
> > ---
> >  include/linux/sched/sysctl.h | 2 +-
> >  kernel/hung_task.c           | 2 +-
> >  kernel/sysctl.c              | 4 ++--
> >  3 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
> > index bf8086b..9552afa 100644
> > --- a/include/linux/sched/sysctl.h
> > +++ b/include/linux/sched/sysctl.h
> > @@ -2,8 +2,8 @@
> >  #define _SCHED_SYSCTL_H
> >  
> >  #ifdef CONFIG_DETECT_HUNG_TASK
> > +extern int	     sysctl_hung_task_check_count;
> >  extern unsigned int  sysctl_hung_task_panic;
> > -extern unsigned long sysctl_hung_task_check_count;
> >  extern unsigned long sysctl_hung_task_timeout_secs; extern unsigned 
> >  long sysctl_hung_task_warnings; extern int 
> >  proc_dohung_task_timeout_secs(struct ctl_table *table, int write,

Looks good, but I suppose most of the unsigned longs above ought to be 
downgraded to int as well?

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
