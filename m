Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3LRNvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:51:20 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:59305 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430Ab3LRNvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:51:19 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [Query] Ticks happen in pair for NO_HZ_FULL cores ?
References: <CAKohponch=o3nBKTmakA87OiN=HbgnEwJUL23mGkjQiNoJWjWw@mail.gmail.com>
	<20131211132212.GA7862@localhost.localdomain>
	<CAKohponKxw8F6djaXaw0MEzGRWGTSQ=peiYuTGBCOHE0VaJR5Q@mail.gmail.com>
	<87wqj34eqs.fsf@linaro.org>
	<CAKohpo=Btb8ChRJ4Be9gbDE-nOxSaCVkQ_Qg5g7AVRxOMbXEQQ@mail.gmail.com>
Date: Wed, 18 Dec 2013 05:51:16 -0800
In-Reply-To: <CAKohpo=Btb8ChRJ4Be9gbDE-nOxSaCVkQ_Qg5g7AVRxOMbXEQQ@mail.gmail.com>
	(Viresh Kumar's message of "Wed, 18 Dec 2013 10:08:19 +0530")
Message-ID: <87r49al12j.fsf@linaro.org>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh Kumar <viresh.kumar@linaro.org> writes:

> On 17 December 2013 22:05, Kevin Hilman <khilman@linaro.org> wrote:
>> For future reference, for generating email friendly trace output for
>> discussion like this, you can use something like:
>>
>>    trace-cmd report --cpu=1 trace.dat
>
> Okay..
>
>>> And after that the next event comes after 5 Seconds.
>>>
>>> And so I was talking for the Event 41.
>>
>> That first event (Event 41) is an interrupt, and comes from the
>> scheduler tick.  The tick is happening because the writeback workqueue
>> just ran and we're not in NO_HZ mode.
>
> This is what I was trying to ask. Why can't we enter in NO_HZ_FULL mode
> as soon as writeback workqueue just ran? That way we can go into NOHZ
> mode earlier..

Ah, I see.  So you're basically asking why we can't evaluate whether to
turn off the tick more often, for example right after the workqueues are
done.  I suppose Frederic may have some views on that, but there's
likely additional overhead from those checks as well as that workqueues
may not be the only thing keeping us out of NO_HZ.

Kevin

