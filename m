Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaKLIqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 03:46:09 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:41538 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaKLIqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 03:46:07 -0500
Message-ID: <54631E48.7090804@gmail.com>
Date: Wed, 12 Nov 2014 14:16:00 +0530
From: Sanchayan Maity <maitysanchayan@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>
CC: rtc-linux@googlegroups.com, shawn.guo@linaro.org, linux@arm.linux.org.uk,
        kernel@pengutronix.de, b35083@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [[PATCHv2] 2/3] ARM: dts: vfxxx: Add SNVS node
References: <cover.1415364391.git.maitysanchayan@gmail.com> <64244b916de3864b714e829c3adeecec71aea2b3.1415364391.git.maitysanchayan@gmail.com> <38daf99040ba00bd5150e7bc73a2fd76@agner.ch>
In-Reply-To: <38daf99040ba00bd5150e7bc73a2fd76@agner.ch>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wednesday 12 November 2014 02:50 AM, Stefan Agner wrote:
> On 2014-11-07 14:04, Sanchayan Maity wrote:
>> This patch adds a devicetree node for the Secure
>> Non-Volatile Storage (SNVS) on the VF610 platform.
>> The SNVS block also has a Real Time Counter (RTC).
>>
>> Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
>> ---
>>  arch/arm/boot/dts/vfxxx.dtsi |   15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
>> index 4e70833..bc131b0 100644
>> --- a/arch/arm/boot/dts/vfxxx.dtsi
>> +++ b/arch/arm/boot/dts/vfxxx.dtsi
>> @@ -338,6 +338,21 @@
>>  				status = "disabled";
>>  			};
>>  
>> +			snvs0: snvs@400a7000 {
>> +				compatible = "fsl,sec-v4.0-mon", "simple-bus";
>> +				#address-cells = <1>;
>> +				#size-cells = <1>;
>> +				ranges = <0 0x400a7000 0x2000>;
>> +
>> +				snvs-rtc-lp@34 {
>> +					compatible = "fsl,sec-v4.0-mon-rtc-lp";
>> +					reg = <0x34 0x58>;
>> +					interrupts = <0 100 IRQ_TYPE_LEVEL_HIGH>;
> 
> With the new device tree structure, the interrupt field needs to be part
> of the vf500.dtsi now. The vfxxx.dtsi will be the parent also for the
> Cortex-M4 device tree, which uses a different interrupt controller.
> 
> While at it, use the GIC_SPI macro for the first cell (so this will be
> blend into the other interrupt definitions).

OK. Will fix this and send out a v3. My bad I missed the M4 changes.

> 
>> +					clocks = <&clks VF610_CLK_SNVS>;
>> +					clock-names = "snvs-rtc";
>> +				};
>> +			};
>> +
>>  			uart4: serial@400a9000 {
>>  				compatible = "fsl,vf610-lpuart";
>>  				reg = <0x400a9000 0x1000>;
> 

Regards,
Sanchayan.
