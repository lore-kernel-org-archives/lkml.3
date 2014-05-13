Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaEMSv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:51:29 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:47150 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaEMSvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:51:21 -0400
Message-ID: <53725C62.1060809@gmail.com>
Date: Tue, 13 May 2014 19:54:42 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@gmail.com>
CC: mtk.manpages@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Dario Faggioli <raistlin@linux.it>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [SCHED_DEADLINE man pages 2/2] sched(7) SCHED_DEADLINE
References: <53723235.40101@gmail.com>	<537233A9.6040102@gmail.com> <20140513175210.49eed2e34ac06a3c109ce963@gmail.com>
In-Reply-To: <20140513175210.49eed2e34ac06a3c109ce963@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Juri,

On 05/13/2014 05:52 PM, Juri Lelli wrote:
> Hello,
> 
> On Tue, 13 May 2014 17:00:57 +0200
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:
> 
>> Hello Peter et al.
>>
>> Here is the section of the sched(7) page that describes SCHED_DEADLINE,
>> as rendered text, with the (entire) raw page source attached. Please 
>> carefully review.
>>
>> Cheers,
>>
>> Michael

[...]

>>        The following diagram clarifies these terms:
>>
>>            arrival/wakeup                   absolute deadline
>>                 |    start time                   |
>>                 |        |                        |
>>                 v        v                        v
>>            -----x--------xooooooooooooooooo-------x--------x---
>>                          |<- comp. time ->|
>>                 |<------- relative deadline ----->|
>>                 |<-------------- period ------------------>|
>>
>>        When  setting  a  SCHED_DEADLINE  policy  for  a thread using
>>        sched_setattr(2), one can specify three parameters:  Runtime,
>>        Deadline,  and  Period.   These parameters do not necessarily
>>        correspond to the aforementioned terms: usual practice is  to
>>        set  Runtime to something bigger than the average computation
>>        time (or worst-case execution time for hard real-time tasks),
>>        Deadline  to  the relative deadline, and Period to the period
>>        of the task.  Thus, for SCHED_DEADLINE scheduling, we have:
>>
>>            arrival/wakeup                   absolute deadline
>>                 |    start time                   |
>>                 |        |                        |
>>                 v        v                        v
>>            -----x--------xooooooooooooooooo-------x--------x---
>>                          |<-- Runtime --->|
> 
>                            |<-- Runtime   --->|
> 
> I originally drew this slightly bigger than comp. time above because we
> usually don't want tasks to be throttled in the average case. It's just
> a rule of thumb.

Ahh -- yes, I see now that I messed this up when I tweaked the
ASCII art. Thanks for catching that. Fixed now.

>>                 |<----------- Deadline ---------->|
>>                 |<-------------- Period ------------------>|
>>
>>        The three deadline-scheduling parameters  correspond  to  the
>>        sched_runtime, sched_deadline, and sched_period fields of the
>>        sched_attr structure;  see  sched_setattr(2).   These  fields
>>        express  value  in nanoseconds.  If sched_period is specified
>>        as 0, then it is made the same as sched_deadline.
>>
>>        The kernel requires that:
>>
>>            sched_runtime <= sched_deadline <= sched_period
>>
>>        In addition, under the current  implementation,  all  of  the
>>        parameter  values  must be at least 1024 (i.e., just over one
>>        microsecond, which is the resolution of the  implementation).
> 
> And below 2^63, as per the last bug fix we discussed.

Fixed.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
