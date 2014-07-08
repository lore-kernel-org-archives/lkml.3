Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaGHOGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:06:54 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16393 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGHOGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:06:52 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-8b-53bbfafa7313
Message-id: <53BBFADA.1080603@samsung.com>
Date: Tue, 08 Jul 2014 16:06:18 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux@arm.linux.org.uk, kgene.kim@samsung.com, kyungmin.park@samsung.com,
        ideal.song@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: Add I2S dt node for Exynos3250
References: <1404373939-10510-1-git-send-email-cw00.choi@samsung.com>
 <53B66066.4030202@gmail.com> <53B67156.2020702@samsung.com>
In-reply-to: <53B67156.2020702@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t/xK7q/fu0ONtj8V97i+pfnrBa7/t5n
	tOhdcJXN4mzTG3aLTY+vsVpc3jWHzWLG+X1MFrcv81qs2vWH0YHTo6W5h81j56y77B6bl9R7
	9G1ZxejxeZNcAGsUl01Kak5mWWqRvl0CV8aFFT8YC6aKVHxfMpuxgXGiQBcjJ4eEgInE7a17
	2SBsMYkL99YD2VwcQgJLGSX6b3xnh3A+M0oc6XvADlLFK6Alce3dOrAOFgFVib/zljOC2GwC
	ahKfGx6BxfmBatY0XWfpYuTgEBWIkHh8QQiiVVDix+R7LCC2iICvRO+PJWDLmAXOM0rsPngX
	rFdYwFai61gDC8TiZkaJvXfOsYIkOAW0JT51bwHrZhbQkdjfOo0NwpaX2LzmLfMERsFZSJbM
	QlI2C0nZAkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghEfF1B+PSY1aHGAU4GJV4eA3O
	7w4WYk0sK67MPcQowcGsJML75RRQiDclsbIqtSg/vqg0J7X4ECMTB6dUA2PXI46ATR9+helN
	FJhZMOF32SLdBKFv1+Z/z9RRifqe8pO/UODK+7BC1dWTFu/79TryEYv5/Nm2+2uqt7P8e3k6
	4cjq22Vz3A/d06jfs+REphaDlNnHOsM3yUHP/Fe91bfewH9RMlz/nN1Rc9maJAvVtbv3Jh8/
	t/Vi8o5uwe9XW0o0XnD8/vNQiaU4I9FQi7moOBEAvqoXjWYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 04.07.2014 11:18, Chanwoo Choi wrote:
> Dear Kukjin and Tomasz,
> 
> On 07/04/2014 05:05 PM, Tomasz Figa wrote:
>> Hi Chanwoo,
>>
>> On 03.07.2014 09:52, Chanwoo Choi wrote:
>>> From: Tomasz Figa <t.figa@samsung.com>
>>>
>>> This patch add I2S (Inter-IC Sound) dt node which supports 1-port stereo
>>> (1 channels) IIS-bus for audio interface with DMA-based operation.
>>>
>>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>>> Signed-off-by: Inha Song <ideal.song@samsung.com>
>>> Tested-by: Inha Song <ideal.song@samsung.com>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>>  arch/arm/boot/dts/exynos3250.dtsi | 13 +++++++++++++
>>>  1 file changed, 13 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
>>> index 1f8384f..e9017ef 100644
>>> --- a/arch/arm/boot/dts/exynos3250.dtsi
>>> +++ b/arch/arm/boot/dts/exynos3250.dtsi
>>> @@ -644,6 +644,19 @@
>>>  			status = "disabled";
>>>  		};
>>>  
>>> +		i2s: i2s@13970000 {
>>
>> Shouldn't the label be rather called "i2s2" as the pinctrl entry below
>> suggests?
>>
>>> +			compatible = "samsung,s3c6410-i2s";
>>> +			reg = <0x13970000 0x100>;
>>> +			interrupts = <0 126 0>;
>>> +			clocks = <&cmu CLK_I2S>, <&cmu CLK_SCLK_I2S>;
>>> +			clock-names = "iis", "i2s_opclk0";
>>> +			dmas = <&pdma0 14>, <&pdma0 13>;
>>> +			dma-names = "tx", "rx";
>>> +			pinctrl-0 = <&i2s2_bus>;
>>> +			pinctrl-name = "default";
>>
>> "pinctrl-name" is not a valid property. I suppose it should be
>> "pinctrl-names".
> 
> I modify this patch as following. If you confirm following patch, I'll re-send patchset(v2).
> 
> diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
> index 3e678fa..77a06df 100644
> --- a/arch/arm/boot/dts/exynos3250.dtsi
> +++ b/arch/arm/boot/dts/exynos3250.dtsi
> @@ -425,6 +425,19 @@
>  			status = "disabled";
>  		};
>  
> +		i2s2: i2s@13970000 {
> +			compatible = "samsung,s3c6410-i2s";
> +			reg = <0x13970000 0x100>;
> +			interrupts = <0 126 0>;
> +			clocks = <&cmu CLK_I2S>, <&cmu CLK_SCLK_I2S>;
> +			clock-names = "iis", "i2s_opclk0";
> +			dmas = <&pdma0 14>, <&pdma0 13>;
> +			dma-names = "tx", "rx";
> +			pinctrl-0 = <&i2s2_bus>;
> +			pinctrl-names = "default";
> +			status = "disabled";
> +		};
> +
>  		pwm: pwm@139D0000 {
>  			compatible = "samsung,exynos4210-pwm";
>  			reg = <0x139D0000 0x1000>;
> 

Looks good.

Best regards,
Tomasz
