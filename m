Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031138Ab3DSQn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:43:26 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50257 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031065Ab3DSQnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:43:22 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXjTGSG+tejOAFgXr8EpKd7dL=-W41ha_-0N=roAxN3eg@mail.gmail.com>
References: <CA+icZUVWC+Rgd9wh4Z4CPZkEa9Pm2=2udnY5=UD1nnH0Wot1pQ@mail.gmail.com>
	<CAKMK7uFEaiT_1siQBcp_-S0RwLvy3XSjqLn1ksq70VhNTZSfLw@mail.gmail.com>
	<CA+icZUWQEiGecR8jgw4P-2YCKyqSDMMP0Ufwn8aBU_-AOf0a-Q@mail.gmail.com>
	<CA+icZUWcwvFFVesJDoFNT3DbgRMXvDp7QLn+S5Ze_5d8gJRx1g@mail.gmail.com>
	<CA+icZUXjTGSG+tejOAFgXr8EpKd7dL=-W41ha_-0N=roAxN3eg@mail.gmail.com>
Date: Fri, 19 Apr 2013 18:43:20 +0200
Message-ID: <CA+icZUVE-ikxEp65bUHMp0WEPX_MDbA06ykzeSxygJv=9f45ig@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 18 [ call-trace: drm | x86 | smp | rcu
 related? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Paul McKenney <paul.mckenney@linaro.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 12:27 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Fri, Apr 19, 2013 at 12:19 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Thu, Apr 18, 2013 at 11:59 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> On Thu, Apr 18, 2013 at 9:48 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>>>> On Thu, Apr 18, 2013 at 3:05 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>>> On Thu, Apr 18, 2013 at 10:28 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>>>> Hi all,
>>>>>>
>>>>>> Changes since 20130417:
>>>>>>
>>>>>> New Trees:      rpmsg (actually added yesterday)
>>>>>>                 ppc-temp (replacing powerpc for this week)
>>>>>>
>>>>>> The ceph tree gained a conflict against Linus' tree.
>>>>>>
>>>>>> The net-next tree gained a conflict against the infiniband tree.
>>>>>>
>>>>>> The usb tree gained a build failure so I used the version from
>>>>>> next-20130417.
>>>>>>
>>>>>> I added two merge fix patches after the gen-gpio tree.
>>>>>>
>>>>>> The ppc-temp tree gained a conflict against the metag tree.
>>>>>>
>>>>>> The akpm tree lost a patch that turned up elsewhere.
>>>>>>
>>>>>> ----------------------------------------------------------------------------
>>>>>>
>>>>>
>>>>> Not sure what the root-cause for this call-trace is (see screenshot).
>>>>>
>>>>> This is reproducible when running my kernel build-script (4 parallel-make-jobs).
>>>>>
>>>>> Any hints welcome!
>>>>
>>>> The panic handlers in our modeset code are pretty decent fubar - they
>>>> take mutexes all over the place. So I think the backtrace you see
>>>> there is actually a secondary effect. I've looked into fixing this up,
>>>> but the issue is that drivers themselves have tons of state protected
>>>> with mutexes, which all potentially affects the panic handler. So I've
>>>> given up on that for now ...
>>>
>>> Thanks for taking care.
>>>
>>> On suspicion [1] I have reverted [2]... NOPE.
>>>
>>> - Sedat -
>>>
>>> [1] http://marc.info/?l=linux-kernel&m=136631921208895&w=2
>>> [2] http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=5a90d1a95356de7a32acb2e5309ac579a891af8f
>>>
>>
>> Hmmm, the issue seems to be gone with today's Linux-Next (next-20130419).
>> My kernel-build is still running with no call-trace...
>>
>
> NO, It's no good.
>

I tried to switch from SLUB to SLAB...

...and also from VIRT_CPU_ACCOUNTING_GEN to TICK_CPU_ACCOUNTING.

2x NOPE.

In one kernel-build I saw in my console...

     semop(1): encountered an error: Identifier removed

...if this says sth. to you.

- Sedat -

- Sedat -

> - Sedat -
>
> [1] http://www.youtube.com/watch?v=LwicaralvS0
>
>> - Sedat -
>>
>>>> -Daniel
>>>> --
>>>> Daniel Vetter
>>>> Software Engineer, Intel Corporation
>>>> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
