Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaKLVIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 16:08:31 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:51292 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbaKLVI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 16:08:28 -0500
MIME-Version: 1.0
In-Reply-To: <20141110233630.GD31454@atomide.com>
References: <1415051968-4878-1-git-send-email-marek@goldelico.com>
	<1415051968-4878-5-git-send-email-marek@goldelico.com>
	<20141110233630.GD31454@atomide.com>
Date: Wed, 12 Nov 2014 22:02:52 +0100
Message-ID: <CAAfyv34sPAa94dYM1QoHKEX+MN8NMnzE91HLhXW6MG1Yr=o8mQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] arm: dts: omap3-gta04: Add static configuration for
 devconf1 register
From: Belisko Marek <marek.belisko@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-fbdev@vger.kernel.org,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Tue, Nov 11, 2014 at 12:36 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Marek Belisko <marek@goldelico.com> [141103 14:01]:
>> gta04 board need for tvout enabled 2 bits in devconf1 register (tvbypass and acbias).
>> Add single pinmux entry and enable it.
>>
>> Signed-off-by: Marek Belisko <marek@goldelico.com>
>> ---
>>  arch/arm/boot/dts/omap3-gta04.dtsi | 22 ++++++++++++++++++++++
>>  1 file changed, 22 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
>> index e4d05f0..a456d37 100644
>> --- a/arch/arm/boot/dts/omap3-gta04.dtsi
>> +++ b/arch/arm/boot/dts/omap3-gta04.dtsi
>> @@ -118,6 +118,17 @@
>>                       };
>>               };
>>       };
>> +
>> +     /* pinmux for devconf1 */
>> +     control_devconf1: pinmux@480022d8 {
>> +             compatible = "pinctrl-single";
>> +             reg = <0x480022d8 4>;   /* single register */
>> +             #address-cells = <1>;
>> +             #size-cells = <0>;
>> +             pinctrl-single,bit-per-mux;
>> +             pinctrl-single,register-width = <32>;
>> +             pinctrl-single,function-mask = <0xfc0bd5>;
>> +     };
>>  };
>>
>
> The pinctrl-single entry should be in omap3.dtsi as the mux register is there
> for all the omap3 devices, can you please update the patch for that?
Ok I'll do. Just one question. I checked TRM for omap3430 and omap3630 and
reserved bits in devconf1 are different. So keep function-mask for
omap3430 in omap3.dtsi
and redefine in omap36xx.dtsi (not sure if this will work in this
way)? Or exist other way how to deal with that? Thanks.
>
> Regards,
>
> Tony
>
>>  &omap3_pmx_core {
>> @@ -497,3 +508,14 @@
>>               };
>>       };
>>  };
>> +
>> +&control_devconf1 {
>> +     pinctrl-name = "default";
>> +     pinctrl-0 = < &tv_acbias_pins>;
>> +
>> +     tv_acbias_pins: pinmux_tv_acbias_pins {
>> +             pinctrl-single,bits = <
>> +                     0 0x40800 0x40800
>> +             >;
>> +     };
>> +};
>> --
>> 1.9.1
>>

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
