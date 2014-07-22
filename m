Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbaGVWVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:21:14 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45425 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219AbaGVWVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:21:12 -0400
Message-ID: <53CEE3D6.6070207@codeaurora.org>
Date: Tue, 22 Jul 2014 15:21:10 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] sched_clock: Avoid corrupting hrtimer tree during suspend
References: <1405721392-30795-1-git-send-email-sboyd@codeaurora.org> <53C99EC5.2060602@linaro.org> <53C9A1EC.8060905@codeaurora.org> <53C9A2E7.8020307@linaro.org> <53C9ACCA.3070306@codeaurora.org> <53C9B862.5050106@linaro.org>
In-Reply-To: <53C9B862.5050106@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/14 17:14, John Stultz wrote:
> On 07/18/2014 04:24 PM, Stephen Boyd wrote:
>> On 07/18/14 15:42, John Stultz wrote:
>>> If its a regression (and needs -stable backports) it needs to go in via
>>> tip/timers/urgent, and not via the regular merge window.
>>>
>>> Whats the additional risk -stable wise for canceling the timer during
>>> suspend and starting it back up during resume?
>>>
>> I'd say close to zero given that we'd only be making the timer run a
>> little bit later and we have slack in there already. Here's that version.
> Ok, thanks. I'll try to do a closer review it and get it queued. Is
> there anyone who might be able to validate this and provide a Tested-by: ?
>

Maybe someone from Linaro can give a Tested-by? I basically did this:

# grep -A1 'sched_clock' /proc/timer_list && echo mem > /sys/power/state && grep -A1 'sched_clock' /proc/timer_list


and made sure that the expires time was reset.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

