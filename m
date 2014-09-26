Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaIZBf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 21:35:58 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55264 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbaIZBf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 21:35:56 -0400
Message-ID: <5424C2FA.4000508@codeaurora.org>
Date: Thu, 25 Sep 2014 18:35:54 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tero Kristo <t-kristo@ti.com>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, tony@atomide.com,
        nm@ti.com, mturquette@linaro.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: prevent erronous parsing of children during rate
 change
References: <1408628866-32351-1-git-send-email-t-kristo@ti.com> <20140922191816.GF10233@codeaurora.org> <542177E5.9060606@ti.com>
In-Reply-To: <542177E5.9060606@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/14 06:38, Tero Kristo wrote:
> On 09/22/2014 10:18 PM, Stephen Boyd wrote:
>> On 08/21, Tero Kristo wrote:
>>>           /* Skip children who will be reparented to another clock */
>>>           if (child->new_parent && child->new_parent != clk)
>>>               continue;
>>
>> Are we not hitting the new_parent check here? I don't understand
>> how we can be changing parents here unless the check is being
>> avoided, in which case I wonder why determine_rate isn't being
>> used.
>>
>
> It depends how the clock underneath handles the situation. The error I
> am seeing actually happens with a SoC specific compound clock (DPLL)
> which integrates set_rate + mux functionality into a single clock
> node. A call to the clk_set_rate changes the parent of this clock
> (from bypass clock to reference clock), in addition to changing the
> rate (tune the mul+div.) I looked at using the determine rate call
> with this type but it breaks everything up... the parent gets changed
> but not the clock rate, in addition to some other issues.

Ok. Is this omap3_noncore_dpll_set_rate()? Can we use determine_rate +
clk_set_parent_and_rate()? At least clk_set_parent_and_rate() would
allow us to do the mult+div and the parent in the same op call, although
I don't understand why setting the parent and then setting the rate is
not going to work. I'm interested in the other issues that you mentioned
too.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

