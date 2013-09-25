Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751031Ab3IYEKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 00:10:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3IYEKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 00:10:41 -0400
Date: Tue, 24 Sep 2013 21:10:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH tip/core/rcu 01/11] mm: Place preemption point in
 do_mlockall() loop
Message-Id: <20130924211047.57f9d9c8.akpm@linux-foundation.org>
In-Reply-To: <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925012750.GA30601@linux.vnet.ibm.com>
	<1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Sep 2013 18:29:11 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -736,6 +736,7 @@ static int do_mlockall(int flags)
>  
>  		/* Ignore errors */
>  		mlock_fixup(vma, &prev, vma->vm_start, vma->vm_end, newflags);
> +		cond_resched();
>  	}
>  out:
>  	return 0;

Might need one in munlock_vma_pages_range() as well - it's a matter of
finding the right test case.  This will be neverending :(
