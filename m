Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160996AbaDSQ7H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 12:59:07 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:48816 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaDSQ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 12:58:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAP=VYLp61h_i+RyuUfowO9CqjV6ohMZ=FSgqQbxv6WQjXR1_6g@mail.gmail.com>
References: <CAF1ivSbZKbDc+rzd+CUqCzNmSgZmZTE-QeSU-2WmSiuEs-Kw_w@mail.gmail.com>
	<20140409194742.GC26782@laptop.programming.kicks-ass.net>
	<20140409200836.GE26782@laptop.programming.kicks-ass.net>
	<CAF1ivSa6_ir0LwiydugzSdEqNoVy7evbb7N6QX_02H32A1dwmw@mail.gmail.com>
	<CAP=VYLp61h_i+RyuUfowO9CqjV6ohMZ=FSgqQbxv6WQjXR1_6g@mail.gmail.com>
Date: Sat, 19 Apr 2014 09:58:41 -0700
Message-ID: <CAF1ivSbqxNAiZw3RNS+BgeQJMVJeUJoCNYCbeeLAYYqG7KNxkw@mail.gmail.com>
Subject: Re: current->sched_class->yield_task is NULL, any hint?
From: Lin Ming <minggr@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2014 at 9:21 AM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> On Wed, Apr 9, 2014 at 5:39 PM, Lin Ming <minggr@gmail.com> wrote:
>> On Wed, Apr 9, 2014 at 1:08 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> [...]
>
>>>>
>>>> Look at that, its calling yield() from a non-preemptible context as
>>>> well.
>>>>
>>>> That code is full of fail.
>>>
>>> *phew* none of that br_igmp_* muck lives in any kernel tree near me so I
>>> can stop worrying :-)
>>
>> It's our internal code.
>
> In the future, please don't simply call it 3.4-rt when there are a bunch of
> vendor/project/SDK patches also applied, as that can be very misleading
> to the people you are asking for help from.  If it is a hybrid franken-kernel
> then please at least indicate that right at the very beginning.

Sorry for the misleading.
I'll make it clear next time.

Thanks.

>
> Paul.
> --
>
>>
>>>
>>> In any case, it wrongly passes a GFP_WAIT along to netlink_broadcast.
>>
>> I'll fix it.
>> Thanks very much.
