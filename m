Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaBYUeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 15:34:08 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:64718 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaBYUeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 15:34:07 -0500
Message-ID: <530CFE39.7050204@gmail.com>
Date: Tue, 25 Feb 2014 21:34:01 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Linus Walleij <linus.walleij@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: Re: [PATCH 00/10] pinctrl: mvebu: remove hard-coded addresses from
 Dove pinctrl
References: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com> <20140224181023.GA1010@titan.lakedaemon.net> <CACRpkdZ+YGTyDj6i8c198MdRtz3GY-YBmVO9LysPCcmT4EC0cg@mail.gmail.com> <20140225151656.GI1010@titan.lakedaemon.net> <530CB725.5070904@gmail.com> <20140225154347.GJ1010@titan.lakedaemon.net> <530CEDB7.2070103@gmail.com> <20140225200447.GA1872@titan.lakedaemon.net>
In-Reply-To: <20140225200447.GA1872@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 09:04 PM, Jason Cooper wrote:
> Sebastian,
>
> On Tue, Feb 25, 2014 at 08:23:35PM +0100, Sebastian Hesselbarth wrote:
>> [Cooked down Cc list to relevant people and added Ezequiel who agreed
>> to test on Armada 375/38x.]
>>
>> On 02/25/2014 04:43 PM, Jason Cooper wrote:
>>> On Tue, Feb 25, 2014 at 04:30:45PM +0100, Sebastian Hesselbarth wrote:
>>>> On 02/25/14 16:16, Jason Cooper wrote:
>>>>> On Tue, Feb 25, 2014 at 10:36:54AM +0100, Linus Walleij wrote:
>>>>>> On Mon, Feb 24, 2014 at 7:10 PM, Jason Cooper <jason@lakedaemon.net> wrote:
>>>>>>> I've now created mvebu/pinctrl-dove for this series.  It's based on
>>>>>>> v3.14-rc1, and depends on mvebu/pinctrl (which depends on
>>>>>>> mvebu/pinctrl-3xx).
>>>>>>>
>>>>>>> I've kept this series in a separate branch in case we encounter an
>>>>>>> unforeseen problem with something in here.  Then this branch can be
>>>>>>> dropped, and /pinctrl-3xx and /pinctrl will still make it in.
>>>>>>>
>>>>>>> So, all patches except 3 and 4 are in mvebu/pinctrl-dove.  3 and 4 are
>>>>>>> in mvebu/dt.
>>>>>>
>>>>>> OK so what should I be pulling in first now?
>>>>>
>>>>> Of course I woke up this morning not happy with this :-/  Here's what it
>>>>> looks like currently:
>>>>>
>>>>>    /v3.14-rc1
>>>>>    |
>>>>> --+---+---+---+---+ mvebu/pinctrl-3xx
>>>>>    |               \
>>>>>    |---+---+---+---+---+---+---+ mvebu/pinctrl
>>>>>    \                           \
>>>>>     \---------------------------+---+---+---+ mvebu/pinctrl-dove
>>>>>
>>>>> Not to scale.
>>>>>
>>>>>
>>>>> I would prefer to do:
>>>>>
>>>>>    /v3.14-rc1
>>>>>    |
>>>>> --+---+---+---+---+ mvebu/pinctrl-cleanup
>>>>>    |               \
>>>>>    |----------------+--+---+---+ mvebu/pinctrl-3xx
>>>>>    \                \
>>>>>     \----------------+---+---+--+---+---+---+ mvebu/pinctrl-dove
>>>>>
>>>>> But this would mean moving some patches to branches other than what they
>>>>> were sent with.  The advantage is that /pinctrl-3xx and /pinctrl-dove
>>>>> don't depend on each other, and only depend on -cleanup.  Which is great
>>>>> if there is something wrong in either branch.
>>>>>
>>>>> Sebastian, I can cherry-pick the patches around, but you know the code
>>>>> better than any of us, do you foresee any problems with this scenario?
>>>>
>>>> If Thomas agrees, I can rework Armada 375/38x pinctrl stubs to fit on
>>>> mvebu/pinctrl. That should allow you to have mvebu/pinctrl-dove
>>>> independent of mvebu/pinctrl-3xx.
>>>>
>>>> Not a big deal, I'd just pick 375/38x patches from mvebu/pinctrl and
>>>> squash them into mvebu/pinctrl-3xx. The only "issue" is that DT
>>>> documentation update patches from mvebu/pinctrl-dove have to be split
>>>> too.
>>>>
>>>> I'll prepare the three new branches for you and Thomas to look at
>>>> today.
>>>
>>> Ok, great.  Thanks Sebastian!
>>
>> Ok, branches based on v3.14-rc1 with above dependencies can be found on:
>>
>> https://github.com/shesselba/linux-dove.git for-mvebu/pinctrl-cleanup
>> https://github.com/shesselba/linux-dove.git for-mvebu/pinctrl-3xx
>> https://github.com/shesselba/linux-dove.git for-mvebu/pinctrl-dove
>>
>> and an a-i-o branch to ease testing:
>>
>> https://github.com/shesselba/linux-dove.git for-mvebu/all-merged-in
>>
>> @Jason: I guess we should resend all three branches as individual
>> patches on list somehow.
>
> Damn!  So close!
>
> $ git diff mvebu/pinctrl-dove shesselba/for-mvebu/all-merged-in
> diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
> index 2b76524f4aa7..eeb08edb67ac 100644
> --- a/arch/arm/boot/dts/dove.dtsi
> +++ b/arch/arm/boot/dts/dove.dtsi
> @@ -390,7 +390,9 @@
>
>   			pinctrl: pin-ctrl@d0200 {
>   				compatible = "marvell,dove-pinctrl";
> -				reg = <0xd0200 0x10>;
> +				reg = <0xd0200 0x14>,
> +				      <0xd0440 0x04>,
> +				      <0xd802c 0x08>;
>   				clocks = <&gate_clk 22>;
>
>   				pmx_gpio_0: pmx-gpio-0 {
> @@ -614,6 +616,12 @@
>   				interrupts = <5>;
>   			};
>
> +			gconf: global-config@e802c {
> +				compatible = "marvell,dove-global-config",
> +				             "syscon";
> +				reg = <0xe802c 0x14>;
> +			};
> +
>   			gpio2: gpio-ctrl@e8400 {
>   				compatible = "marvell,orion-gpio";
>   				#gpio-cells = <2>;
> diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-38x.c b/drivers/pinctrl/mvebu/pinctrl-armada-38x.c
> index 322ca8cb63eb..1049f82fb62f 100644
> --- a/drivers/pinctrl/mvebu/pinctrl-armada-38x.c
> +++ b/drivers/pinctrl/mvebu/pinctrl-armada-38x.c
> @@ -428,7 +428,6 @@ static int armada_38x_pinctrl_probe(struct platform_device *pdev)
>   		return PTR_ERR(mpp_base);
>
>   	soc->variant = (unsigned) match->data & 0xff;
> -
>   	soc->controls = armada_38x_mpp_controls;
>   	soc->ncontrols = ARRAY_SIZE(armada_38x_mpp_controls);
>   	soc->gpioranges = armada_38x_mpp_gpio_ranges;
>
>
> If you can drop the dtsi changes (I have them in mvebu/dt), and fix the
> whitespace change, then we can merge them as is.

Done.

> Thanks a ton for handling this!

No problem, thanks for resolving the dependencies :)

Sebastian
