Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbaCEOi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:38:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbaCEOiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:38:54 -0500
Date: Wed, 5 Mar 2014 15:38:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, venki@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
Message-ID: <20140305143800.GA29480@redhat.com>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <20140304135624.GA6846@redhat.com> <53161116.9050109@oracle.com> <20140304190348.GA22075@redhat.com> <5316343B.2030404@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5316343B.2030404@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Khalid Aziz wrote:
>
> On 03/04/2014 12:03 PM, Oleg Nesterov wrote:
>>
>> 	1. mremap() can move this vma, so do_exit() can't trust ->uaddr
>>
>> 	2. Even worse, mremap() itself is not safe. It can do ->close()
>> 	   too and create the new vma with the same vm_ops. Another
>> 	   unmap from (say) exit_mm() won't be happy.
>
> I agree this looks like a potential spot for trouble. I was asking if
> removing sys_munmap() of uaddr from do_exit() solves both of the above
> problems?

How? Of course this won't solve the problems. And there are more problems.

> You have convinced me this sys_munmap() I added is unnecessary.

Cough ;) I didn't try to convince you that it should be removed. It is
necessary (but of course you should not use sys_munmap(), say vm_munmap
is better.

But you know, I think this all doesn't matter. Imho, this proc/mmap
interface is horrible. Perhaps something like tls area visible to kernel
make sense, but it should be more generic at least.

You added /proc/sched_preempt_delay to avoid the syscall. I think it
would be better to simply add vdso_sched_preempt_delay() instead.


But the main problem, of course, is that this feature is questionable.

Oleg.

