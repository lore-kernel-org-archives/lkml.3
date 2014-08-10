Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbaHJJPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 05:15:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48619 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbaHJJP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 05:15:28 -0400
Message-ID: <53E73827.7000703@suse.de>
Date: Sun, 10 Aug 2014 10:15:19 +0100
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        "'Stephan van Schaik'" <stephan@synkhronix.com>,
        "'Vincent Palatin'" <vpalatin@chromium.org>,
        "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 05/10] ARM: dts: Move dp_hpd from exynos5250 into smdk5250
 and snow
References: <1406868897-26874-1-git-send-email-afaerber@suse.de> <1406868897-26874-6-git-send-email-afaerber@suse.de> <CAD=FV=WhocoyQ=rU7dU1EPM-PAQq06gg9HhamSOm+BgMDeM8NA@mail.gmail.com> <53DBFE8A.7020505@suse.de> <53DBFF22.3010905@gmail.com> <000e01cfb0a7$25d0ed70$7172c850$%han@samsung.com>
In-Reply-To: <000e01cfb0a7$25d0ed70$7172c850$%han@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

Am 05.08.2014 13:16, schrieb Jingoo Han:
> On Saturday, August 02, 2014 5:57 AM, Tomasz Figa wrote:
>> On 01.08.2014 22:54, Andreas Färber wrote:
>>> Am 01.08.2014 22:33, schrieb Doug Anderson:
>>>> On Thu, Jul 31, 2014 at 9:54 PM, Andreas Färber <afaerber@suse.de> wrote:
>>>>> Spring uses a different GPIO, so this is not a generic SoC piece.
>>>>>
>>>>> Suggested-by: Tomasz Figa <t.figa@samsung.com>
>>>>> Signed-off-by: Andreas Färber <afaerber@suse.de>
>>>>> ---
>>>>>  v5: New (Tomasz Figa)
>>>>>  Frees dp_hpd for Spring.
>>>>>
>>>>>  arch/arm/boot/dts/exynos5250-pinctrl.dtsi | 7 -------
>>>>>  arch/arm/boot/dts/exynos5250-smdk5250.dts | 9 +++++++++
>>>>>  arch/arm/boot/dts/exynos5250-snow.dts     | 7 +++++++
>>>>>  3 files changed, 16 insertions(+), 7 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
>>>>> index 886cfca044ac..ed0e5230514b 100644
>>>>> --- a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
>>>>> +++ b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
>>>>> @@ -581,13 +581,6 @@
>>>>>                         samsung,pin-pud = <0>;
>>>>>                         samsung,pin-drv = <0>;
>>>>>                 };
>>>>> -
>>>>> -               dp_hpd: dp_hpd {
>>>>> -                       samsung,pins = "gpx0-7";
>>>>> -                       samsung,pin-function = <3>;
>>>>> -                       samsung,pin-pud = <0>;
>>>>> -                       samsung,pin-drv = <0>;
>>>>> -               };
>>>>>         };
>>>>>
>>>>>         pinctrl@13400000 {
>>>>> diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
>>>>> index aaa055ac0fe3..5d30fe1dcda4 100644
>>>>> --- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
>>>>> +++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
>>>>> @@ -414,3 +414,12 @@
>>>>>                 };
>>>>>         };
>>>>>  };
>>>>> +
>>>>> +&pinctrl_0 {
>>>>> +       dp_hpd: dp_hpd {
>>>>> +               samsung,pins = "gpx0-7";
>>>>> +               samsung,pin-function = <3>;
>>>>> +               samsung,pin-pud = <0>;
>>>>> +               samsung,pin-drv = <0>;
>>>>> +       };
>>>>> +};
>>>>> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
>>>>> index c4b0c73c736d..a9a2f2743794 100644
>>>>> --- a/arch/arm/boot/dts/exynos5250-snow.dts
>>>>> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
>>>>> @@ -547,6 +547,13 @@
>>>>>  };
>>>>>
>>>>>  &pinctrl_0 {
>>>>> +       dp_hpd: dp_hpd {
>>>>> +               samsung,pins = "gpx0-7";
>>>>> +               samsung,pin-function = <3>;
>>>>> +               samsung,pin-pud = <0>;
>>>>> +               samsung,pin-drv = <0>;
>>>>> +       };
>>>>> +
>>>>
>>>> NAK.  dp_hpd is a generic SoC piece.  Pin function 0 and 1 are GPIOs.
>>>> Pin function 3 is special function.  This pin _is_ the hot plug detect
>>>> pin for display port.  When it's set as special function 3 it goes
>>>> straight into the hot plug logic of the display port controller.
>>>>
>>>> Spring may have had its reasons to detect hot plug events on a GPIO
>>>> instead of using this pin, but that doesn't make this pin any less the
>>>> "hot plug pin".
>>>
>>> Please advise how to handle it then: Should there be two different
>>> pinctrl entries (if so, how should it be named?),
>>
>> IMHO this is the right way. Just name the GPIO variant dp_hpd_gpio.
> 
> Hi Andreas Färber,
> 
> I agree with Tomasz Figa and Doug Anderson.
> Please refer to the following.
> 
> 1. case: Standard HPD pin is used. (smdk5420)
> arch/arm/boot/dts/exynos5420-pinctrl.dts
> 	pinctrl@13400000 {
> 		dp_hpd: dp_hpd {
> 			samsung,pins = "gpx0-7";
> 			samsung,pin-function = <3>;
> 			samsung,pin-pud = <0>;
> 			samsung,pin-drv = <0>;
> 		};
> arch/arm/boot/dts/exynos5420-smdk5420.dts
> 	dp-controller@145B0000 {
> 		pinctrl-names = "default";
> 		pinctrl-0 = <&dp_hpd>;
> 		...
> 
> 2. case: non-standard HPD pin such as GPIO is used. (peach pit)
> arch/arm/boot/dts/exynos5420-peach-pit.dts
> 	pinctrl@13400000 {
> 		dp_hpd_gpio: dp_hpd_gpio {
> 			samsung,pins = "gpx2-6";
> 			samsung,pin-function = <0>;
> 			samsung,pin-pud = <3>;
> 			samsung,pin-drv = <0>;
> 		};
> 	dp-controller@145B0000 {
> 		pinctrl-names = "default";
> 		pinctrl-0 = <&dp_hpd_gpio>;
> 		...
> 		samsung,hpd-gpio = <&gpx2 6 0>;
> 
> So, you need to follow the second case.
> "dp_hpd_gpio" can be used for Spring board.

I believe I already did so in v6 [0]? Please take a look there and let
me know if you still need anything changed. The label name seems
identical, whereas for the node name I adopted the dashes convention.

Thanks,
Andreas

[0] https://patchwork.kernel.org/patch/4664691/

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
