Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab3LGNLw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 08:11:52 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35275 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3LGNLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 08:11:48 -0500
MIME-Version: 1.0
In-Reply-To: <52A30ADB.7090106@schinagl.nl>
References: <1386159055-10264-1-git-send-email-oliver@schinagl.nl>
 <1386159055-10264-4-git-send-email-oliver@schinagl.nl> <20131206183339.GG24519@lukather>
 <52A30ADB.7090106@schinagl.nl>
From: Michal Suchanek <hramrach@gmail.com>
Date: Sat, 7 Dec 2013 14:11:06 +0100
Message-ID: <CAOMqctQShFgMRNKgw1VU86V6X-OfjRP2_KcMJisERegPokMJ3w@mail.gmail.com>
Subject: Re: [linux-sunxi] Re: [PATCH 3/3] ARM: sunxi: dts: Add ahci support
 to a few A10 and A20 boards
To: linux-sunxi <linux-sunxi@googlegroups.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Oliver Schinagl <oliver@schinagl.nl>, Tejun Heo <tj@kernel.org>,
        grant.likely@linaro.org,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        linux-ide@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>, dev@linux-sunxi.org,
        Ian Campbell <ijc@hellion.org.uk>, Hans De Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 December 2013 12:47, Olliver Schinagl <oliver+list@schinagl.nl> wrote:
> Hey maxime,
>
> On 06-12-13 19:33, Maxime Ripard wrote:
>>
>> Hi Oliver,
>>
>> On Wed, Dec 04, 2013 at 01:10:55PM +0100, oliver@schinagl.nl wrote:
>>>
>>> From: Oliver Schinagl <oliver@schinagl.nl>
>>>
>>> This patch adds sunxi sata support to A10 and A20 boards that have such
>>> a connector. Some boards also feature a regulator via a GPIO and support
>>> for this is also added.
>>>
>>> Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
>>
>>
>> Your git setup seems to be pretty uncertain about how your first name is
>> spelled :)
>
> I should have formally mention it to confuse less people,
>
> This is how officially my name is spelled (I left out any 'middle' letters.
> I never really used it as such, as it confuses people and they always write
> it wrong anyway. After years I decided that at least on these patches, I
> should write it down properly (googleability etc in the future). So formally
> it's Olliver 'oliver' M. Schinagl.
>
> And no, I won't share my middle name :p
>
> There! :)
>
>>
>>> ---
>>>   arch/arm/boot/dts/sun4i-a10-cubieboard.dts      | 26
>>> +++++++++++++++++++++++++
>>>   arch/arm/boot/dts/sun4i-a10.dtsi                |  9 +++++++++
>>>   arch/arm/boot/dts/sun7i-a20-cubieboard2.dts     | 26
>>> +++++++++++++++++++++++++
>>>   arch/arm/boot/dts/sun7i-a20-cubietruck.dts      | 26
>>> +++++++++++++++++++++++++
>>>   arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts | 26
>>> +++++++++++++++++++++++++
>>>   arch/arm/boot/dts/sun7i-a20.dtsi                |  9 +++++++++
>>>   6 files changed, 122 insertions(+)
>>
>>
>> Could you split this into several patches please?
>
> Yes, appologies, will take care of this! Sorry,
>
> Oliver
>
>>
>> At least one per SoC.
>>
>>> diff --git a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
>>> b/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
>>> index 425a7db..b620084 100644
>>> --- a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
>>> +++ b/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
>>> @@ -42,7 +42,18 @@
>>>                         };
>>>                 };
>>>
>>> +               sata: ahci@01c18000 {
>>> +                       pwr-supply = <&reg_ahci_5v>;
>>> +                       status = "okay";
>>> +               };
>>> +
>>>                 pinctrl@01c20800 {
>>> +                       ahci_pwr_pin: ahci_pwr_pin@0 {
>>
>>
>> Please prefix it with name of the board.
>>
>>> +                               allwinner,pins = "PB8";
>>> +                               allwinner,function = "gpio_out";
>>> +                               allwinner,driver = <0>;
>>> +                               allwinner,pull = <0>;
>>> +                       };
>>
>>
>> Please add a newline here.
>>
>>>                         led_pins_cubieboard: led_pins@0 {
>>>                                 allwinner,pins = "PH20", "PH21";
>>>                                 allwinner,function = "gpio_out";
>>> @@ -86,4 +97,19 @@
>>>                         linux,default-trigger = "heartbeat";
>>>                 };
>>>         };
>>> +
>>> +       regulators {
>>> +               compatible = "simple-bus";
>>> +               pinctrl-names = "default";
>>> +
>>> +               reg_ahci_5v: ahci-5v {
>>> +                       compatible = "regulator-fixed";
>>> +                       regulator-name = "ahci-5v";
>>> +                       regulator-min-microvolt = <5000000>;
>>> +                       regulator-max-microvolt = <5000000>;
>>> +                       pinctrl-0 = <&ahci_pwr_pin>;
>>> +                       gpio = <&pio 1 8 0>;
>>> +                       enable-active-high;
>>> +               };
>>> +       };
>>>   };
>>> diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi
>>> b/arch/arm/boot/dts/sun4i-a10.dtsi
>>> index 4dccdb0..53c6cdb 100644
>>> --- a/arch/arm/boot/dts/sun4i-a10.dtsi
>>> +++ b/arch/arm/boot/dts/sun4i-a10.dtsi
>>> @@ -306,6 +306,15 @@
>>>                         #size-cells = <0>;
>>>                 };
>>>
>>> +               sata: ahci@01c18000 {
>>> +                       compatible = "allwinner,sun4i-a10-ahci";
>>
>>
>> Please use sun4i-ahci for consistency.
>>
>>> +                       reg = <0x01c18000 0x1000>;
>>> +                       interrupts = <0 56 1>;
>>
>>
>> The interrupt here doesn't seem right. Is it actually working at all?
>>
>>> +                       clocks = <&ahb_gates 25>, <&pll6 0>;
>>> +                       clock-names = "ahb_sata", "pll6_sata";
>>> +                       status = "disabled";
>>> +               };
>>> +
>>>                 intc: interrupt-controller@01c20400 {
>>>                         compatible = "allwinner,sun4i-ic";
>>>                         reg = <0x01c20400 0x400>;
>>> diff --git a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
>>> b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
>>> index 5c51cb8..99c5e78 100644
>>> --- a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
>>> +++ b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
>>> @@ -34,7 +34,18 @@
>>>                         };
>>>                 };
>>>
>>> +               sata: ahci@01c18000 {
>>> +                       pwr-supply = <&reg_ahci_5v>;
>>> +                       status = "okay";
>>> +               };
>>> +
>>>                 pinctrl@01c20800 {
>>> +                       ahci_pwr_pin: ahci_pwr_pin@0 {
>>> +                               allwinner,pins = "PB8";
>>> +                               allwinner,function = "gpio_out";
>>> +                               allwinner,drive = <0>;
>>> +                               allwinner,pull = <0>;
>>> +                       };
>>
>>
>> Please add a newline here.
>>
>>>                         led_pins_cubieboard2: led_pins@0 {
>>>                                 allwinner,pins = "PH20", "PH21";
>>>                                 allwinner,function = "gpio_out";
>>> @@ -77,4 +88,19 @@
>>>                         gpios = <&pio 7 20 0>;
>>>                 };
>>>         };
>>> +
>>> +       regulators {
>>> +               compatible = "simple-bus";
>>> +               pinctrl-names = "default";
>>> +
>>> +               reg_ahci_5v: ahci-5v {
>>> +                       compatible = "regulator-fixed";
>>> +                       regulator-name = "ahci-5v";
>>> +                       regulator-min-microvolt = <5000000>;
>>> +                       regulator-max-microvolt = <5000000>;
>>> +                       pinctrl-0 = <&ahci_pwr_pin>;
>>> +                       gpio = <&pio 1 8 0>;
>>> +                       enable-active-high;
>>> +               };
>>> +       };
>>>   };
>>> diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
>>> b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
>>> index 8a1009d..19af23e 100644
>>> --- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
>>> +++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
>>> @@ -19,7 +19,18 @@
>>>         compatible = "cubietech,cubietruck", "allwinner,sun7i-a20";
>>>
>>>         soc@01c00000 {
>>> +               sata: ahci@01c18000 {
>>> +                       pwr-supply = <&reg_ahci_5v>;
>>> +                       status = "okay";
>>> +               };
>>> +
>>>                 pinctrl@01c20800 {
>>> +                       ahci_pwr_pin: ahci_pwr_pin@0 {
>>> +                               allwinner,pins = "PH12";
>>> +                               allwinner,function = "gpio_out";
>>> +                               allwinner,driver = <0>;
>>> +                               allwinner,pull = <0>;
>>> +                       };
>>
>>
>> Please add a newline here.
>>
>>>                         led_pins_cubietruck: led_pins@0 {
>>>                                 allwinner,pins = "PH7", "PH11", "PH20",
>>> "PH21";
>>>                                 allwinner,function = "gpio_out";
>>> @@ -60,4 +71,19 @@
>>>                         gpios = <&pio 7 7 0>;
>>>                 };
>>>         };
>>> +
>>> +       regulators {
>>> +               compatible = "simple-bus";
>>> +               pinctrl-names = "default";
>>> +
>>> +               reg_ahci_5v: ahci-5v {
>>> +                       compatible = "regulator-fixed";
>>> +                       regulator-name = "ahci-5v";
>>> +                       regulator-min-microvolt = <5000000>;
>>> +                       regulator-max-microvolt = <5000000>;
>>> +                       pinctrl-0 = <&ahci_pwr_pin>;
>>> +                       gpio = <&pio 7 12 0>;
>>> +                       enable-active-high;
>>> +               };
>>> +       };
>>>   };
>>> diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
>>> b/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
>>> index ead3013..23ed708 100644
>>> --- a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
>>> +++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
>>> @@ -34,7 +34,19 @@
>>>                         };
>>>                 };
>>>
>>> +               sata: ahci@01c18000 {
>>> +                       pwr-supply = <&reg_ahci_5v>;
>>> +                       status = "okay";
>>> +               };
>>> +
>>>                 pinctrl@01c20800 {
>>> +                       ahci_pwr_pin: ahci_pwr_pin@0 {
>>> +                               allwinner,pins = "PB8";
>>> +                               allwinner,function = "gpio_out";
>>> +                               allwinner,drive = <0>;
>>> +                               allwinner,pull = <0>;
>>> +                       };
>>> +
>>>                         led_pins_olinuxino: led_pins@0 {
>>>                                 allwinner,pins = "PH2";
>>>                                 allwinner,function = "gpio_out";
>>> @@ -91,4 +103,18 @@
>>>                         default-state = "on";
>>>                 };
>>>         };
>>> +
>>> +       regulators {
>>> +               compatible = "simple-bus";
>>> +
>>> +               reg_ahci_5v: ahci-5v {
>>> +                       compatible = "regulator-fixed";
>>> +                       regulator-name = "ahci-5v";
>>> +                       regulator-min-microvolt = <5000000>;
>>> +                       regulator-max-microvolt = <5000000>;
>>> +                       pinctrl-0 = <&ahci_pwr_pin>;
>>> +                       gpio = <&pio 1 8 0>;
>>> +                       enable-active-high;
>>> +               };
>>> +       };
>>>   };
>>> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi
>>> b/arch/arm/boot/dts/sun7i-a20.dtsi
>>> index 0552a64..b72c69e 100644
>>> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
>>> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
>>> @@ -368,6 +368,15 @@
>>>                         };
>>>                 };
>>>
>>> +               sata: ahci@01c18000 {
>>> +                       compatible = "allwinner,sun4i-a10-ahci";
>>> +                       reg = <0x01c18000 0x1000>;
>>> +                       interrupts = <0 56 1>;
>
> Will always fix this to <0 56 4> if i'm not mistaken.

<0 56 1> appears to work on sun7i but sun4i has <56> in the working
DT. The DT you sent has <0 56 1> on sun4i which somehow compiles and
loads as DT but the driver fails.

Thanks

Michal
