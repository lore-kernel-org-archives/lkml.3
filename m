Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab3BOXbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 18:31:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3BOXbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 18:31:01 -0500
Date: Fri, 15 Feb 2013 15:30:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 3/5] coredump: cleanup the waiting for coredump_finish
 code
Message-Id: <20130215153059.8ac35241.akpm@linux-foundation.org>
In-Reply-To: <1360885096-21207-3-git-send-email-msb@chromium.org>
References: <1360885096-21207-1-git-send-email-msb@chromium.org>
	<1360885096-21207-3-git-send-email-msb@chromium.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2013 15:38:14 -0800
Mandeep Singh Baines <msb@chromium.org> wrote:

> Replace the for loop with a simple if.

Well OK, but why?  Presumably the loop was added for a reason and
presumably you believe that reason to be (no longer?) correct.  Please
describe all these things.

> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -479,12 +479,9 @@ static void exit_mm(struct task_struct * tsk)
>  		if (atomic_dec_and_test(&core_state->nr_threads))
>  			complete(&core_state->startup);
>  
> -		for (;;) {
> -			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
> -			if (!self.task) /* see coredump_finish() */
> -				break;
> +		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
> +		if (self.task) /* see coredump_finish() */
>  			schedule();
> -		}


