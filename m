Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbaELOU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:20:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:62445 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756705AbaELOUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:20:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1035,1389772800"; 
   d="scan'208";a="538948816"
Message-ID: <5370D85C.3090505@linux.intel.com>
Date: Mon, 12 May 2014 22:19:08 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Aubrey Li <aubrey.li@intel.com>
Subject: Re: [PATCH] PM / suspend: Always use deepest C-state in the "freeze"
 sleep state
References: <2548502.zJ1no3NhRc@vostro.rjw.lan> <5370D5E4.5040001@linaro.org>
In-Reply-To: <5370D5E4.5040001@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/12 22:08, Daniel Lezcano wrote:
> On 05/05/2014 12:51 AM, Rafael J. Wysocki wrote:
>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>
>> If freeze_enter() is called, we want to bypass the current cpuidle
>> governor and always use the deepest available (that is, not disabled)
>> C-state, because we want to save as much energy as reasonably possible
>> then and runtime latency constraints don't matter at that point, since
>> the system is in a sleep state anyway.
>>
>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> ---
>>
>> This is on top of https://patchwork.kernel.org/patch/4071541/ .
>>
> 
> Wouldn't make sense to revisit play_dead instead ?
> 
play_dead() is broken.

Even if it works, we still should rely on cpuidle driver to place the
CPUs into the deepest c-state, because there is no architectural way to
enter deepest c-state and what play_dead() does is a bad assumption.

Thanks,
-Aubrey

