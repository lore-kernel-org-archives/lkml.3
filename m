Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab3HVTLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 15:11:53 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:33698 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab3HVTLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 15:11:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130822183250.GA23769@redhat.com>
References: <20130822170939.GA20296@redhat.com> <20130822171004.GA20324@redhat.com>
 <CALCETrU9D59MqxPm2SNegPFH_+gpPfoQJkD2E2Q8zjJ94QhLDg@mail.gmail.com>
 <20130822181536.GA22995@redhat.com> <CALCETrW3gnXjUqvm-jNZq6k_qSnTN5=VNRCp+gNC+t2YtBBMYQ@mail.gmail.com>
 <20130822183250.GA23769@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 Aug 2013 12:11:31 -0700
Message-ID: <CALCETrVT4r3G9tQpt4y22iB+y-fw5piH93OOn9wfvSd8xQdDBw@mail.gmail.com>
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

On Thu, Aug 22, 2013 at 11:32 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/22, Andy Lutomirski wrote:
>>
>> On Thu, Aug 22, 2013 at 11:15 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >
>> > Yes. Before this patch do_fork() did:
>> >
>> >         if (clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) {
>> >                 if (clone_flags & (CLONE_THREAD|CLONE_PARENT))
>> >                         return -EINVAL;
>> >         }
>> >
>> > however, let me repeat, CLONE_PARENT after unshare(CLONE_NEWPID) was
>> > allowed. With this patch CLONE_PARENT is nacked in both cases.
>>
>> Is this -stable-worthy?
>
> Honestly, I do not know. I do not want to abuse -stable, and I will
> sleep better if this patch won't go into the stable trees ;)
>
> OTOH, I think that at least 1/3 is probably -stable material... Since
> I am going to send v2, I would not mind to add stable@vger.kernel.org
> if both you and Eric agree.

This may allow creation of a process with tgid and pid in different
pid namespaces.  If so, I have no idea what the consequences would be.

>
> Oleg.
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
