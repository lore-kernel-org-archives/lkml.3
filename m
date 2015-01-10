Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbbAJCDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:03:37 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:35844 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbbAJCDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:03:36 -0500
Message-ID: <54B08876.1040200@codeaurora.org>
Date: Fri, 09 Jan 2015 18:03:34 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 02/10] clocksource: Simplify logic around clocksource
 wrapping saftey margins
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org> <1420850068-27828-3-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1420850068-27828-3-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 04:34 PM, John Stultz wrote:
> The clocksource logic has a number of places where we try to
> include a safety margin. Most of these are 12% safety margins,
> but they are inconsistently applied and sometimes are applied
> on top of each other.
>
> Additionally, in the previous patch, we corrected an issue
> where we unintentionally in effect created a 50% saftey margin,
> which these 12.5% margins where then added to.
>
> So to siplify the logic here, this patch removes the various
> 12.5% margins, and consolidates adding the margin in one place:
> clocks_calc_max_nsecs().
>
> Addtionally, Linus prefers a 50% safety margin, as it allows
> bad clock values to be more easily caught. This should really
> have no net effect, due to the corrected issue earlier which
> caused greater then 50% margins to be used w/o issue.
>
> Cc: Dave Jones <davej@codemonkey.org.uk>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Prarit Bhargava <prarit@redhat.com>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---

For sched_clock.c part

Acked-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

