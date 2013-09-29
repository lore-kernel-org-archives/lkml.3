Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab3I2KCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 06:02:51 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:36708 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750889Ab3I2KCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 06:02:47 -0400
Message-ID: <5247FABD.9070405@atmel.com>
Date: Sun, 29 Sep 2013 18:02:37 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <devicetree@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>, <nicolas.ferre@atmel.com>,
        <linux-kernel@vger.kernel.org>, <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4] PWM: atmel-pwm: add PWM controller driver
References: <1380079664-21959-1-git-send-email-voice.shen@atmel.com> <5245B7D7.2040405@free-electrons.com>
In-Reply-To: <5245B7D7.2040405@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On 9/28/2013 00:52, Alexandre Belloni wrote:
[snip]

>> +static int atmel_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
>> +	int ret;
>> +
>> +	ret = clk_enable(atmel_pwm->clk);
>> +	if (ret) {
>> +		pr_err("failed to enable pwm clock\n");
>> +		return ret;
>> +	}
>> +
>
> This will increment clk->enable_count each time it is called.

Yes, that's true.

>> +	atmel_pwm_writel(atmel_pwm, PWM_ENA, 1 << pwm->hwpwm);
>> +
>> +	return 0;
>> +}
>> +
>> +static void atmel_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
>> +	u32 val;
>> +
>> +	atmel_pwm_writel(atmel_pwm, PWM_DIS, 1 << pwm->hwpwm);
>> +
>> +	val = atmel_pwm_readl(atmel_pwm, PWM_SR);
>> +	if ((val & PWM_SR_ALL_CH_ON) == 0)
>> +		clk_disable(atmel_pwm->clk);
>> +}
>
> This will decrement clk->enable_count only once there are no pwm enabled
> anymore.  So in you enable more than one channel, you will never disable
> the clock. The simple fix is to always call clk_diasble, regardless of
> the state of the other channels.

Thank for point out this.

I see you have sent out a patch to fix it (however the other contents of 
your patch doesn't work). So, do you prefer I send out v5 patch to fix 
this? or you fix your patch at same time fix this issue?

Best Regards,
Bo Shen
