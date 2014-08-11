Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaHKRrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:47:14 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:37713 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaHKRrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:47:12 -0400
Message-ID: <53E901A6.2020902@collabora.co.uk>
Date: Mon, 11 Aug 2014 19:47:18 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH 2/2] ARM: dts: Add tps65090 FET constraints on
 Peach Pit and Pi
References: <1407757091-18730-1-git-send-email-javier.martinez@collabora.co.uk>	<1407757091-18730-2-git-send-email-javier.martinez@collabora.co.uk> <CAD=FV=XRmNkxXoxWaEfxFADrTgBrOPVX746woxiZoKck1ajwgA@mail.gmail.com>
In-Reply-To: <CAD=FV=XRmNkxXoxWaEfxFADrTgBrOPVX746woxiZoKck1ajwgA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

On 08/11/2014 05:57 PM, Doug Anderson wrote:
> Javier,
> 
> On Mon, Aug 11, 2014 at 4:38 AM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
>> Both Exynos5420 Peach Pit and Exynos5800 Peach Pi boards
>> have a tps65090 PMU that has a number of switches (FETs)
>> that are just on/off devices but they do have a current
>> limit and the output voltage of the switch is ramped up
>> within a controlled slope.
>>
>> After the switch is turned on, a safety timer is started
>> and before this timer times out the output voltage must
>> have reached the input voltage. Otherwise the switch is
>> turned off expecting an overload condition.
>>
>> So using the maximum output voltage slew rate and the timer
>> minimum and maximum timeouts, a voltage constraints can be
>> expressed as bounded limits for the timeout. That is what
>> is used in the board schematics and should be in the DT too.
> 
> I don't understand this, but if you and Mark are happy with it...
> 
> ...I'm also not 100% certain what the above description has to do with
> this change, but I'll admit to having only skimmed some of the earlier
> conversations.
>

As I stated before, I wrongly assumed from where the constraints in the
schematics came from. From the latest doc I now know that there is a
"recommended operating conditions table". I'll fix it in v2, sorry for the
confusion...

> 
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> ---
>>  arch/arm/boot/dts/exynos5420-peach-pit.dts | 14 ++++++++++++++
>>  arch/arm/boot/dts/exynos5800-peach-pi.dts  | 14 ++++++++++++++
>>  2 files changed, 28 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
>> index d8710c1..eefafe6 100644
>> --- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
>> +++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
>> @@ -386,27 +386,41 @@
>>                                         };
>>                                         tps65090_fet1: fet1 {
>>                                                 regulator-name = "vcd_led";
>> +                                               regulator-min-microvolt = <5000000>;
>> +                                               regulator-max-microvolt = <1700000>;
> 
> This is almost certainly wrong.  Your max is smaller than your min.
> Perhaps you want an extra 0.
> 
>>                                         };
>>                                         tps65090_fet2: fet2 {
>>                                                 regulator-name = "video_mid";
>> +                                               regulator-min-microvolt = <4500000>;
>> +                                               regulator-max-microvolt = <5500000>;
>>                                                 regulator-always-on;
>>                                         };
>>                                         tps65090_fet3: fet3 {
>>                                                 regulator-name = "wwan_r";
>> +                                               regulator-min-microvolt = <3000000>;
>> +                                               regulator-max-microvolt = <5500000>;
>>                                                 regulator-always-on;
>>                                         };
>>                                         tps65090_fet4: fet4 {
>>                                                 regulator-name = "sdcard";
>> +                                               regulator-min-microvolt = <3000000>;
>> +                                               regulator-max-microvolt = <5500000>;
>>                                                 regulator-always-on;
>>                                         };
>>                                         tps65090_fet5: fet5 {
>>                                                 regulator-name = "camout";
>> +                                               regulator-min-microvolt = <3000000>;
>> +                                               regulator-max-microvolt = <5500000>;
>>                                         };
>>                                         tps65090_fet6: fet6 {
>>                                                 regulator-name = "lcd_vdd";
>> +                                               regulator-min-microvolt = <3000000>;
>> +                                               regulator-max-microvolt = <5500000>;
>>                                         };
>>                                         tps65090_fet7: fet7 {
>>                                                 regulator-name = "video_mid_1a";
>> +                                               regulator-min-microvolt = <3000000>;
>> +                                               regulator-max-microvolt = <5500000>;
>>                                                 regulator-always-on;
>>                                         };
>>                                         tps65090_ldo1: ldo1 {
>> diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
>> index 07b29b7..5c38bc0 100644
>> --- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
>> +++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
>> @@ -384,27 +384,41 @@
>>                                         };
>>                                         tps65090_fet1: fet1 {
>>                                                 regulator-name = "vcd_led";
>> +                                               regulator-min-microvolt = <5000000>;
>> +                                               regulator-max-microvolt = <1700000>;
> 
> Here, too.
> 
>>                                         };
>>                                         tps65090_fet2: fet2 {
>>                                                 regulator-name = "video_mid";
>> +                                               regulator-min-microvolt = <4500000>;
>> +                                               regulator-max-microvolt = <5500000>;
>>                                                 regulator-always-on;
>>                                         };
>>                                         tps65090_fet3: fet3 {
>>                                                 regulator-name = "wwan_r";
>> +                                               regulator-min-microvolt = <3000000>;
>> +                                               regulator-max-microvolt = <5500000>;
>>                                                 regulator-always-on;
>>                                         };
>>                                         tps65090_fet4: fet4 {
>>                                                 regulator-name = "sdcard";
>> +                                               regulator-min-microvolt = <3000000>;
>> +                                               regulator-max-microvolt = <5500000>;
>>                                                 regulator-always-on;
>>                                         };
>>                                         tps65090_fet5: fet5 {
>>                                                 regulator-name = "camout";
>> +                                               regulator-min-microvolt = <3000000>;
>> +                                               regulator-max-microvolt = <5500000>;
>>                                         };
>>                                         tps65090_fet6: fet6 {
>>                                                 regulator-name = "lcd_vdd";
>> +                                               regulator-min-microvolt = <3000000>;
>> +                                               regulator-max-microvolt = <5500000>;
>>                                         };
>>                                         tps65090_fet7: fet7 {
>>                                                 regulator-name = "video_mid_1a";
>> +                                               regulator-min-microvolt = <3000000>;
>> +                                               regulator-max-microvolt = <5500000>;
>>                                                 regulator-always-on;
>>                                         };
>>                                         tps65090_ldo1: ldo1 {
> 
> Other than 1.7V vs. 17V, this matches what I see in the tps65090
> specifications.  Technically I think that this should also be applied
> to other tps65090 users in mainline since it's a property shared among
> every user of tps65090.  That means exynos5250-snow and
> tegra114-dalmore.  I'd be tempted to say that it belongs in source
> code or in a dts fragment as well.
> 

Agreed, now is clear from the table that these are operating conditions related
to the PMIC and is not a per board value. So since these are constants, they
should be added to the driver source code and not in the DTS. I'll do this in v2
as well.

> -Doug
> 

Best regards,
Javier
