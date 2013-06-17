Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab3FQVuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 17:50:08 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:64235 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab3FQVuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 17:50:06 -0400
Message-ID: <51BF848B.2030501@linaro.org>
Date: Mon, 17 Jun 2013 14:50:03 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: sched_clock: Load cycle count after epoch stabilizes
References: <1371082214-1119-1-git-send-email-sboyd@codeaurora.org> <51BF68DC.5030804@codeaurora.org>
In-Reply-To: <51BF68DC.5030804@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 12:51 PM, Stephen Boyd wrote:
> John,
>
> I just saw your pull request for making this code generic. I believe
> this patch fixes a bug that nobody has seen in practice so it's probably
> fine to delay this until 3.11.
>
> Also, I've just noticed that "ARM: sched_clock: Return suspended count
> earlier" that I sent in that series is going to break the arm
> architected timer path because they're circumventing all this epoch_ns
> code. It would be better if you could replace that patch with this patch
> because this optimizes it in the same way and also fixes a bug at the
> same time.

Sorry, could you clarify a bit more? The above sounds like there are two 
issues, but you only sent one patch.

I'm also not sure how to proceed with the patch you sent, since it 
collides with the patch that moves sched_clock to be generic.

Could you refactor the change on-top of git branch I sent to Thomas? 
Otherwise I'll have to withdraw the pull request, and we'll probably 
miss 3.11 for the generic sched_clock change.

thanks
-john


