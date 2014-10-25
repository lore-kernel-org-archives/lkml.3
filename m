Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaJYUPj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 16:15:39 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:50204 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaJYUPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 16:15:37 -0400
Message-ID: <544C04E6.50401@kernel.org>
Date: Sat, 25 Oct 2014 21:15:34 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
CC: linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, cpgs@samsung.com, grundler@chromium.org,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH v2 0/3] iio: exynos-adc: use syscon instead of ioremap
References: <1410857931-4980-1-git-send-email-ch.naveen@samsung.com> <541EC1C2.6090608@kernel.org> <5436EA85.90900@kernel.org>
In-Reply-To: <5436EA85.90900@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/14 21:05, Jonathan Cameron wrote:
> On 21/09/14 13:17, Jonathan Cameron wrote:
>> On 16/09/14 09:58, Naveen Krishna Chatradhi wrote:
>>> Changes since v1:
>>> 1. Rebased on top of togreg branch of IIO git.
>>>
>>> This patch set does the following
>>> 1. Use the syscon and Regmap API instead of ioremappaing the
>>>    ADC_PHY register from PMU.
>>> 2. Updates the Documentation in exynos-adc.txt with syscon phandle
>>>    for the ADC nodes.
>>> 3. Updates the Dts files for Exynos3250, Exynos4x12, Exynos5250,
>>>    Exynos5420 with the syscon phandle.
>>>
>>> Tested on Exynos5420 based Peach PIT and Exynos5800 based Peach PI
>>> by verifying sysfs entries provided by HWMON based NTC thermistors.
>>>
>>> Tested-By for Exynos3250, Exynos4x12 would be appreciated.
>> Would definitely be good!
>>
>> The main issue I have with this series is that it breaks backward
>> compatibility with old device trees and newer kernels.
>>
>> Now I appreciate that sometimes there are reasons to do it but want this
>> to have deeper consideration (and acks to show it) from the Exynos side
>> of things and preferably from the device tree side of things as well.
>>
>> cc'd Kukjin Kim for the Exynos side of things as the listed Maintainer.
>>
>> Otherwise, the series looks fine to me.
> Kukjin? Sorry to pester, but this has been sat in my waiting queue for a
> while now.
This is still sitting here waiting for those acks from Exynos side of things.
I'm happy to let this sit indefinitely, but does seem a little silly.
>>>
>>> Naveen Krishna Chatradhi (3):
>>>   iio: exyno-adc: use syscon for PMU register access
>>>   Documentation: dt-bindings: update exynos-adc.txt with syscon handle
>>>   ARM: dts: exynos: Add sysreg phandle to ADC node
>>>
>>>  .../devicetree/bindings/arm/samsung/exynos-adc.txt |    9 ++++--
>>>  arch/arm/boot/dts/exynos3250.dtsi                  |    3 +-
>>>  arch/arm/boot/dts/exynos4x12.dtsi                  |    3 +-
>>>  arch/arm/boot/dts/exynos5250.dtsi                  |    3 +-
>>>  arch/arm/boot/dts/exynos5420.dtsi                  |    3 +-
>>>  drivers/iio/adc/exynos_adc.c                       |   30 ++++++++++++++------
>>>  6 files changed, 36 insertions(+), 15 deletions(-)
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
