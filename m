Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbaDSQWF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 12:22:05 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:51707 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbaDSQWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 12:22:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAF1ivSa6_ir0LwiydugzSdEqNoVy7evbb7N6QX_02H32A1dwmw@mail.gmail.com>
References: <CAF1ivSbZKbDc+rzd+CUqCzNmSgZmZTE-QeSU-2WmSiuEs-Kw_w@mail.gmail.com>
 <20140409194742.GC26782@laptop.programming.kicks-ass.net> <20140409200836.GE26782@laptop.programming.kicks-ass.net>
 <CAF1ivSa6_ir0LwiydugzSdEqNoVy7evbb7N6QX_02H32A1dwmw@mail.gmail.com>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Sat, 19 Apr 2014 12:21:28 -0400
X-Google-Sender-Auth: acQ-AP7bb8xHE4j_gdS5wZHiRWE
Message-ID: <CAP=VYLp61h_i+RyuUfowO9CqjV6ohMZ=FSgqQbxv6WQjXR1_6g@mail.gmail.com>
Subject: Re: current->sched_class->yield_task is NULL, any hint?
To: Lin Ming <minggr@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 5:39 PM, Lin Ming <minggr@gmail.com> wrote:
> On Wed, Apr 9, 2014 at 1:08 PM, Peter Zijlstra <peterz@infradead.org> wrote:

[...]

>>>
>>> Look at that, its calling yield() from a non-preemptible context as
>>> well.
>>>
>>> That code is full of fail.
>>
>> *phew* none of that br_igmp_* muck lives in any kernel tree near me so I
>> can stop worrying :-)
>
> It's our internal code.

In the future, please don't simply call it 3.4-rt when there are a bunch of
vendor/project/SDK patches also applied, as that can be very misleading
to the people you are asking for help from.  If it is a hybrid franken-kernel
then please at least indicate that right at the very beginning.

Paul.
--

>
>>
>> In any case, it wrongly passes a GFP_WAIT along to netlink_broadcast.
>
> I'll fix it.
> Thanks very much.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
