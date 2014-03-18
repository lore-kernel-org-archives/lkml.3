Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaCRIJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:09:32 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:64854 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaCRIJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:09:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomHXLVKqzFCbp8qt7gGpdDkc-s5wASRvw1EBwuB_fpceA@mail.gmail.com>
References: <c439f5b6bbc2047e1662f4d523350531425bcf9d.1393576981.git.viresh.kumar@linaro.org>
	<9144e10d7e854a0aa8a673332adec356d81a923c.1393576981.git.viresh.kumar@linaro.org>
	<alpine.DEB.2.02.1402281151180.18573@ionos.tec.linutronix.de>
	<CAKohpomHXLVKqzFCbp8qt7gGpdDkc-s5wASRvw1EBwuB_fpceA@mail.gmail.com>
Date: Tue, 18 Mar 2014 13:39:28 +0530
Message-ID: <CAKohpo=g4nhRUN7wJY-fpE1TiQWEDExKpZ1p4C8gUEDK8mXZ_Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] timer: Make sure TIMER_FLAG_MASK bits are free in
 allocated base
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 March 2014 15:56, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Hi Thomas,
>
> On 28 February 2014 18:52, Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Fri, 28 Feb 2014, Viresh Kumar wrote:
>>
>>> Currently we are using two lowest bit of base for internal purpose and so they
>>> both should be zero in the allocated address. The code was doing the right thing
>>> before this patch came in:
>>>
>>> commit c5f66e99b7cb091e3d51ae8e8156892e8feb7fa3
>>> Author: Tejun Heo <tj@kernel.org>
>>> Date:   Wed Aug 8 11:10:28 2012 -0700
>>>
>>>     timer: Implement TIMER_IRQSAFE
>>>
>>> Tejun probably forgot to update this piece of code which checks if the lowest
>>> 'n' bits are zero or not and so wasn't updated according to the new flag. Lets
>>> use TIMER_FLAG_MASK in the calculations here, so that this code wouldn't require
>>> a change later on with another flag in.
>>
>> Are you planning to introduce more flag horror? Don't go there. The
>> timer_list code is about to be rewritten completely and I'm not going
>> to add new features to the existing code base.
>
> Do you already have stuff prepared that can be shared on that? I am asking
> because I am working on some CPU isolation stuff for Networking domain and
> it looks like I need to add another of these flags :( .. I know its
> just not acceptable
> and so wanted your thoughts on how can I get things fixed.
>
> Peter asked me to implement something like cpuset.quiesce to move away all
> timers/workqueues/etc from a cpuset. It was proposed here:
>
> https://lkml.org/lkml/2014/1/15/186
>
> Now, I was looking to migrate away the timers first but I obviously
> shouldn't migrate
> the pinned timers. One way out to identify PINNED timers is to mark them PINNED
> with the flag bits, which you wouldn't allow. Can you give some other idea with
> which I can get this solved.

Ping!!
