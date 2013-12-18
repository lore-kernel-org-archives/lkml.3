Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab3LRCEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 21:04:54 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:53773 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3LRCEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 21:04:51 -0500
Message-ID: <52B102BB.1050907@linaro.org>
Date: Wed, 18 Dec 2013 10:04:43 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [RFC PATCH 00/13] nohz: Use sysidle detection to let the timekeeper
 sleep
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 06:51 AM, Frederic Weisbecker wrote:
> So this is what this series brings, more details following:
> 
> * Some code, naming and whitespace cleanups
> 
> * Allow all CPUs outside the nohz_full range to handle the timekeeping
>   duty, not just CPU 0. Balancing the timekeeping duty should improve
>   powersavings.

If the system just has one nohz_full cpu running, it will need another
cpu to do timerkeeper job. Then the system roughly needs 2 cpu living.
>From powersaving POV, that is not good compare to normal nohz idle.
> 
> * Let the timekeeper (including CPU 0) sleep when its duty is
>   handed over to another CPU
> 
> * Allow timekeeper to sleep when all full dynticks CPUs are sleeping
>   (plug nohz to RCU sysidle detection)

Thanks Fredic!
It is much better on powersaving POV compare to current nohz_full. :)
> 
> * Wake up timekeeper with an IPI when full dynticks CPUs exit sysidle
>   state
> 
> * Wake up CPU 0 when a secondary timekeeper is offlined so that its
>   duty gets migrated


-- 
Thanks
    Alex
