Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab3JJEsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 00:48:09 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35494 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab3JJEsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 00:48:07 -0400
Message-ID: <52563183.8000508@linaro.org>
Date: Wed, 09 Oct 2013 21:48:03 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Dong Zhu <bluezhudong@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] timer stats: reset entries when disable the timer
 usage statistics
References: <20131010025947.GD2139@zhudong.nay.redhat.com> <20131010043519.GB22519@gmail.com>
In-Reply-To: <20131010043519.GB22519@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 09:35 PM, Ingo Molnar wrote:
> * Dong Zhu <bluezhudong@gmail.com> wrote:
>
>> From f41628c61d8a9172677ba33a55b61e37ce28f7a6 Mon Sep 17 00:00:00 2001
>> From: Dong Zhu <bluezhudong@gmail.com> 
>> Date: Thu, 10 Oct 2013 10:38:13 +0800
>>
>> When we stop timer statistics collection (via echo 0 > 
>> /proc/timers_stats), the statistics data is still exported as if it were 
>> correct, which can cause applicaitons to misuse the statistics.
> What misuse do you mean?
>
>> This patch resets the statistics when we stop collecting them, to avoid 
>> this problem.
> Well, this loses the handy 'snapshot' property of /proc/timer_stats. 
> Before this change one could do:
>
> 	echo 1 > /proc/timers_stats
> 	sleep 60 # run system workload
> 	echo 0 > /proc/timers_stats
>
> and examine the 1-minute collection result without it changing. Your 
> change, if I understand it correctly, zeroes it all out.


Good point. I misunderstood the patch and thought it was an issue that
the statistics are never cleared even if the collection was disabled,
but looking closer I see we clear on enable (if we were disabled). So
yes, this change doesn't seem right.



> Instead of this change I'd suggest adding a 'status' line, with two 
> outputs:
>
> 	Status: collection active
>
> 	Status: collection disabled

Agreed.

thanks
-john
