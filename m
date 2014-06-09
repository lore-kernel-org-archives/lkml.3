Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaFIT2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:28:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbaFIT23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:28:29 -0400
Date: Mon, 9 Jun 2014 12:32:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org, mtk.manpages@gmail.com,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Subject: Re: Patch "sched: Disallow sched_attr::sched_policy < 0" has been
 added to the 3.14-stable tree
Message-ID: <20140609193216.GA28115@kroah.com>
References: <1402340827594@kroah.com>
 <20140609191551.GA1422@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609191551.GA1422@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 03:15:51PM -0400, Dave Jones wrote:
> On Mon, Jun 09, 2014 at 12:07:07PM -0700, gregkh@linuxfoundation.org wrote:
>  > 
>  > This is a note to let you know that I've just added the patch titled
>  > 
>  >     sched: Disallow sched_attr::sched_policy < 0
>  > 
>  > to the 3.14-stable tree which can be found at:
>  >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
>  > --- a/kernel/sched/core.c
>  > +++ b/kernel/sched/core.c
>  > @@ -3683,6 +3683,9 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pi
>  >  	if (sched_copy_attr(uattr, &attr))
>  >  		return -EFAULT;
>  >  
>  > +	if (attr.sched_policy < 0)
>  > +		return -EINVAL;
>  > +
>  >  	rcu_read_lock();
>  >  	retval = -ESRCH;
>  >  	p = find_process_by_pid(pid);
> 
> Greg,
> 
> Make sure you also grab b14ed2c273f8ab872ae4e6735fe5ab09cb14b8c3 to fix this commit.

Ah, missed that one, thanks for pointing it out, now applied.

greg k-h
