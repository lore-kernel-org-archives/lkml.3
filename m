Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3EPMzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:55:50 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:54717 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab3EPMzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:55:47 -0400
MIME-Version: 1.0
In-Reply-To: <519461BB.3010209@codeaurora.org>
References: <1368124502-18830-1-git-send-email-skannan@codeaurora.org>
	<519461BB.3010209@codeaurora.org>
Date: Thu, 16 May 2013 14:55:46 +0200
Message-ID: <CAPDyKFqyvfuttH=rGLxBCemgRMq4N3fVktom+RB2wm72NruaDA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] clk: Disable unused clocks after deferred probing
 is done
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mike Turquette <mturquette@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2013 06:34, Saravana Kannan <skannan@codeaurora.org> wrote:
> On 05/09/2013 11:35 AM, Saravana Kannan wrote:
>>
>> With deferred probing, late_initcall() is too soon to declare a clock as
>> unused. Wait for deferred probing to finish before declaring a clock as
>> unused. Since deferred probing is done in late_initcall(), do the unused
>> check to late_initcall_sync.
>>
>> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
>> ---
>>   drivers/clk/clk.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> index fe4055f..5ecb64c 100644
>> --- a/drivers/clk/clk.c
>> +++ b/drivers/clk/clk.c
>> @@ -534,7 +534,7 @@ static int clk_disable_unused(void)
>>
>>         return 0;
>>   }
>> -late_initcall(clk_disable_unused);
>> +late_initcall_sync(clk_disable_unused);

Without giving this too much thinking... Will boot time be affected
with this change?

Kind regards
Ulf Hansson

>>
>>   /***    helper functions   ***/
>
>
> Mike,
>
> Thoughts? Picking it up? Removing the existing auto-disable code (I think
> they are still useful)?
>
> -Saravana
>
>
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
