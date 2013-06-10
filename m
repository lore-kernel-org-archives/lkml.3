Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab3FJEOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 00:14:21 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:42015 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3FJEOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 00:14:19 -0400
Message-ID: <51B55296.5030006@linaro.org>
Date: Mon, 10 Jun 2013 09:44:14 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org, Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH 2/3] ARM: dts: Add FIMD node to Origen4210 board
References: <1370603235-11193-1-git-send-email-tushar.behera@linaro.org> <1370603235-11193-3-git-send-email-tushar.behera@linaro.org> <5527415.fcM1OgADxD@flatron>
In-Reply-To: <5527415.fcM1OgADxD@flatron>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2013 04:19 PM, Tomasz Figa wrote:
> On Friday 07 of June 2013 16:37:14 Tushar Behera wrote:
>> From: Sachin Kamat <sachin.kamat@linaro.org>
>>
>> Added FIMD and display timing node to Origen4210 board.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> ---
>>  arch/arm/boot/dts/exynos4210-origen.dts |   21 +++++++++++++++++++++
>>  1 file changed, 21 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos4210-origen.dts
>> b/arch/arm/boot/dts/exynos4210-origen.dts index bcf8079..4c6c3cd 100644
>> --- a/arch/arm/boot/dts/exynos4210-origen.dts
>> +++ b/arch/arm/boot/dts/exynos4210-origen.dts
>> @@ -290,4 +290,25 @@
>>  			clock-frequency = <24000000>;
>>  		};
>>  	};
>> +
>> +	fimd@11c00000 {
>> +		pinctrl-0 = <&lcd_en &lcd_clk &lcd_data24 &pwm0_out>;
> 
> Ahh, this would explain the two pwm pin groups from previous patch.
> 
> This seems somehow incorrect, though. AFAIK PWM outputs are not managed by 
> FIMD in any way.
> 

I couldn't find any better place to put the pwm0_out pin configurations.
Without configuring pwm0_out pins, display doesn't come up on the LCD.
Any suggestions?

>> +		pinctrl-names = "default";
>> +		status = "okay";
>> +	};
>> +
>> +	display-timings {
>> +		native-mode = <&timing0>;
>> +		timing0: timing {
>> +			clock-frequency = <50000>;
> 
> Hmm, 50 KHz for pixel clock? Isn't it a bit too low? Or am I missing 
> something?
> 

Actually clock-frequency value is not used by DRM-FIMD, but instead
required by the framework.

Still it would be better to provide the actual pixel clock value here.
So I would update this with 40MHz which is actual pixel clock used on my
board.

> Best regards,
> Tomasz
> 
>> +			hactive = <1024>;
>> +			vactive = <600>;
>> +			hfront-porch = <64>;
>> +			hback-porch = <16>;
>> +			hsync-len = <48>;
>> +			vback-porch = <64>;
>> +			vfront-porch = <16>;
>> +			vsync-len = <3>;
>> +		};
>> +	};
>>  };

Thanks for your review.

-- 
Tushar Behera
