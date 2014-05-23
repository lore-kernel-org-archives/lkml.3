Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaEWJUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:20:46 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47237 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaEWJUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:20:42 -0400
Message-ID: <537F12E6.6070809@linaro.org>
Date: Fri, 23 May 2014 10:20:38 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v2 12/14] mmc: mmci: add support for fbclk to latch data
 and cmd.
References: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>	<1400146669-30302-1-git-send-email-srinivas.kandagatla@linaro.org> <CACRpkdZtHPZpmFA+JfgMn83+SgZZX4CS+MhAcf_sk2cQKqW1Pw@mail.gmail.com>
In-Reply-To: <CACRpkdZtHPZpmFA+JfgMn83+SgZZX4CS+MhAcf_sk2cQKqW1Pw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 23/05/14 10:12, Linus Walleij wrote:
> On Thu, May 15, 2014 at 11:37 AM,  <srinivas.kandagatla@linaro.org> wrote:
>
>> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>
>> This patch adds support to fbclk that is used to latch data and
>> cmd on some controllers like SD Card controller in Qcom SOC.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> (...)
>
> Isn't this overkill?

I totally agree.

Initially I did do it the way you suggested, but wanted to be more 
explicit in what its actually doing and I was also not sure if its Ok to 
add more than one flag in clkreg_enable.

>
> @@ -189,6 +192,7 @@ static struct variant_data variant_qcom = {
>           .clkreg                 = MCI_CLK_ENABLE,
> -        .clkreg_enable          = MCI_QCOM_CLK_FLOWENA,
> +       .clkreg_enable          = MCI_QCOM_CLK_FLOWENA |
> MCI_QCOM_CLK_FEEDBACK_CLK,
>           .clkreg_8bit_bus_enable = MCI_QCOM_CLK_WIDEBUS_8,
>

> Isn't this achieveing exactly the same thing without the extra fields?
> You unconditionally do it at every enable anyway, don't you?
I will fix it and send a new version.

Thanks,
srini
>
> Yours,
> Linus Walleij
>
