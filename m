Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaAOI1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 03:27:39 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59040 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaAOI1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 03:27:36 -0500
Message-ID: <52D64676.4040000@linaro.org>
Date: Wed, 15 Jan 2014 09:27:34 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: raistlin@linux.it, juri.lelli@gmail.com
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [BUG] [ tip/sched/core ] System unresponsive after booting
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

I use the tip/sched/core branch.

After git pulling yesterday, my host is unresponsive after booting the OS.

  * It boots normally
  * It sends info to the console
  * The graphics does not work
  * The terminals show the prompt, I can enter the username but after 
pressing enter, it does not give the password prompt
  * sysrq works more or less, I can't get the process stack but it 
receives the command

It is like no new process can be created.

I have a dual Xeon processor E5325 (2 x 4 cores).

After git bisecting, the following patch seems to introduce the bug.

commit d50dde5a10f305253cbc3855307f608f8a3c5f73
Author: Dario Faggioli <raistlin@linux.it>
Date:   Thu Nov 7 14:43:36 2013 +0100

     sched: Add new scheduler syscalls to support an extended scheduling 
parameters ABI

     Add the syscalls needed for supporting scheduling algorithms
     with extended scheduling parameters (e.g., SCHED_DEADLINE).


[ ... ]


     Signed-off-by: Dario Faggioli <raistlin@linux.it>
     [ Rewrote to use sched_attr. ]
     Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
     [ Removed sched_setscheduler2() for now. ]
     Signed-off-by: Peter Zijlstra <peterz@infradead.org>
     Link: 
http://lkml.kernel.org/r/1383831828-15501-3-git-send-email-juri.lelli@gmail.com
     Signed-off-by: Ingo Molnar <mingo@kernel.org>

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

