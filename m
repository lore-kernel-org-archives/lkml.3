Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763219Ab3DCJ1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:27:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763202Ab3DCJ1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:27:02 -0400
Date: Wed, 3 Apr 2013 11:26:59 +0200
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, jack@suse.cz,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/3] kthread: implement probe_kthread_data()
Message-ID: <20130403092659.GE7999@quack.suse.cz>
References: <1364612447-6810-1-git-send-email-tj@kernel.org>
 <1364612447-6810-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364612447-6810-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 29-03-13 20:00:45, Tejun Heo wrote:
> Implement probe_kthread_data() which returns kthread_data if
> accessible.  The function is equivalent to kthread_data() except that
> the specified @task may not be a kthread or its vfork_done is already
> cleared rendering struct kthread inaccessible.  In the former case,
> probe_kthread_data() may return any value.  In the latter, NULL.
> 
> This will be used to safely print debug information without affecting
> synchronization in the normal paths.  Workqueue debug info printing on
> dump_stack() and friends will make use of it.
  Thanks for looking into this. Just one typo correction below:

> @@ -122,6 +123,24 @@ void *kthread_data(struct task_struct *task)
>  	return to_kthread(task)->data;
>  }
>  
> +/**
> + * probe_kthread_data - speculatively version of kthread_data()
                                   ^^^^ speculative

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
