Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaCVMa4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 08:30:56 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:53345 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaCVMaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 08:30:12 -0400
Message-ID: <532D828A.8000108@kernel.org>
Date: Sat, 22 Mar 2014 12:31:06 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        ARM Maintainers <arm@kernel.org>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/15] iio: adc: at91 cleanups and atmel_tsadcc removal
References: <1394040940-18246-1-git-send-email-alexandre.belloni@free-electrons.com> <5325EDAF.4060003@kernel.org> <53296F2B.3010406@atmel.com>
In-Reply-To: <53296F2B.3010406@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/14 10:19, Nicolas Ferre wrote:
> On 16/03/2014 19:30, Jonathan Cameron :
>> On 05/03/14 17:35, Alexandre Belloni wrote:
>>> This patch set is a followup of my previous series: iio: adc: at91 fixes
>>>
>>> I'm sorry it is so long, I made sure this is bissectable.
>> It's a nice series, don't apologise for doing things right!
>>
>> Clearly there are a few outstanding snippets from the reviews so far, but we
>> are getting to the point where we need to agree on a path for this.  I'm
>> happy to take the whole series through the IIO tree if Dmitry and the at91
>> maintainers are happy with that.  If it is considered two invasive form the
>> atmel side then I'm perfectly happy with someone to take it through the relevant
>> platform tree instead.
>
> Jonathan, Dmitry,
>
> Considering the amount of AT91 files touched by this series, I would
> like to take everything through Atmel's git tree and later on arm-soc.
Sure. Just as a warning, there are one or two patches queued up already that this
sits on top of.  Give a spot of bad timing these are too late to go in as fixes
before the release. Might be worth waiting on those hitting Linus' tree sometime
after rc1 before taking this series.
>
>
>> I'm obviously not going to pick it up at all until it has a complete set
>> of at91 maintainer acks though!
>>
>> Realistically it's missed the coming merge window anyway, so we have a fair
>> bit of time.
>
> Yes, I will review Alexandre's v2 series.
>
> Thanks a lot for your review and for having thought about the path that
> these patches would take.
>
> Bye,
>
>
>> Jonathan
>>>
>>> 1-3) The first 3 patches are cleaning up the patform_data used for at91_adc.
>>>
>>> 4-5) Then touchscreen support for older ADCs is added, this allows to use that
>>>        for the sam9m10g45ek.
>>>
>>> 6) Following those modifications, the mach/at91_adc.h is not used anywhere but
>>>      in the at91_adc driver so it is remove and its content (register definitions)
>>>      placed directly in the driver.
>>>
>>> 7-9) at91sam9rl support is added to at91_adc and is used for the at91sam9rl
>>>        based boards.
>>>
>>> 10-11) Prepare the atmel_tsadcc removal by switching sam9rl and sam9g45 to use
>>>          only at91_adc instead of atmel_tsadcc.
>>>
>>> 12-15) atmel_tsadcc removal
>>>
>>>
>>> Alexandre Belloni (15):
>>>     ARM: at91: sam9g45: remove unused platform_data
>>>     ARM: at91: sam9260: remove unused platform_data
>>>     iio: adc: at91: cleanup platform_data
>>>     iio: adc: at91_adc: Add support for touchscreens without TSMR
>>>     ARM: at91: sam9m10g45ek: Add touchscreen support through at91_adc
>>>     iio: adc: at91: remove unused include from include/mach
>>>     iio: adc: at91: add sam9rl support
>>>     ARM: at91: sam9rl: add at91_adc to support adc and touchscreen
>>>     ARM: at91: sam9rlek add touchscreen support through at91_adc
>>>     ARM: at91: sam9g45: switch from atmel_tsadcc to at91_adc
>>>     ARM: at91: sam9rl: switch from atmel_tsadcc to at91_adc
>>>     ARM: at91: remove atmel_tsadcc platform_data
>>>     ARM: at91: remove atmel_tsadcc from sama5_defconfig
>>>     Input: atmel_tsadcc: remove driver
>>>     ARM: at91/dt: at91-cosino_mega2560 remove useless tsadcc node
>>>
>>>    MAINTAINERS                                |   6 -
>>>    arch/arm/boot/dts/at91-cosino_mega2560.dts |   5 -
>>>    arch/arm/configs/at91sam9g45_defconfig     |   3 +-
>>>    arch/arm/configs/at91sam9rl_defconfig      |   3 +-
>>>    arch/arm/configs/sama5_defconfig           |   1 -
>>>    arch/arm/mach-at91/at91sam9260_devices.c   |  10 -
>>>    arch/arm/mach-at91/at91sam9g45.c           |   2 +-
>>>    arch/arm/mach-at91/at91sam9g45_devices.c   |  63 +----
>>>    arch/arm/mach-at91/at91sam9rl.c            |   7 +
>>>    arch/arm/mach-at91/at91sam9rl_devices.c    |  83 +++++--
>>>    arch/arm/mach-at91/board-sam9m10g45ek.c    |  16 +-
>>>    arch/arm/mach-at91/board-sam9rlek.c        |  16 +-
>>>    arch/arm/mach-at91/board.h                 |   3 -
>>>    arch/arm/mach-at91/include/mach/at91_adc.h | 107 ---------
>>>    drivers/iio/adc/at91_adc.c                 | 339 +++++++++++++++++++++++----
>>>    drivers/input/touchscreen/Kconfig          |  12 -
>>>    drivers/input/touchscreen/Makefile         |   1 -
>>>    drivers/input/touchscreen/atmel_tsadcc.c   | 358 -----------------------------
>>>    include/linux/platform_data/at91_adc.h     |  27 +--
>>>    include/linux/platform_data/atmel.h        |   7 -
>>>    20 files changed, 380 insertions(+), 689 deletions(-)
>>>    delete mode 100644 arch/arm/mach-at91/include/mach/at91_adc.h
>>>    delete mode 100644 drivers/input/touchscreen/atmel_tsadcc.c
>>>
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
>
>

