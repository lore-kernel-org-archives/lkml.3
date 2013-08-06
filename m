Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab3HFQsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 12:48:10 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:38535 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab3HFQsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 12:48:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAK9yfHwxVtJFZMQNoh-RepaF53L_TruPBSUt3YH_XY+8iXjffA@mail.gmail.com>
References: <1375726723-20862-1-git-send-email-tobetter@gmail.com>
	<CAK9yfHwxVtJFZMQNoh-RepaF53L_TruPBSUt3YH_XY+8iXjffA@mail.gmail.com>
Date: Wed, 7 Aug 2013 01:48:05 +0900
Message-ID: <CADoNuNdOV4uwnCdtnYGzDGb=j-Qqnhx9fRrif5c=f-X=-gRoGw@mail.gmail.com>
Subject: Re: [PATCH RESEND] ARM: dts: Add USBPHY nodes to Exynos4x12
From: Dongjin Kim <tobetter@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aha, yes...my misunderstanding.
This node is not only for OTG or HSIC, could miss USB HOST transceiver
if certain board file does not set "okay".

Thanks,
Dongjin.

On Tue, Aug 6, 2013 at 3:09 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Hi Dongjin,
>
> On 5 August 2013 23:48, Dongjin Kim <tobetter@gmail.com> wrote:
>> This patch adds device nodes for USBPHY to Exynos4x12.
>>
>> CC: Sachin Kamat <sachin.kamat@linaro.org>
>> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
>> ---
>>  arch/arm/boot/dts/exynos4x12.dtsi |   18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
>> index 01da194..9c3335b 100644
>> --- a/arch/arm/boot/dts/exynos4x12.dtsi
>> +++ b/arch/arm/boot/dts/exynos4x12.dtsi
>> @@ -73,4 +73,22 @@
>>                 clock-names = "sclk_fimg2d", "fimg2d";
>>                 status = "disabled";
>>         };
>> +
>> +       usbphy@125B00000 {
>> +               #address-cells = <1>;
>> +               #size-cells = <1>;
>> +               compatible = "samsung,exynos4x12-usb2phy";
>> +               reg = <0x125B0000 0x100>;
>> +               ranges;
>> +
>> +               clocks = <&clock 2>, <&clock 305>;
>> +               clock-names = "xusbxti", "otg";
>> +               status = "disabled";
>
> I don't think this node has any other board specific dependencies. In
> that case you don't need to disable this.
>
>> +
>> +               usbphy-sys {
>> +                       /* USB device and host PHY_CONTROL registers */
>> +                       reg = <0x10020704 0xc>,
>> +                             <0x1001021c 0x4>;
>> +               };
>> +       };
>>  };
>> --
>> 1.7.9.5
>>
>
>
>
> --
> With warm regards,
> Sachin
