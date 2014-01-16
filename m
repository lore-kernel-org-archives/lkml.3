Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaAPP2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:28:11 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34426 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaAPP2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:28:08 -0500
Message-ID: <52D7FA85.9020504@linaro.org>
Date: Thu, 16 Jan 2014 16:28:05 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: raistlin@linux.it, juri.lelli@gmail.com, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
References: <52D64676.4040000@linaro.org> <20140115120418.GD31570@twins.programming.kicks-ass.net> <52D7E343.40909@linaro.org> <20140116141743.GT31570@twins.programming.kicks-ass.net> <52D7EAA4.2080208@linaro.org> <20140116142546.GU31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140116142546.GU31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 03:25 PM, Peter Zijlstra wrote:
> On Thu, Jan 16, 2014 at 03:20:20PM +0100, Daniel Lezcano wrote:
>> Already tested. The last commits do not change the issue described above.
>
> Bummer, ok, what version of Ubuntu/rsyslogd are you using? I have a
> laptop around that should have some recent ubuntu on it, let me go find
> it.
>

Removing the lines below fix the issue.

These changes were introduced by the commit 
d50dde5a10f305253cbc3855307f608f8a3c5f73.

I don't get the connection between what is supposed to do the patch as 
described in the commit log and these four lines added.

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 141baa3..acabef1 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -15,7 +15,7 @@

  #include <uapi/asm/unistd.h>
dlezcano@mai:~/Work/src/cpuidle-next (sched/idle-balance)$ git diff
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 93a2836..673edff 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3295,10 +3295,6 @@ recheck:
          * Allow unprivileged RT tasks to decrease priority:
          */
         if (user && !capable(CAP_SYS_NICE)) {
-               if (fair_policy(policy)) {
-                       if (!can_nice(p, attr->sched_nice))
-                               return -EPERM;
-               }

                 if (rt_policy(policy)) {
                         unsigned long rlim_rtprio =



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

