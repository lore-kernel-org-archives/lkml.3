Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab3LQKfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 05:35:32 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:46537 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3LQKfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 05:35:30 -0500
MIME-Version: 1.0
In-Reply-To: <20131211132212.GA7862@localhost.localdomain>
References: <CAKohponch=o3nBKTmakA87OiN=HbgnEwJUL23mGkjQiNoJWjWw@mail.gmail.com>
	<20131211132212.GA7862@localhost.localdomain>
Date: Tue, 17 Dec 2013 16:05:29 +0530
Message-ID: <CAKohponKxw8F6djaXaw0MEzGRWGTSQ=peiYuTGBCOHE0VaJR5Q@mail.gmail.com>
Subject: Re: [Query] Ticks happen in pair for NO_HZ_FULL cores ?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Kevin Hilman <khilman@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay, was on holidays..

On 11 December 2013 18:52, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Tue, Dec 03, 2013 at 01:57:37PM +0530, Viresh Kumar wrote:
>> - again got arch_timer interrupt after 5 ms (HZ=200)
>
> Right, looking at the details, the 2nd interrupt is caused by workqueue delayed
> work bdi writeback.

I am not that great at reading traces or kernelshark output, but I
still feel I haven't
seen anything wrong. And I wasn't talking about the delayed workqueue here..

I am looking at the trace I attached with kernelshark after filtering
out CPU0 events:
- Event 41, timestamp: 159.891973
- it ends at event 56, timestamp: 159.892043

And after that the next event comes after 5 Seconds.

And so I was talking for the Event 41.

>> So the query is: why don't we check that at the end of servicing vmstat
>> stuff and migrating back to "stress" ??
>
> I fear I don't understand your question. Do you mean why don't we prevent from
> that bdi writeback work to run when we are in full dynticks mode?

No..
