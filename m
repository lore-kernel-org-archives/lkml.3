Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaKGE3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 23:29:40 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:52923 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaKGE3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 23:29:38 -0500
Message-ID: <545C4AA4.7010904@linux.vnet.ibm.com>
Date: Fri, 07 Nov 2014 09:59:24 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        patches@linaro.org
Subject: Re: [PATCH V2 1/5] sched: idle: cpuidle: Check the latency req before
 idle
References: <1414054881-17713-1-git-send-email-daniel.lezcano@linaro.org> <CAM4v1pOg1GFW82WD8b6Vas5xhYQrQtdP1STGxyzYtrBNSa+-Pw@mail.gmail.com> <544FE787.8090108@linaro.org> <54504A60.2090908@linux.vnet.ibm.com> <545A3414.7030500@linaro.org> <545AF424.2070302@linux.vnet.ibm.com> <545B7AAC.3020309@linaro.org>
In-Reply-To: <545B7AAC.3020309@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110704-0005-0000-0000-0000062EBE2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 07:12 PM, Daniel Lezcano wrote:
> 
> Preeti,
> 
> I am wondering if we aren't going to a false debate.
> 
> If the latency_req is 0, we should just poll and not enter in any idle
> state even if one has zero exit latency. With a zero latency req, we
> want full reactivity on the system, not enter an idle state with all the
> computation in the menu governor, no ?
> 
> I agree this patch changes the behavior on PowerPC, but only if the
> latency_req is set to zero. I don't think we are worried about power
> saving when setting this value.
> 
> Couldn't the patch accepted as it is for the sake of consistency on all
> the platform and then we optimize cleanly for the special latency zero
> case ?

Alright Daniel, you can go ahead. I was thinking this patch through and
now realize that, like you point out the logic will only get complicated
with all the additional hack.

But would it be possible to add the weak arch_cpu_idle_loop() call for
the cases where latency requirement is 0 like you had suggested earlier
? This would ensure the polling logic does not break on PowerPC and we
don't bother the governor even. I will add the function in the core
PowerPC code. If arch does not define this function it will fall back to
cpu_idle_loop(). Fair enough?

Regards
Preeti U Murthy

