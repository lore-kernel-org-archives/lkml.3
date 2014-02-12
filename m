Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaBLKrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:47:32 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:59320 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaBLKr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:47:29 -0500
Message-ID: <52FB5061.1000709@linux.vnet.ibm.com>
Date: Wed, 12 Feb 2014 16:13:45 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        rjw@rjwysocki.net, nicolas.pitre@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] cpuidle/idle: Move the cpuidle_idle_call function
 to idle.c
References: <1392131491-5265-1-git-send-email-daniel.lezcano@linaro.org> <1392131491-5265-2-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1392131491-5265-2-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021210-8256-0000-0000-00000B6C8A79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 02/11/2014 08:41 PM, Daniel Lezcano wrote:
> The cpuidle_idle_call does nothing more than calling the three individuals
> function and is no longer used by any arch specific code but only in the
> cpuidle framework code.
> 
> We can move this function into the idle task code to ensure better
> proximity to the scheduler code.

So my understanding of this patchset is that by moving
cpuidle_idle_call() under kernel/sched, we now have a way of calling
into the cpuidle governor and the cpuidle driver with additional
parameters like cpu_load(), idle_stamp etc.. so that we can expect the
governor and driver to take better decisions about entry and exit into
idle states. Is this the advantage we hope to begin with?

Thanks

Regards
Preeti U Murthy
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> ---

