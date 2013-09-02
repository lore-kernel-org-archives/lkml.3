Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab3IBCC0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 22:02:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41287 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366Ab3IBCCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 22:02:24 -0400
Message-ID: <5223F1A8.4090509@ti.com>
Date: Mon, 2 Sep 2013 07:32:16 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
CC: <linus.walleij@linaro.org>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <n.a.balandin@gmail.com>
Subject: Re: [PATCH v2 1/3] gpio: pcf857x: change to  devm_request_threaded_irq
References: <1377859713-13460-1-git-send-email-george.cherian@ti.com> <1377859713-13460-2-git-send-email-george.cherian@ti.com> <87ppssrpci.wl%kuninori.morimoto.gx@renesas.com>
In-Reply-To: <87ppssrpci.wl%kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/2/2013 6:50 AM, Kuninori Morimoto wrote:
> Hi
>
>> Remove the request_irq and use devm_request_threaded_irq
>> also cleanup free_irq. devm_* takes care of that.
>>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
>> ---
>>   arch/arm/boot/dts/dra7-evm.dts |  2 +-
>>   drivers/gpio/gpio-pcf857x.c    | 28 ++++++++++++++++++++++++----
>>   2 files changed, 25 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
>> index 8b0738a..39b44bc 100644
>> --- a/arch/arm/boot/dts/dra7-evm.dts
>> +++ b/arch/arm/boot/dts/dra7-evm.dts
>> @@ -65,7 +65,7 @@
>>   		n_latch = <0x1408>;
>>   		gpio-controller;
>>   		#gpio-cells = <2>;
>> -		interrupt-parent = <&pcf_20>;
>> +		interrupt-parent = <&gpio20>;
>>   		interrupts = <14 2>;
>>   		interrupt-controller;
>>   		#interrupt-cells = <2>;
> I'm not sure detail,
> but does above "exchange interrupt-parent" and "using devm_request_threaded_irq()"
> have any relationship ?
Exactly. will resend this change alone.
> Separate patch seems nice ?

okay
> Best regards
> ---
> Kuninori Morimoto


-- 
-George

