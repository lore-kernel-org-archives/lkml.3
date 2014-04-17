Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbaDQHVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 03:21:43 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:61766 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaDQHVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 03:21:41 -0400
Date: Thu, 17 Apr 2014 09:22:03 +0200
From: Juri Lelli <juri.lelli@gmail.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched/deadline: Fix memory leak
Message-Id: <20140417092203.8f4303e41af14832dc37eed6@gmail.com>
In-Reply-To: <534F36CE.2000409@huawei.com>
References: <534F36CE.2000409@huawei.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2014 10:05:02 +0800
Li Zefan <lizefan@huawei.com> wrote:

> Free cpudl->free_cpus allocated in cpudl_init().
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> Cc: <stable@vger.kernel.org> # 3.14
> ---
>  kernel/sched/cpudeadline.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
> index 5b9bb42..ab001b5 100644
> --- a/kernel/sched/cpudeadline.c
> +++ b/kernel/sched/cpudeadline.c
> @@ -210,7 +210,5 @@ int cpudl_init(struct cpudl *cp)
>   */
>  void cpudl_cleanup(struct cpudl *cp)
>  {
> -	/*
> -	 * nothing to do for the moment
> -	 */
> +	free_cpumask_var(cp->free_cpus);
>  }

Thanks!

- Juri
