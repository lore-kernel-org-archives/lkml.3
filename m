Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117AbaH3FBc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 01:01:32 -0400
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:57476 "EHLO
	smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895AbaH3FBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 01:01:30 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
Message-ID: <54015A97.4020406@smartplayin.com>
Date: Sat, 30 Aug 2014 10:31:11 +0530
From: Pramod Gurav <pramod.gurav@smartplayin.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH v2] pinctrl: qcom: remove gpiochip in failure cases
References: <1409299909-5128-1-git-send-email-pramod.gurav@smartplayin.com> <20140829185744.GK12494@sonymobile.com>
In-Reply-To: <20140829185744.GK12494@sonymobile.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,


On 30-08-2014 12:27 AM, Bjorn Andersson wrote:
> On Fri 29 Aug 01:11 PDT 2014, Pramod Gurav wrote:
> 
>> This patch releases gpiochip related resources by calling
>> gpiochip_remove when either of gpiochip_add_pin_range and
>> gpiochip_irqchip_add fails.
>>
>> CC: Linus Walleij <linus.walleij@linaro.org>
>> CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>
>> CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> 
> Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> 
>> ---
>>
>> Changes since v1:
>> - In v1 of this patch gpiochip_remove was called only in failure case of
>>   gpiochip_irqchip_add. This patchs adds a call to gpiochip_remove in failure
>>   case of gpiochip_add_pin_range as well.
>>
>>  drivers/pinctrl/qcom/pinctrl-msm.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
>> index 2738108..9175bbc 100644
>> --- a/drivers/pinctrl/qcom/pinctrl-msm.c
>> +++ b/drivers/pinctrl/qcom/pinctrl-msm.c
>> @@ -829,6 +829,7 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
>>  	ret = gpiochip_add_pin_range(&pctrl->chip, dev_name(pctrl->dev), 0, 0, chip->ngpio);
>>  	if (ret) {
>>  		dev_err(pctrl->dev, "Failed to add pin range\n");
>> +		gpiochip_remove(&pctrl->chip);
>>  		return ret;
>>  	}
>>  
>> @@ -839,6 +840,7 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
>>  				   IRQ_TYPE_NONE);
>>  	if (ret) {
>>  		dev_err(pctrl->dev, "Failed to add irqchip to gpiochip\n");
>> +		gpiochip_remove(&pctrl->chip);
>>  		return -ENOSYS;
>>  	}
>>  
> 
> It seems like pinctrl-st.c and pinctrl-sirf.c is suffering the same problem,
> would you mind spinning patches for those too?
Sure. Was browsing files but I was caught by this thing called sleep
before I catch anything. :) Thanks for pointing them out. Will do it.

> 
> Regards,
> Bjorn
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
