Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604AbaDIRW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:22:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908AbaDIRW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:22:57 -0400
Date: Wed, 9 Apr 2014 19:23:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3/5] hung_task: Convert process iteration to use
	for_each_process_thread()
Message-ID: <20140409172304.GE27638@redhat.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com> <1397059882-23063-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397059882-23063-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09, Frederic Weisbecker wrote:
>
> @@ -167,18 +167,18 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
>  		return;
>  
>  	rcu_read_lock();
> -	do_each_thread(g, t) {
> +	for_each_process_thread(p, t) {
>  		if (!max_count--)
>  			goto unlock;
>  		if (!--batch_count) {
>  			batch_count = HUNG_TASK_BATCHING;
> -			if (!rcu_lock_break(g, t))
> +			if (!rcu_lock_break(p, t))

Not sure. And in any case this is suboptimal. Frederic, I'll write
another email tomorrow. In fact I already have the patch which changes
check_hung_uninterruptible_tasks() somewhere.

Oleg.

