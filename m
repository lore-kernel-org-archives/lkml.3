Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab3JUS4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 14:56:46 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:57888 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3JUS4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 14:56:44 -0400
MIME-Version: 1.0
In-Reply-To: <20131017135602.GD24056@e106331-lin.cambridge.arm.com>
References: <1381960030-1640-1-git-send-email-tim.kryger@linaro.org>
	<1381960030-1640-3-git-send-email-tim.kryger@linaro.org>
	<20131017135602.GD24056@e106331-lin.cambridge.arm.com>
Date: Mon, 21 Oct 2013 11:56:43 -0700
Message-ID: <CAAYSxhoM2s_Yjy_FpUKjwgCCe=F+vSfPTyR0tKRUeHi1=-x3pA@mail.gmail.com>
Subject: Re: [RESEND PATCH v2 2/6] ARM: dts: Specify clocks for UARTs on bcm11351
From: Tim Kryger <tim.kryger@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Christian Daudt <bcm@fixthebug.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 6:56 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Wed, Oct 16, 2013 at 10:47:06PM +0100, Tim Kryger wrote:
>> Rather than declaring the frequency of the external clock, specify the
>> label of the clock such that the driver may determine the frequency on
>> its own.
>
> Nit: we're not specifying the label of the clock. Clocks are represented
> py a phand+args pair, and the important part is that we're specifying
> the clock itself.
>
> How about something like:
>
> ---->8----
> Currently the rate of the external clock input to "snps,dw-apb-uart"
> devices is described by a clock-frequency property rather than by
> reference to the clock itself.
>
> This patch changes the "snps,dw-apb-uart" entries in bcm11351.dtsi to
> refer to the parent clock directly, following the common clock bindings.
> ---->8----

Would this be acceptable?

The frequency property in "snps,dw-apb-uart" entries are no longer
required if the rate of the external clock can be determined using the
clk api (see e302cd9 serial: 8250_dw: add support for clk api).

This patch replaces the frequency property in the UART nodes of
bcm11351.dtsi with references to the relevant clocks following the
common clock binding.

>
> Also, this should probably be moved after the driver change, so as to
> not be unbootable temporarily.

The driver change was part of v3.10 so there is no issue here.

>
> Thanks,
> Mark.
>
>>
>> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
>> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
>> Reviewed-by: Matt Porter <matt.porter@linaro.org>
>> ---
>>  arch/arm/boot/dts/bcm11351.dtsi | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
>> index c6464fb..ce65367 100644
>> --- a/arch/arm/boot/dts/bcm11351.dtsi
>> +++ b/arch/arm/boot/dts/bcm11351.dtsi
>> @@ -43,7 +43,7 @@
>>               compatible = "brcm,bcm11351-dw-apb-uart", "snps,dw-apb-uart";
>>               status = "disabled";
>>               reg = <0x3e000000 0x1000>;
>> -             clock-frequency = <13000000>;
>> +             clocks = <&uartb_clk>;
>>               interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;
>>               reg-shift = <2>;
>>               reg-io-width = <4>;
>> @@ -53,7 +53,7 @@
>>               compatible = "brcm,bcm11351-dw-apb-uart", "snps,dw-apb-uart";
>>               status = "disabled";
>>               reg = <0x3e001000 0x1000>;
>> -             clock-frequency = <13000000>;
>> +             clocks = <&uartb2_clk>;
>>               interrupts = <GIC_SPI 66 IRQ_TYPE_LEVEL_HIGH>;
>>               reg-shift = <2>;
>>               reg-io-width = <4>;
>> @@ -63,7 +63,7 @@
>>               compatible = "brcm,bcm11351-dw-apb-uart", "snps,dw-apb-uart";
>>               status = "disabled";
>>               reg = <0x3e002000 0x1000>;
>> -             clock-frequency = <13000000>;
>> +             clocks = <&uartb3_clk>;
>>               interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
>>               reg-shift = <2>;
>>               reg-io-width = <4>;
>> @@ -73,7 +73,7 @@
>>               compatible = "brcm,bcm11351-dw-apb-uart", "snps,dw-apb-uart";
>>               status = "disabled";
>>               reg = <0x3e003000 0x1000>;
>> -             clock-frequency = <13000000>;
>> +             clocks = <&uartb4_clk>;
>>               interrupts = <GIC_SPI 64 IRQ_TYPE_LEVEL_HIGH>;
>>               reg-shift = <2>;
>>               reg-io-width = <4>;
>> --
>> 1.8.0.1
>>
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
