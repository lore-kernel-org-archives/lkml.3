Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaKGOet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:34:49 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:32904 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaKGOer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:34:47 -0500
Message-ID: <545CD880.1000303@linaro.org>
Date: Fri, 07 Nov 2014 15:34:40 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: rjw@rjwysocki.net
CC: preeti@linux.vnet.ibm.com, nicolas.pitre@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, lenb@kernel.org
Subject: Re: [PATCH V3 0/6] sched: idle: cpuidle: cleanups and fixes
References: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 03:31 PM, Daniel Lezcano wrote:
> Hi,
>
> this patchset provides some cleanups to prepare the removal of the
> CPUIDLE_DRIVER_STATE_START macro in the cpuidle code. As the code has built
> on top of this macro adding more complexity and ugly hacks/tricks, it is hard
> to simply remove it. Some code has to be cleanup before, this is the purpose
> of this first patchset.

By the way, I forgot to mention it is based on 3.18-rc3

Thanks

   -- Daniel

> Changelog:
>
> V3:
>    - fixed comment for the latency_req introduction back to the right patch
>    - added back the last_idx_state in the reflect function
>    - change the get_typical_interval to return the value
>
> V2:
>    - fixed typo
>    - removed redundant comment
>    - fixed readability
>
>
> Daniel Lezcano (6):
>    sched: idle: Add a weak arch_cpu_idle_poll function
>    sched: idle: cpuidle: Check the latency req before idle
>    sched: idle: Get the next timer event and pass it the cpuidle
>      framework
>    cpuidle: idle: menu: Don't reflect when a state selection failed
>    cpuidle: menu: Fix the get_typical_interval
>    cpuidle: menu: Move the update function before its declaration
>
>   drivers/cpuidle/cpuidle.c          |  12 +--
>   drivers/cpuidle/governors/ladder.c |  13 +--
>   drivers/cpuidle/governors/menu.c   | 183 ++++++++++++++++++-------------------
>   include/linux/cpuidle.h            |   9 +-
>   kernel/sched/idle.c                |  55 +++++++----
>   5 files changed, 140 insertions(+), 132 deletions(-)
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

