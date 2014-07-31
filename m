Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaGaFAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 01:00:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbaGaFAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 01:00:46 -0400
Message-ID: <53D9CD78.2050207@suse.de>
Date: Thu, 31 Jul 2014 07:00:40 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>
CC: "'Olof Johansson'" <olof@lixom.net>, linux-samsung-soc@vger.kernel.org,
        "'Tarek Dakhran'" <t.dakhran@samsung.com>,
        "'Kevin Hilman'" <khilman@linaro.org>,
        "'Pankaj Dubey'" <pankaj.dubey@samsung.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ajay Kumar <ajaykumar.rs@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH 0/3] ARM: EXYNOS: Fix Exynos5410 boot
References: <1406463725-4208-1-git-send-email-afaerber@suse.de> <53D4EFBB.6000404@suse.de> <00c901cfa9fc$727b4e10$5771ea30$@samsung.com> <CAOesGMjh=xMZ3vB45ofh=CLjTFDMQxSxus5q_P67XQSbwg6-+A@mail.gmail.com> <03f501cfac5c$2c69be90$853d3bb0$@samsung.com> <53D9BF09.7060002@suse.de>
In-Reply-To: <53D9BF09.7060002@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 31.07.2014 05:59, schrieb Andreas Färber:
> Hi Kukjin,
> 
> Am 31.07.2014 03:10, schrieb Kukjin Kim:
>> Olof Johansson wrote:
>>>
>>> Hi,
>>>
>> Hi Olof,
>>
>>> On Sun, Jul 27, 2014 at 5:39 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
>>>> Andreas Färber wrote:
>>>>>
>>>>> Am 27.07.2014 14:22, schrieb Andreas Färber:
>>>>>> Hello,
>>>>>>
>>>>>> This mini-series unbreaks booting on 5410 based ODROID-XU.
>>>>>>
>>>>>> Since I do not have access to a TRM, the address is a guess based on
>>>>>> 5250 and 5410. Such a node was not present in the 3.14 downstream tree.
>>>>>
>>>>> s/5410/5420/
>>>>>
>>>> OK.
>>>>
>>>>>>
>>>>>> Regards,
>>>>>> Andreas
>>>>>>
>>>>>> Andreas Färber (3):
>>>>>>   Documentation: devicetree: Document exynos5410 PMU
>>>>>>   ARM: dts: exynos: Add PMU to Exynos5410
>>>>>>   ARM: EXYNOS: Add support for Exynos5410 PMU
>>>>>>
>>>>>>  Documentation/devicetree/bindings/arm/samsung/pmu.txt | 1 +
>>>>>>  arch/arm/boot/dts/exynos5410.dtsi                     | 5 +++++
>>>>>>  arch/arm/mach-exynos/exynos.c                         | 1 +
>>>>>>  3 files changed, 7 insertions(+)
>>>>>
>>>> Andreas, thanks.
>>>>
>>>> I'll apply this whole series.
>>>
>>> We're getting close to the merge window. I'd prefer not to have to
>>> start reverting samsung code to recover from these regressions, so
>>> please send this up very soon.
>>>
>> Thanks for your gentle reminder.
>>
>> BTW I'm waiting for exynos5250-spring support from Andreas and I'd like to get
>> confirmation about that from Doug. And I'm looking at s2r related patches now.
>>
>> OK, I will send out current samsung tree tonight in my time anyway.
> 
> That would be kind.
> 
> Patches 2-3 in spring v3 should be non-functional snow refactorings for
> you to consider, but untested by me; patch 1 you could skip if you
> modify patch 2, if necessary. As for patch 4, you can see from my
> spring-next branch [1] how I am successfully testing it with a TEST_ONLY
> patch: For simplefb usage I comment out the /dp-controller node to avoid
> drm/exynos detection (not enabling the driver in the user's .config
> would be an alternative); when I run into issues with the drm during
> testing, I can usually ssh in via USB ethernet/wifi.
> 
> In the dmesg for drm/exynos bridge series testing [2] (which I guess is
> not gonna hit 3.17 any more?) I noticed that the USB3503 /usb-hub node
> new in v3 is not working yet (complains about lack of #gpio-cells, I
> guess for my reset-gpios property), not sure how to fix, so we/you could
> probably just drop that node - preparing to test that now.

Misread that message, it does not seem to be fatal. I do see the device
as /sys/devices/usb-hub.

[    0.618757] of_get_named_gpiod_flags: can't parse gpios property of
node '/usb-hub[0]'
[    0.618763] of_get_named_gpiod_flags: can't parse gpios property of
node '/usb-hub[0]'
[    0.618777] /usb-hub: could not get #gpio-cells for
/pinctrl@13400000/hsic-reset
[    0.620743] of_get_named_gpiod_flags: can't parse gpios property of
node '/usb-hub[0]'
[    0.629797] usb3503 usb-hub: switched to HUB mode
[    0.631752] usb3503 usb-hub: usb3503_probe: probed in hub mode

Andreas

> As for the rest of patch 4, it's a new DT, so we could fix up any
> remaining bugs during 3.17 RC cycle, if it looks sane to you guys now. I
> had replied to two series - namely cpufreq [3] and dwmmc [4] - where
> merge conflicts might arise. Let me know if you need a respin for anything.
> 
> Regards,
> Andreas
> 
> [1] https://github.com/afaerber/linux/commits/spring-next
> [2]
> http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34927.html
> [3]
> http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34807.html
> [4]
> http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34898.html
> 


-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
