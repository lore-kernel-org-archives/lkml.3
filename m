Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904Ab3E3Bz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 21:55:56 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36099 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759886Ab3E3Bzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 21:55:49 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 May 2013 21:55:49 EDT
Message-ID: <51A6AF7D.8080706@codeaurora.org>
Date: Wed, 29 May 2013 18:46:37 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/2] clk: Disable unused clocks after deferred probing
 is done
References: <1368124502-18830-1-git-send-email-skannan@codeaurora.org> <519461BB.3010209@codeaurora.org> <20130529075126.6058.58923@quantum>
In-Reply-To: <20130529075126.6058.58923@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 12:51 AM, Mike Turquette wrote:
> Quoting Saravana Kannan (2013-05-15 21:34:03)
>> On 05/09/2013 11:35 AM, Saravana Kannan wrote:
>>> With deferred probing, late_initcall() is too soon to declare a clock as
>>> unused. Wait for deferred probing to finish before declaring a clock as
>>> unused. Since deferred probing is done in late_initcall(), do the unused
>>> check to late_initcall_sync.
>>>
>>> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
>>> ---
>>>    drivers/clk/clk.c |    2 +-
>>>    1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>>> index fe4055f..5ecb64c 100644
>>> --- a/drivers/clk/clk.c
>>> +++ b/drivers/clk/clk.c
>>> @@ -534,7 +534,7 @@ static int clk_disable_unused(void)
>>>
>>>        return 0;
>>>    }
>>> -late_initcall(clk_disable_unused);
>>> +late_initcall_sync(clk_disable_unused);
>>>
>>>    /***    helper functions   ***/
>>
>> Mike,
>>
>> Thoughts? Picking it up? Removing the existing auto-disable code (I
>> think they are still useful)?
>>
>
> Hi Saravana,
>
> I've taken this into clk-next for testing.
>
> Regards,
> Mike
>

Thanks.

-Saravana
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
