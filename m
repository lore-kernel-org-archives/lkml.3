Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab3CKIlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:41:00 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:36186 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab3CKIk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:40:58 -0400
Message-ID: <513D9896.2010304@linaro.org>
Date: Mon, 11 Mar 2013 09:40:54 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: john.stultz@linaro.org, tglx@linutronix.de, viresh.kumar@linaro.org,
        jacob.jun.pan@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 0/4] time: dynamic irq affinity
References: <1361917047-29230-1-git-send-email-daniel.lezcano@linaro.org> <513CC404.6000200@ti.com> <513CCF60.6060406@linaro.org> <513D4E79.5090307@ti.com>
In-Reply-To: <513D4E79.5090307@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 04:24 AM, Santosh Shilimkar wrote:
> On Sunday 10 March 2013 11:52 PM, Daniel Lezcano wrote:

[ ... ]

>> I don't think it is the case for all the ARM platforms, at least we
>> tested it on vexpress TC2 and u8500, and the number of IPI were reduced
>> very significantly increasing the idle time for cpu0. TC2 will need
>> another optimization on another area for the idle wake up to gain real
>> improvements.
>>
> You are missing my point. TC2 can be an exception since the SGI can wakeup
> CPUs even from low power states where local timer's are stalled. Is that
> the case with U8500 ?

Well, the cpuidle driver is not going into a deep idle state to check
this out.

AFAICT this board has a specific firmware with the PRCMU (a device
managing the power on the board) and it replaces the GIC when going to
deep idle state, especially by reconnecting the GIC to the A9 cores
automatically when an interrupt occurs.

But definitively worth to check.

>> I will test it on OMAP but with the coupled idle state, I am not sure of
>> the behavior. Could elaborate a bit the specificity of OMAP ? I am not
>> sure to understand why I may miss some IPI wakeups.
>>
> I already mention the issue here [1]. You might not see any major issues
> because the missed asynchronous IPIs might eventually get executed when
> CPU's wakeup from deeper states because of idle wakeups. OMAP is no
> different from idle wakeup optimisation and it will surely benefit and work.
> The main reason I didn't pursue it because of not having solution for
> [1] which as discussed in past is very much essential from kernel
> functional correctness perspective. You might want to verify that by
> adding a tracepoint on IPI's on other reasons except the timer wakeup.

Oh, ok. I didn't make the connection. I got the point now.

If we can raise a fake hardware interrupt on the GIC (not sure that
could be done), may be we can implement something similar to the
broadcast timer mechanism to replace the IPI when the cores are not IPI
wakeup capable.


> [1] https://lkml.org/lkml/2013/2/27/39
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

