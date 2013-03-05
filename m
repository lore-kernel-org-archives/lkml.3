Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab3CEGYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 01:24:05 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:58195 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab3CEGYC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 01:24:02 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAKgNAkjYmvjMzC+nYqsjHf4bQn2ZwdE5wawoP2p32ZSo+0dfcQ@mail.gmail.com>
References: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
 <1362110504.15531.4@driftwood> <CAKgNAkgVKnhRT1Lpq4a_UdBKB+tn6XmWSDF2QJXG0aSLtNH6dg@mail.gmail.com>
 <87wqtr3zg5.fsf@xmission.com> <CAKgNAkjGD0FdQqpA+rYR=+Yc5uVPB8mE5JjCqy-5WS85cPsvng@mail.gmail.com>
 <87k3pnhx2k.fsf@xmission.com> <CAKgNAkjYmvjMzC+nYqsjHf4bQn2ZwdE5wawoP2p32ZSo+0dfcQ@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Tue, 5 Mar 2013 07:23:41 +0100
Message-ID: <CAKgNAkgQ2g+6OwExdJ8imsbi5yXJwbpnOVta_YR6DsuVmmr-UA@mail.gmail.com>
Subject: Re: For review: pid_namespaces(7) man page
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rob Landley <rob@landley.net>, linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resending, since my mobile device turned things into HTML]

Eric,

On Mon, Mar 4, 2013 at 6:52 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>
>> On Fri, Mar 1, 2013 at 4:35 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>>
>>>> Hi Rob,
>>>>
>>>> On Fri, Mar 1, 2013 at 5:01 AM, Rob Landley <rob@landley.net> wrote:
>>>>> On 02/28/2013 05:24:07 AM, Michael Kerrisk (man-pages) wrote:
[...]
>>>>>> Because the above unshare(2) and setns(2) calls only change the
>>>>>> PID namespace for created children, the clone(2) calls neces‐
>>>>>> sarily put the new thread in a different PID namespace from the
>>>>>> calling thread.
>>>>>
>>>>>
>>>>> Um, no they don't. They fail. That's the point.
>>>>
>>>> (Good catch.)
>>>>
>>>>> They _would_ put the new
>>>>> thread in a different PID namespace, which breaks the definition of threads.
>>>>>
>>>>> How about:
>>>>>
>>>>> The above unshare(2) and setns(2) calls change the PID namespace of
>>>>> children created by subsequent clone(2) calls, which is incompatible
>>>>> with CLONE_VM.
>>>>
>>>> I decided on:
>>>>
>>>> The point here is that unshare(2) and setns(2) change the PID
>>>> namespace for created children but not for the calling process,
>>>> while clone(2) CLONE_VM specifies the creation of a new thread
>>>> in the same process.
>>>
>>> Can we make that "for all new tasks created" instead of "created
>>> children"
>>>
>>> Othewise someone might expect CLONE_THREAD would work as you
>>> CLONE_THREAD creates a thread and not a child...
>>
>> The term "task" is kernel-space talk that rarely appears in man pages,
>> so I am reluctant to use it.
>
> With respect to clone and in this case I am not certain we can properly
> describe what happens without talking about tasks. But it is worth
> a try.
>
>
>> How about this:
>>
>> The point here is that unshare(2) and setns(2) change the PID
>> namespace for processes subsequently created by the caller, but
>> not for the calling process, while clone(2) CLONE_VM specifies
>> the creation of a new thread in the same process.
>
> Hmm. How about this.
>
> The point here is that unshare(2) and setns(2) change the PID
> namespace that will be used by in all subsequent calls to clone
> and fork by the caller, but not for the calling process, and
> that all threads in a process must share the same PID
> namespace. Which makes a subsequent clone(2) CLONE_VM
> specify the creation of a new thread in the a different PID
> namespace but in the same process which is impossible.

I did a little tidying:

The point here is that unshare(2) and setns(2) change the
PID namespace that will be used in all subsequent calls
to clone(2) and fork(2), but do not change the PID names‐
pace of the calling process. Because a subsequent
clone(2) CLONE_VM would imply the creation of a new
thread in a different PID namespace, the operation is not
permitted.

Okay?

Having asked that, I realize that I'm still not quite comfortable with
this text. I think the problem is really one of terminology. At the
start of this passage in the page, there is the sentence:

Every thread in a process must be in the
same PID namespace.

Can you define "thread" in this context?

Thanks,

Michael
