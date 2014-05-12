Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbaELOwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:52:16 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:43688 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227AbaELOwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:52:14 -0400
Message-ID: <5370E026.5040105@linaro.org>
Date: Mon, 12 May 2014 16:52:22 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Aubrey Li <aubrey.li@intel.com>
Subject: Re: [PATCH] PM / suspend: Always use deepest C-state in the "freeze"
 sleep state
References: <2548502.zJ1no3NhRc@vostro.rjw.lan> <5370D5E4.5040001@linaro.org> <5370D85C.3090505@linux.intel.com>
In-Reply-To: <5370D85C.3090505@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 04:19 PM, Li, Aubrey wrote:
> On 2014/5/12 22:08, Daniel Lezcano wrote:
>> On 05/05/2014 12:51 AM, Rafael J. Wysocki wrote:
>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>
>>> If freeze_enter() is called, we want to bypass the current cpuidle
>>> governor and always use the deepest available (that is, not disabled)
>>> C-state, because we want to save as much energy as reasonably possible
>>> then and runtime latency constraints don't matter at that point, since
>>> the system is in a sleep state anyway.
>>>
>>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> ---
>>>
>>> This is on top of https://patchwork.kernel.org/patch/4071541/ .
>>>
>>
>> Wouldn't make sense to revisit play_dead instead ?
>>
> play_dead() is broken.
>
> Even if it works, we still should rely on cpuidle driver to place the
> CPUs into the deepest c-state, because there is no architectural way to
> enter deepest c-state and what play_dead() does is a bad assumption.

Ok, let me rephrase it. Why not revisiting cpuidle_play_dead instead ?


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

