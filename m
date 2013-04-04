Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3DDEZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 00:25:32 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:38010 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab3DDEZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 00:25:31 -0400
MIME-Version: 1.0
In-Reply-To: <514821AA.2060201@st.com>
References: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
	<514821AA.2060201@st.com>
Date: Thu, 4 Apr 2013 09:55:31 +0530
Message-ID: <CAK9yfHzGvFcjWv7KQc2A32AE90mYzC1cNPb6jCb4+1+BUGVp9Q@mail.gmail.com>
Subject: Re: [PATCH 1/5] pinctrl: abx500: Staticize some symbols
From: Sachin Kamat <sachin.kamat@linaro.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 19 March 2013 13:58, Patrice CHOTARD <patrice.chotard@st.com> wrote:
> On 03/19/2013 07:31 AM, Sachin Kamat wrote:
>
>> These symbols are used only in this file. Without this patch
>> we get the following warnings:
>> drivers/pinctrl/pinctrl-abx500.c:520:5: warning:
>> symbol 'abx500_gpio_request' was not declared. Should it be static?
>> drivers/pinctrl/pinctrl-abx500.c:527:6: warning:
>> symbol 'abx500_gpio_free' was not declared. Should it be static?
>> drivers/pinctrl/pinctrl-abx500.c:614:5: warning:
>> symbol 'abx500_gpio_request_enable' was not declared. Should it be static?
>> drivers/pinctrl/pinctrl-abx500.c:714:5: warning:
>> symbol 'abx500_pin_config_get' was not declared. Should it be static?
>> drivers/pinctrl/pinctrl-abx500.c:721:5: warning:
>> symbol 'abx500_pin_config_set' was not declared. Should it be static?
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Cc: Patrice Chotard <patrice.chotard@st.com>
>> ---
>> This series is compile tested against linux-next tree (20130319).
>> ---
>>  drivers/pinctrl/pinctrl-abx500.c |   10 +++++-----
>>  1 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
>> index 0cf3fa4..9b8db91 100644
>> --- a/drivers/pinctrl/pinctrl-abx500.c
>> +++ b/drivers/pinctrl/pinctrl-abx500.c
>> @@ -517,14 +517,14 @@ static inline void abx500_gpio_dbg_show_one(struct seq_file *s,
>>  #define abx500_gpio_dbg_show NULL
>>  #endif
>>
>> -int abx500_gpio_request(struct gpio_chip *chip, unsigned offset)
>> +static int abx500_gpio_request(struct gpio_chip *chip, unsigned offset)
>>  {
>>       int gpio = chip->base + offset;
>>
>>       return pinctrl_request_gpio(gpio);
>>  }
>>
>> -void abx500_gpio_free(struct gpio_chip *chip, unsigned offset)
>> +static void abx500_gpio_free(struct gpio_chip *chip, unsigned offset)
>>  {
>>       int gpio = chip->base + offset;
>>
>> @@ -611,7 +611,7 @@ static void abx500_pmx_disable(struct pinctrl_dev *pctldev,
>>       dev_dbg(pct->dev, "disable group %s, %u pins\n", g->name, g->npins);
>>  }
>>
>> -int abx500_gpio_request_enable(struct pinctrl_dev *pctldev,
>> +static int abx500_gpio_request_enable(struct pinctrl_dev *pctldev,
>>                              struct pinctrl_gpio_range *range,
>>                              unsigned offset)
>>  {
>> @@ -711,14 +711,14 @@ static const struct pinctrl_ops abx500_pinctrl_ops = {
>>       .pin_dbg_show = abx500_pin_dbg_show,
>>  };
>>
>> -int abx500_pin_config_get(struct pinctrl_dev *pctldev,
>> +static int abx500_pin_config_get(struct pinctrl_dev *pctldev,
>>                         unsigned pin,
>>                         unsigned long *config)
>>  {
>>       return -ENOSYS;
>>  }
>>
>> -int abx500_pin_config_set(struct pinctrl_dev *pctldev,
>> +static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
>>                         unsigned pin,
>>                         unsigned long config)
>>  {
>
>
> Acked-by: Patrice Chotard <patrice.chotard@st.com>

Gentle ping on this series.


-- 
With warm regards,
Sachin
