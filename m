Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaFITQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:16:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbaFITQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:16:29 -0400
Date: Mon, 9 Jun 2014 15:15:51 -0400
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, gregkh@linuxfoundation.org, mingo@kernel.org,
        mtk.manpages@gmail.com, torvalds@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: Patch "sched: Disallow sched_attr::sched_policy < 0" has been
 added to the 3.14-stable tree
Message-ID: <20140609191551.GA1422@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	linux-kernel@vger.kernel.org, peterz@infradead.org,
	gregkh@linuxfoundation.org, mingo@kernel.org,
	mtk.manpages@gmail.com, torvalds@linux-foundation.org,
	stable@vger.kernel.org
References: <1402340827594@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402340827594@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 12:07:07PM -0700, gregkh@linuxfoundation.org wrote:
 > 
 > This is a note to let you know that I've just added the patch titled
 > 
 >     sched: Disallow sched_attr::sched_policy < 0
 > 
 > to the 3.14-stable tree which can be found at:
 >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

 > --- a/kernel/sched/core.c
 > +++ b/kernel/sched/core.c
 > @@ -3683,6 +3683,9 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pi
 >  	if (sched_copy_attr(uattr, &attr))
 >  		return -EFAULT;
 >  
 > +	if (attr.sched_policy < 0)
 > +		return -EINVAL;
 > +
 >  	rcu_read_lock();
 >  	retval = -ESRCH;
 >  	p = find_process_by_pid(pid);

Greg,

Make sure you also grab b14ed2c273f8ab872ae4e6735fe5ab09cb14b8c3 to fix this commit.

	Dave

