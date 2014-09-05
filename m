Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbaIEH2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:28:42 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:34671 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751828AbaIEH2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:28:41 -0400
Message-ID: <540965E7.7040302@st.com>
Date: Fri, 5 Sep 2014 09:27:35 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <kernel@stlinux.com>
Cc: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [PATCH] pinctrl: st: Add remove function and remove gpio_chip
 on failure
References: <1409409935-8775-1-git-send-email-pramod.gurav@smartplayin.com> <5408AA8C.7040100@linaro.org>
In-Reply-To: <5408AA8C.7040100@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-09-05_02:2014-09-04,2014-09-05,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pramod, Srini

On 09/04/2014 08:08 PM, Srinivas Kandagatla wrote:
> Pramod,
> sorry for delay in reply as I was travelling, still in Jet lag.
>> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
>> ---
>>   drivers/pinctrl/pinctrl-st.c |   25 +++++++++++++++++++++++++
>>   1 files changed, 25 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
>> index 5475374..9296845 100644
>> --- a/drivers/pinctrl/pinctrl-st.c
>> +++ b/drivers/pinctrl/pinctrl-st.c
>> @@ -1517,6 +1517,7 @@ static int st_gpiolib_register_bank(struct
>> st_pinctrl *info,
>>                          0, handle_simple_irq,
>>                          IRQ_TYPE_LEVEL_LOW);
>>           if (err) {
>> +            gpiochip_remove(&bank->gpio_chip);
> This change-set looks good.
> IMO, you can send a patch for this change set.

Removing the gpiochip here looks good to me too.

>
>>               dev_info(dev, "could not add irqchip\n");
>>               return err;
>>           }
>> @@ -1685,6 +1686,29 @@ static int st_pctl_probe(struct platform_device
>> *pdev)
>>       return 0;
>>   }
>>
>
>> +static int st_pctl_remove(struct platform_device *pdev)
>> +{
> Ideally this driver will not be removed, as other drivers depend on
> this, even the serial.
>
> so I see no big achievement in adding the remove functionality, as this
> is going to be a dead code and would never be tested.

Agree too.

Thanks,
Maxime
