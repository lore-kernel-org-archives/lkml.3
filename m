Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab3DVRCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 13:02:01 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:47304 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab3DVRB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 13:01:59 -0400
Message-ID: <51756D04.6030001@linaro.org>
Date: Mon, 22 Apr 2013 10:01:56 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jiri Slaby <jslaby@suse.cz>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Resume does not work after timekeeping change
References: <5172B86C.5030606@suse.cz> <alpine.LFD.2.02.1304211648150.21884@ionos>
In-Reply-To: <alpine.LFD.2.02.1304211648150.21884@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2013 07:48 AM, Thomas Gleixner wrote:
> On Sat, 20 Apr 2013, Jiri Slaby wrote:
>> Hi,
>>
>> my machine does not wake from suspend to RAM on my box running the -next
>> kernel. The last thing I see is "Disabling non-boot CPUs ...". I
>> bisected it to this commit:
>>
>> commit 7ec98e15aa049b7a2ca73485f31cf4f90c34e2dd
>> Author: Thomas Gleixner <tglx@linutronix.de>
>> Date:   Thu Feb 21 22:51:39 2013 +0000
>>
>>      timekeeping: Delay update of clock->cycle_last
>>
>>
>> Reverting that one on the top of -next-20130419 makes it work again.
> Does the patch below fix the issue?
>
> Thanks,
>
> 	tglx
> ---
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 675f720..98cd470 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -951,7 +951,7 @@ static void timekeeping_resume(void)
>   		__timekeeping_inject_sleeptime(tk, &ts_delta);
>   
>   	/* Re-base the last cycle value */
> -	clock->cycle_last = cycle_now;
> +	tk->cycle_last = clock->cycle_last = cycle_now;

Looks good.

Acked-by: John Stultz <john.stultz@linaro.org>

