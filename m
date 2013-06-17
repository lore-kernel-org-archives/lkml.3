Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3FQWV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:21:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59867 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3FQWV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:21:27 -0400
Message-ID: <51BF8BE6.5080704@codeaurora.org>
Date: Mon, 17 Jun 2013 15:21:26 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: sched_clock: Load cycle count after epoch stabilizes
References: <1371082214-1119-1-git-send-email-sboyd@codeaurora.org> <51BF68DC.5030804@codeaurora.org> <51BF848B.2030501@linaro.org>
In-Reply-To: <51BF848B.2030501@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/13 14:50, John Stultz wrote:
> On 06/17/2013 12:51 PM, Stephen Boyd wrote:
>> John,
>>
>> I just saw your pull request for making this code generic. I believe
>> this patch fixes a bug that nobody has seen in practice so it's probably
>> fine to delay this until 3.11.
>>
>> Also, I've just noticed that "ARM: sched_clock: Return suspended count
>> earlier" that I sent in that series is going to break the arm
>> architected timer path because they're circumventing all this epoch_ns
>> code. It would be better if you could replace that patch with this patch
>> because this optimizes it in the same way and also fixes a bug at the
>> same time.
>
> Sorry, could you clarify a bit more? The above sounds like there are
> two issues, but you only sent one patch.

I'm saying that the "return the suspended count earlier" patch is bad.
But this patch does what that patch is doing plus it fixes a race at the
same time. So it would be better to just take this patch and drop the other.

The problem is that when the cd.suspended flag is true we're going to
return the jiffies based sched_clock value for the ARM architected timer
driver (the only driver that replaces the sched_clock_func function
pointer with its own function). Jiffies should be pretty close to the
actual time anyway, but since the ARM architected timer driver is
already broken with respect to suspend (because it doesn't stop the
sched_clock value from incrementing during suspend) it doesn't really
matter. Every other driver using the sched_clock code will not be
affected either way.

>
> I'm also not sure how to proceed with the patch you sent, since it
> collides with the patch that moves sched_clock to be generic.

Ah I thought that the git rename detection would just make it work.

>
> Could you refactor the change on-top of git branch I sent to Thomas?
> Otherwise I'll have to withdraw the pull request, and we'll probably
> miss 3.11 for the generic sched_clock change.

Sure. I'll send it right now.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

