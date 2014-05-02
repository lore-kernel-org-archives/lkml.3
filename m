Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaEBIrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 04:47:48 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51045 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaEBIrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 04:47:46 -0400
Message-ID: <53635BB4.30900@linaro.org>
Date: Fri, 02 May 2014 10:47:48 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] cpuidle / menu: Return error code if there are no
 suitable states
References: <2471963.urOyfY8mOG@vostro.rjw.lan> <535E3818.2040905@linaro.org> <2000825.kO1es8ShkW@vostro.rjw.lan> <1516317.nEvPfS8aZ7@vostro.rjw.lan>
In-Reply-To: <1516317.nEvPfS8aZ7@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 01:16 AM, Rafael J. Wysocki wrote:
> On Tuesday, April 29, 2014 01:28:03 AM Rafael J. Wysocki wrote:
>> On Monday, April 28, 2014 01:14:32 PM Daniel Lezcano wrote:
>>> On 04/27/2014 02:55 PM, Rafael J. Wysocki wrote:

[ ... ]

> ---
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: cpuidle / menu: Return (-1) if there are no suitable states
>
> If there is a PM QoS latency limit and all of the sufficiently shallow
> C-states are disabled, the cpuidle menu governor returns 0 which on
> some systems is CPUIDLE_DRIVER_STATE_START and shouldn't be returned
> if that C-state has been disabled.
>
> Fix the issue by modifying the menu governor to return (-1) in such
> situations.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>   drivers/cpuidle/governors/menu.c |    2 +-
>   include/linux/cpuidle.h          |    2 ++
>   2 files changed, 3 insertions(+), 1 deletion(-)
>
> Index: linux-pm/drivers/cpuidle/governors/menu.c
> ===================================================================
> --- linux-pm.orig/drivers/cpuidle/governors/menu.c
> +++ linux-pm/drivers/cpuidle/governors/menu.c
> @@ -296,7 +296,7 @@ static int menu_select(struct cpuidle_dr
>   		data->needs_update = 0;
>   	}
>
> -	data->last_state_idx = 0;
> +	data->last_state_idx = CPUIDLE_DRIVER_STATE_START - 1;

In case of x86, CPUIDLE_DRIVER_STATE_START will be 1, so the select 
function could return 0 even this one is disabled and this is not what 
you want to happen, no ?


>   	/* Special case when user has set very strict latency requirement */
>   	if (unlikely(latency_req == 0))
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

