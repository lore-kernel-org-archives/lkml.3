Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbaCaSsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:48:41 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42521 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbaCaSsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:48:39 -0400
Message-ID: <5339B885.5070802@codeaurora.org>
Date: Mon, 31 Mar 2014 11:48:37 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Input: pmic8xxx-pwrkey - Set sane default for debounce
 time
References: <1396289664-31893-1-git-send-email-sboyd@codeaurora.org> <20140331182342.GD28265@joshc.qualcomm.com>
In-Reply-To: <20140331182342.GD28265@joshc.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/14 11:23, Josh Cartwright wrote:
> On Mon, Mar 31, 2014 at 11:14:24AM -0700, Stephen Boyd wrote:
>> If the debounce time is 0 our usage of ilog2() later on in this
>> driver will cause undefined behavior. If CONFIG_OF=n this fact is
>> evident to the compiler, and it emits a call to ____ilog2_NaN()
>> which doesn't exist. Fix this by setting a sane default for
>> debounce.
>>
>> Reported-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  drivers/input/misc/pmic8xxx-pwrkey.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/input/misc/pmic8xxx-pwrkey.c b/drivers/input/misc/pmic8xxx-pwrkey.c
>> index 1cb8fda7a166..27add04676e1 100644
>> --- a/drivers/input/misc/pmic8xxx-pwrkey.c
>> +++ b/drivers/input/misc/pmic8xxx-pwrkey.c
>> @@ -92,7 +92,7 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
>>  	bool pull_up;
>>  
>>  	if (of_property_read_u32(pdev->dev.of_node, "debounce", &kpd_delay))
>> -		kpd_delay = 0;
>> +		kpd_delay = 15625;
> Should "debounce" even be optional?  I'm wondering if we should just
> make it required...

Hmm maybe. It's not like things won't work without it set though.

>
> At the very least this default value should be documented in the DT
> binding.
>

I never understood this. The default value is something that is entirely
software driven. It could change at any time. If DT implementers aren't
specifying it they're saying "I don't care what the value is, let the
driver decide if they care". They're not saying, "Oh, that default value
in the binding is good enough for me so I don't need to specify this".

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

