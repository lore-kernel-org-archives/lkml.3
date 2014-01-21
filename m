Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbaAUGt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 01:49:56 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:35362 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaAUGtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 01:49:47 -0500
Message-ID: <52DE1883.2070304@linux.vnet.ibm.com>
Date: Tue, 21 Jan 2014 14:49:39 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@linaro.org>, mingo@redhat.com, peterz@infradead.org,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, efault@gmx.de
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] sched/update_avg: avoid negative time
References: <1390282399-17091-1-git-send-email-alex.shi@linaro.org>
In-Reply-To: <1390282399-17091-1-git-send-email-alex.shi@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012106-7014-0000-0000-000004355BCB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alex

On 01/21/2014 01:33 PM, Alex Shi wrote:
> rq->avg_idle try to reflect the average idle time between the cpu idle
> and first wakeup. But in the function, it maybe get a negative value
> if old avg_idle is too small. Then this negative value will be double
> counted in next time calculation. Guess that is not the original purpose,
> so recalibrate it to zero.
> 
> Signed-off-by: Alex Shi <alex.shi@linaro.org>
> ---
>  kernel/sched/core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 30eb011..af9121c6 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1358,6 +1358,9 @@ static void update_avg(u64 *avg, u64 sample)
>  {
>  	s64 diff = sample - *avg;
>  	*avg += diff >> 3;
> +
> +	if (*avg < 0)
> +		*avg = 0;

This seems like won't happen...

if 'diff' is negative, it's absolute value won't bigger than '*avg', not
to mention we only use 1/8 of it.

Regards,
Michael Wang

>  }
>  #endif
> 

