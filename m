Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab3AXKEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:04:42 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:39060 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab3AXKEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:04:40 -0500
Date: Thu, 24 Jan 2013 11:04:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] sched: split out css_online/css_offline from tg
 creation/destruction
Message-ID: <20130124100434.GD26351@gmail.com>
References: <5100D4FE.9080205@huawei.com>
 <5100D518.8000103@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5100D518.8000103@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizefan@huawei.com> wrote:

>  extern struct task_group *sched_create_group(struct task_group *parent);
> +extern void sched_online_group(struct task_group *tg,
> +			       struct task_group *parent);
>  extern void sched_destroy_group(struct task_group *tg);
> +extern void sched_offline_group(struct task_group *tg);

Btw., a rename of these APIs might be in order, along the usual 
patterns:

  sched_task_group_create()
  sched_task_group_online()
  sched_task_group_offline()
  sched_task_group_destroy()

  etc.

that way the naming is more hierarchical and there's no clash 
with the sched_group concept which is about something else.

(In a separate patch.)

Thanks,

	Ingo
