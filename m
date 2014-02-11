Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbaBKU3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:29:07 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:48809 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104AbaBKU3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:29:02 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH 2/2] ARM: dts: MSM8974: Add pinctrl node
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <CAJAp7OhEE0rTv2KRjajU361wrMh0VqOwCH4u4vC3+F4KMcU0GQ@mail.gmail.com>
Date: Tue, 11 Feb 2014 14:28:57 -0600
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Bjorn Andersson <bjorn@kryo.se>
Content-Transfer-Encoding: 7BIT
Message-Id: <41801E64-243A-47DF-9AED-F8594373EC10@codeaurora.org>
References: <1391700529-11816-1-git-send-email-iivanov@mm-sol.com> <1391700529-11816-2-git-send-email-iivanov@mm-sol.com> <CAJAp7OhEE0rTv2KRjajU361wrMh0VqOwCH4u4vC3+F4KMcU0GQ@mail.gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 10, 2014, at 12:55 PM, Bjorn Andersson <bjorn@kryo.se> wrote:

> On Thu, Feb 6, 2014 at 7:28 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
>> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>> 
>> Add the pin control node and pin definitions of SPI8.
>> 
>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
>> ---
>> arch/arm/boot/dts/qcom-msm8974.dtsi |   29 +++++++++++++++++++++++++++++
>> 1 file changed, 29 insertions(+)
>> 
>> diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
>> index 9e5dadb..395603f 100644
>> --- a/arch/arm/boot/dts/qcom-msm8974.dtsi
>> +++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
>> @@ -117,5 +117,34 @@
>>                        clocks = <&gcc GCC_BLSP1_UART2_APPS_CLK>, <&gcc GCC_BLSP1_AHB_CLK>;
>>                        clock-names = "core", "iface";
>>                };
>> +
>> +               msmgpio: pinctrl@fd510000 {
>> +                       compatible = "qcom,msm8974-pinctrl";
>> +                       reg = <0xfd510000 0x4000>;
>> +                       gpio-controller;
>> +                       #gpio-cells = <2>;
>> +                       interrupt-controller;
>> +                       #interrupt-cells = <2>;
>> +                       interrupts = <0 208 0>;
>> +
>> +                       spi8_default: spi8_default {
>> +                               mosi {
>> +                                       pins = "gpio45";
>> +                                       function = "blsp_spi8";
>> +                               };
>> +                               miso {
>> +                                       pins = "gpio46";
>> +                                       function = "blsp_spi8";
>> +                               };
>> +                               cs {
>> +                                       pins = "gpio47";
>> +                                       function = "blsp_spi8";
>> +                               };
>> +                               clk {
>> +                                       pins = "gpio48";
>> +                                       function = "blsp_spi8";
>> +                               };
>> +                       };
>> +               };
>>        };
>> };
> 
> Nice, listing it like this makes it easy to add the electrical
> properties when inheriting these nodes, closer to the product dts
> files.
> 
> Reviewed-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Linus,

I can take the .dts patch via the linux-qcom tree to keep it with other DT changes if you want to provide an ack.

- k


-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

