Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761831AbaGRTLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:11:25 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41700 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbaGRTLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:11:24 -0400
Message-ID: <53C9714F.1090301@samsung.com>
Date: Sat, 19 Jul 2014 04:11:11 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: linux@arm.linux.org.uk, kgene.kim@samsung.com, t.figa@samsung.com,
        kyungmin.park@samsung.com, ideal.song@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] ARM: dts: Add I2S dt node for Exynos3250
References: <1404874819-8257-1-git-send-email-cw00.choi@samsung.com> <53C865E3.5030806@samsung.com>
In-Reply-To: <53C865E3.5030806@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/14 09:10, Chanwoo Choi wrote:
> On 07/09/2014 12:00 PM, Chanwoo Choi wrote:
>> From: Tomasz Figa<t.figa@samsung.com>
>>
>> This patch add I2S (Inter-IC Sound) dt node which supports 1-port stereo
>> (1 channels) IIS-bus for audio interface with DMA-based operation.
>>
>> Signed-off-by: Tomasz Figa<t.figa@samsung.com>
>> Signed-off-by: Inha Song<ideal.song@samsung.com>
>> Tested-by: Inha Song<ideal.song@samsung.com>
>> Signed-off-by: Chanwoo Choi<cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park<kyungmin.park@samsung.com>
>> ---
>> Changes from v1:
>> - Fix wrong name of property (pinctrl-names)
>> - Change phanle name (i2s->i2s2)
>>
>>   arch/arm/boot/dts/exynos3250.dtsi | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
>> index 3e678fa..77a06df 100644
>> --- a/arch/arm/boot/dts/exynos3250.dtsi
>> +++ b/arch/arm/boot/dts/exynos3250.dtsi
>> @@ -425,6 +425,19 @@
>>   			status = "disabled";
>>   		};
>>
>> +		i2s2: i2s@13970000 {
>> +			compatible = "samsung,s3c6410-i2s";
>> +			reg =<0x13970000 0x100>;
>> +			interrupts =<0 126 0>;
>> +			clocks =<&cmu CLK_I2S>,<&cmu CLK_SCLK_I2S>;
>> +			clock-names = "iis", "i2s_opclk0";
>> +			dmas =<&pdma0 14>,<&pdma0 13>;
>> +			dma-names = "tx", "rx";
>> +			pinctrl-0 =<&i2s2_bus>;
>> +			pinctrl-names = "default";
>> +			status = "disabled";
>> +		};
>> +
>>   		pwm: pwm@139D0000 {
>>   			compatible = "samsung,exynos4210-pwm";
>>   			reg =<0x139D0000 0x1000>;
>>
>
> Ping.
>
Applied, thanks.

- Kukjin
