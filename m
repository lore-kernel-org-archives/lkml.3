Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbaGQLrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:47:43 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:32943 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbaGQLrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:47:39 -0400
MIME-Version: 1.0
In-Reply-To: <53C56FB1.2040700@kernel.org>
References: <1405069589-10388-1-git-send-email-ch.naveen@samsung.com>
 <53C56F40.1070304@kernel.org> <53C56FB1.2040700@kernel.org>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Thu, 17 Jul 2014 17:17:18 +0530
Message-ID: <CAHfPSqDqJuhsMMocpz0jWxJhAuFQDpfssNB3kFN9bMcaPGtH0g@mail.gmail.com>
Subject: Re: [PATCH 0/4] iio: exynos-adc: use syscon instead of ioremap
To: Jonathan Cameron <jic23@kernel.org>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        cw00.choi@samsung.com, gregkh@linuxfoundation.org, lars@metafoo.de,
        cpgs@samsung.com, grundler@chromium.org,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jonathan,

On 15 July 2014 23:45, Jonathan Cameron <jic23@kernel.org> wrote:
> On 15/07/14 19:13, Jonathan Cameron wrote:
>>
>> On 11/07/14 10:06, Naveen Krishna Chatradhi wrote:
>>>
>>> This patch does the following
>>> 1. Use the syscon and Regmap API instead of ioremappaing the
>>>     ADC_PHY register from PMU.
>>> 2. Moves the exynos-adc.txt from bindings/arm/samsung/
>>>     to bindings/iio/adc/.
>>> 3. Updates the Documentation in exynos-adc.txt with syscon phandle
>>>     for the ADC nodes.
>>> 4. Updates the Dts files for Exynos3250, Exynos4x12, Exynos5250,
>>>     Exynos5420 with the syscon phandle.
>>>
>>> Tested on Exynos5420 based Peach PIT and Exynos5800 based Peach PI
>>> by verifying sysfs entries provided by HWMON based NTC thermistors.
>>>
>>> Tested-By for Exynos3250, Exynos4x12 would be appreciated.
>>>
>> This series all looks fine to me.  Took me a minute to work out what the
>> point
>> of the syscon change was (perhaps a little description in the cover letter
>> would have been nice ;)
>>
>> Anyhow, with the device tree changes in here we'll have to let it sit for
>> a while.  I'll also definitely want an ack from
>> Kukjin Kim <kgene.kim@samsung.com> for the device tree changes.
>
> Although I haven't tried it, I'd imagine this might cause a little bit
> of merging fun with the other exynos series waiting for Kukjin to
> ack...

I've tried to rebase on top of Chongwoo's v5 version changes for Exynos5320.
there is one conflict with Documentation. I've submitted the v2 version.

> [PATCHv5 0/4] iio: adc: exynos_adc: Support Exynos3250 ADC and code clean
>>
>>
>> Jonathan
>>>
>>> Naveen Krishna Chatradhi (4):
>>>    iio: exyno-adc: use syscon for PMU register access
>>>    Documentation: dt-bindings: move exynos-adc.txt to more iio/adc/
>>>    Documentation: dt-bindings: update exynos-adc.txt with syscon handle
>>>    ARM: dts: exynos: Add sysreg phandle to ADC node
>>>
>>>   .../devicetree/bindings/arm/samsung/exynos-adc.txt |   82
>>> ------------------
>>>   .../devicetree/bindings/iio/adc/exynos-adc.txt     |   87
>>> ++++++++++++++++++++
>>>   arch/arm/boot/dts/exynos3250.dtsi                  |    3 +-
>>>   arch/arm/boot/dts/exynos4x12.dtsi                  |    3 +-
>>>   arch/arm/boot/dts/exynos5250.dtsi                  |    3 +-
>>>   arch/arm/boot/dts/exynos5420.dtsi                  |    3 +-
>>>   drivers/iio/adc/exynos_adc.c                       |   29 +++++--
>>>   7 files changed, 115 insertions(+), 95 deletions(-)
>>>   delete mode 100644
>>> Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>>>   create mode 100644
>>> Documentation/devicetree/bindings/iio/adc/exynos-adc.txt
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



-- 
Regards,
(: Naveen :)
