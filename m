Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbaFZQjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:39:11 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:48956 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250AbaFZQjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:39:08 -0400
MIME-Version: 1.0
In-Reply-To: <CABxcv=nTfkRkpz_zZuxYHznjDuNgpiKO+FD4MnHi2C_2e32eqA@mail.gmail.com>
References: <1403785148-20792-1-git-send-email-ch.naveen@samsung.com> <CABxcv=nTfkRkpz_zZuxYHznjDuNgpiKO+FD4MnHi2C_2e32eqA@mail.gmail.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Thu, 26 Jun 2014 22:08:47 +0530
Message-ID: <CAHfPSqC2sjkrpYz53QzW1PDSV2E9yfSEnE734JHH1zUONnh=rw@mail.gmail.com>
Subject: Re: [PATCH 0/3] ARM: DTS: create common dtsi for Peach pit and pi boards
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-iio <linux-iio@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "cpgs ." <cpgs@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Javier,

On 26 June 2014 20:51, Javier Martinez Canillas <javier@dowhile0.org> wrote:
> Hello Naveen,
>
> On Thu, Jun 26, 2014 at 2:19 PM, Naveen Krishna Chatradhi
> <ch.naveen@samsung.com> wrote:
>> This patchset does the following
>> 1. Create a common dtsi file cros-exynos-peach.dtsi for
>>    exynos5420-peach-pit.dts and exynos5800-peach-pi.dts
>
> There was some previous discussion in this list about what's the best
> approach to handle common DTS chunks, please take a look to
> http://patchwork.ozlabs.org/patch/362633/.
>
> In summary, there is a common .dtsi file for Daisy based boards
> (arch/arm/boot/dts/exynos5250-cros-common.dtsi) but it seems it turned
> out to do more harm than good since having a single .dtsi for all the
> common DTS chunks is not quite flexible. As more boards gets
> introduced you have to start moving stuff from the common .dtsi file
> to the board .dts.
>
> The same was tried to do for OMAP2+ boards and it turned out that you
> need to either a) create a hierarchy of .dtsi files to model all the
> different board combinations that have similar fragments or b) split
> out isolated DTS fragments on an .dtsi and include a set of this
> fragments.
>
>  For an example of a) you can take a look to
> arch/arm/boot/dts/omap3-overo* and for b) to
> arch/arm/boot/dts/omap-gpmc-smsc9*.dtsi.
>
> For a Peach Pit/Pi specific example of b) you can look at the recent
> arch/arm/boot/dts/cros-ec-keyboard.dtsi file that Doug added for Peach
> Pit/Pi keyboard.

Right. It makes sense to have multiple smaller chunks
that can be included in more boards than having one big chunk
which can only be used for 2 or 3 boards.
But, then i was unsure. If Device Tree communities likes having more
smaller fragment files under one "arch/arm/boot/dts/ directory".


>
> Personally I think that b) is a more flexible and reusable approach.
> So, maybe instead of creating a cros-exynos-peach.dts to contain all
> the common DT nodes you can add a cros-ec-thermistor.dsti file that
> only includes the ADC based Thermistor nodes?

I've started with making a fragment dts naming it "cros-exynos-adc.dts".
Then moved on with an implementation similar to
exynos5250-cros-common.dtsi

>
> Thanks a lot and best regards,
> Javier

Will wait for few more opinions and make a fragment instead of common dtsi.
Thank you a lot for the information and the references.

>
>> 2. Adds the ADC based Thermistor nodes and enables them in peach_pit.dts
>>    and peach_pi.dts
>> 3. Adds the ADC based Thermistor nodes for Exynos5250 based Snow
>> 4. Corrects the vendor prefix for thermistors in exynos4412-trats2.dts
>>
>> Naveen Krishna Chatradhi (3):
>>   ARM: DTS: use new compatible string for thermistors in trats2
>>   ARM: DTS: Add NTC thermistor nodes to Exynos5250 based Snow
>>   ARM: DTS: Add common dts file for Peach PIT and PI along with ADC
>>     nodes
>>
>>  arch/arm/boot/dts/cros-exynos-peach.dtsi   |   41 ++++++++++++++++++++++++++++
>>  arch/arm/boot/dts/exynos4412-trats2.dts    |    4 +--
>>  arch/arm/boot/dts/exynos5250-snow.dts      |   34 +++++++++++++++++++++++
>>  arch/arm/boot/dts/exynos5420-peach-pit.dts |    6 ++++
>>  arch/arm/boot/dts/exynos5800-peach-pi.dts  |    6 ++++
>>  5 files changed, 89 insertions(+), 2 deletions(-)
>>  create mode 100644 arch/arm/boot/dts/cros-exynos-peach.dtsi
>>
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Shine bright,
(: Nav :)
