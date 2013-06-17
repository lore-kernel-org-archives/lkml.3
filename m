Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab3FQW6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:58:41 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:49643 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab3FQW6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:58:31 -0400
Message-ID: <51BF9494.9000209@linaro.org>
Date: Mon, 17 Jun 2013 15:58:28 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] ARM: sched_clock: Load cycle count after epoch stabilizes
References: <1371508858-23371-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1371508858-23371-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 03:40 PM, Stephen Boyd wrote:
> There is a small race between when the cycle count is read from
> the hardware and when the epoch stabilizes. Consider this
> scenario:
>
>   CPU0                           CPU1
>   ----                           ----
>   cyc = read_sched_clock()
>   cyc_to_sched_clock()
>                                   update_sched_clock()
>                                    ...
>                                    cd.epoch_cyc = cyc;
>    epoch_cyc = cd.epoch_cyc;
>    ...
>    epoch_ns + cyc_to_ns((cyc - epoch_cyc)
>
> The cyc on cpu0 was read before the epoch changed. But we
> calculate the nanoseconds based on the new epoch by subtracting
> the new epoch from the old cycle count. Since epoch is most likely
> larger than the old cycle count we calculate a large number that
> will be converted to nanoseconds and added to epoch_ns, causing
> time to jump forward too much.
>
> Fix this problem by reading the hardware after the epoch has
> stabilized.
>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks for the resend here.

I've got this in my tree and unless I get an objection in the next day 
or so, I'll send it on to Thomas.

thanks
-john

