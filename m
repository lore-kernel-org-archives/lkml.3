Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3LREiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 23:38:22 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:36083 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3LREiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 23:38:20 -0500
MIME-Version: 1.0
In-Reply-To: <87wqj34eqs.fsf@linaro.org>
References: <CAKohponch=o3nBKTmakA87OiN=HbgnEwJUL23mGkjQiNoJWjWw@mail.gmail.com>
	<20131211132212.GA7862@localhost.localdomain>
	<CAKohponKxw8F6djaXaw0MEzGRWGTSQ=peiYuTGBCOHE0VaJR5Q@mail.gmail.com>
	<87wqj34eqs.fsf@linaro.org>
Date: Wed, 18 Dec 2013 10:08:19 +0530
Message-ID: <CAKohpo=Btb8ChRJ4Be9gbDE-nOxSaCVkQ_Qg5g7AVRxOMbXEQQ@mail.gmail.com>
Subject: Re: [Query] Ticks happen in pair for NO_HZ_FULL cores ?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 December 2013 22:05, Kevin Hilman <khilman@linaro.org> wrote:
> For future reference, for generating email friendly trace output for
> discussion like this, you can use something like:
>
>    trace-cmd report --cpu=1 trace.dat

Okay..

>> And after that the next event comes after 5 Seconds.
>>
>> And so I was talking for the Event 41.
>
> That first event (Event 41) is an interrupt, and comes from the
> scheduler tick.  The tick is happening because the writeback workqueue
> just ran and we're not in NO_HZ mode.

This is what I was trying to ask. Why can't we enter in NO_HZ_FULL mode
as soon as writeback workqueue just ran? That way we can go into NOHZ
mode earlier..

> However, as soon as that IRQ (and resulting softirqs) are finished, we
> enter NO_HZ mode again.  But as you mention, it only lasts for ~5 sec
> when the timer fires again.  Once again, it fires because of the
> writeback workqueue, and soon therafter it switches back to NO_HZ mode
> again.

That's fine.. It wasn't part of my query :) .. But yes your trick
would be useful
for my usecase :)
