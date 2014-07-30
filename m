Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbaG3PID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:08:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715AbaG3PH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:07:59 -0400
Date: Wed, 30 Jul 2014 17:06:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, oom: remove unnecessary exit_state check
Message-ID: <20140730150615.GA20659@redhat.com>
References: <alpine.DEB.2.02.1407291638310.858@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407291638310.858@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29, David Rientjes wrote:
>
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -455,6 +455,7 @@ static void exit_mm(struct task_struct * tsk)
>  	task_unlock(tsk);
>  	mm_update_next_owner(mm);
>  	mmput(mm);
> +	clear_thread_flag(TIF_MEMDIE);
>  }
>  
>  /*
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -258,8 +258,6 @@ enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
>  		unsigned long totalpages, const nodemask_t *nodemask,
>  		bool force_kill)
>  {
> -	if (task->exit_state)
> -		return OOM_SCAN_CONTINUE;

IIRC, this check was a workaround, to ensure that a oom-killed zombie
can't block oom-killer.

I think this patch can equally work.

Oleg.

