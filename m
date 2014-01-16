Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaAPPuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:50:51 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:54139 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaAPPun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:50:43 -0500
Message-ID: <52D7FFCE.1030108@linaro.org>
Date: Thu, 16 Jan 2014 16:50:38 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: raistlin@linux.it, juri.lelli@gmail.com, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
References: <52D64676.4040000@linaro.org> <20140115120418.GD31570@twins.programming.kicks-ass.net> <52D7E343.40909@linaro.org> <20140116141743.GT31570@twins.programming.kicks-ass.net> <52D7EAA4.2080208@linaro.org> <20140116142546.GU31570@twins.programming.kicks-ass.net> <52D7ED0A.2030502@linaro.org> <20140116154239.GR7572@laptop.programming.kicks-ass.net>
In-Reply-To: <20140116154239.GR7572@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 04:42 PM, Peter Zijlstra wrote:
> On Thu, Jan 16, 2014 at 03:30:34PM +0100, Daniel Lezcano wrote:
>> On 01/16/2014 03:25 PM, Peter Zijlstra wrote:
>>> On Thu, Jan 16, 2014 at 03:20:20PM +0100, Daniel Lezcano wrote:
>>>> Already tested. The last commits do not change the issue described above.
>>>
>>> Bummer, ok, what version of Ubuntu/rsyslogd are you using? I have a
>>> laptop around that should have some recent ubuntu on it, let me go find
>>> it.
>>
>> It is a Ubuntu 12.04 and rsyslog 5.8.6-1ubuntu8.4
>
> My laptop has 12.10, I've not yet tried to reproduce but while staring
> at the code I noticed a difference with the other can_nice() tests.
>
> Could you try the below while I build a pristine tip/master for the
> laptop?

Yes, it fixes the issue.

> ---
>   kernel/sched/core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 0326c06953eb..e4a3f7e3d613 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3298,7 +3298,7 @@ static int __sched_setscheduler(struct task_struct *p,
>   	 */
>   	if (user && !capable(CAP_SYS_NICE)) {
>   		if (fair_policy(policy)) {
> -			if (!can_nice(p, attr->sched_nice))
> +			if (attr->sched_nice < TASK_NICE(p) && !can_nice(p, attr->sched_nice))
>   				return -EPERM;
>   		}
>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

