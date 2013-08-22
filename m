Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3HVS3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 14:29:34 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:33832 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab3HVS3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 14:29:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130822181536.GA22995@redhat.com>
References: <20130822170939.GA20296@redhat.com> <20130822171004.GA20324@redhat.com>
 <CALCETrU9D59MqxPm2SNegPFH_+gpPfoQJkD2E2Q8zjJ94QhLDg@mail.gmail.com> <20130822181536.GA22995@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 Aug 2013 11:29:12 -0700
Message-ID: <CALCETrW3gnXjUqvm-jNZq6k_qSnTN5=VNRCp+gNC+t2YtBBMYQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] fork: unify and tighten up CLONE_NEWUSER/CLONE_NEWPID checks
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Brad Spengler <spender@grsecurity.net>,
        Colin Walters <walters@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 11:15 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/22, Andy Lutomirski wrote:
>>
>> On Thu, Aug 22, 2013 at 10:10 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> > do_fork() denies CLONE_THREAD | CLONE_PARENT if NEWUSER | NEWPID.
>> >
>> > Then later copy_process() denies CLONE_SIGHAND if the new process
>> > will be in a different pid namespace (task_active_pid_ns() doesn't
>> > match current->nsproxy->pid_ns).
>> >
>> > This looks confusing and inconsistent. CLONE_NEWPID is very similar
>> > to the case when ->pid_ns was already unshared, we want the same
>> > restrictions so copy_process() should also nack CLONE_PARENT.
>> >
>> > And it would be better to deny CLONE_NEWUSER && CLONE_SIGHAND as
>> > well just for consistency.
>> >
>> > Kill the "CLONE_NEWUSER | CLONE_NEWPID" check in do_fork() and
>> > change copy_process() to the same check along with nsproxy->pid_ns
>> > we already have.
>>
>> Did the old code actually prevent clone(CLONE_PARENT | CLONE_NEWPID)?
>> The new code explicitly does, and that looks like a good thing.
>
>
> Yes. Before this patch do_fork() did:
>
>         if (clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) {
>                 if (clone_flags & (CLONE_THREAD|CLONE_PARENT))
>                         return -EINVAL;
>         }
>
> however, let me repeat, CLONE_PARENT after unshare(CLONE_NEWPID) was
> allowed. With this patch CLONE_PARENT is nacked in both cases.
>

Is this -stable-worthy?

--Andy


> Oleg.
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
