Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaJJMZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 08:25:30 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45554 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaJJMZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 08:25:29 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.101.112]
In-Reply-To: <7h8ukolsvx.fsf@deeprootsystems.com>
References: <1412879767-24326-1-git-send-email-javier.martinez@collabora.co.uk>
	<7h8ukolsvx.fsf@deeprootsystems.com>
Date: Fri, 10 Oct 2014 14:25:27 +0200
Message-ID: <CABxcv==bbfoY6=g3P6N2bLw6DqoV8KEpgro5VOdrj6A9OuuTmA@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: exynos_defconfig: re-enable USB gadget and
 max77802 options
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Kevin Hilman <khilman@kernel.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kevin,

On Fri, Oct 10, 2014 at 1:34 AM, Kevin Hilman <khilman@kernel.org> wrote:
> Javier Martinez Canillas <javier.martinez@collabora.co.uk> writes:
>
>> Commit 43eeaa42e03a ("ARM: exynos_defconfig: savedefconfig") removed a
>> set of Kconfig symbols. For most of them there were no functional change
>> since are selected by other Kconfig options or were deprecated but some
>> options are not explicitly selected so they should not had been removed.
>>
>> The options that have to be enabled are USB gadget and the MAX77802 PMIC
>> support which were enabled in commits:
>>
>> 508423bebcda ("ARM: exynos_defconfig: enable USB gadget support")
>> 6e80e3d87549 ("ARM: exynos_defconfig: Enable MAX77802")
>>
>> Enable those options to leave the config in the state before the change.
>>
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>
> Acked-by: Kevin Hilman <khilman@linaro.org>
> Tested-by: Kevin Hilman <khilman@linaro.org>

Thanks for testing.

>
> This is needed to get RTC wakeup from suspend working on
> exynos5800-peach-pi.
>
> Note that the s3c-rtc works fine, but the max77802-rtc doesn't seem to
> work be functional for me:
>
> [    2.408178] max77802-rtc max77802-rtc: rtc core: registered max77802-rtc as rtc0
> [    3.595485] s3c-rtc 101e0000.rtc: rtc core: registered s3c as rtc1
>
> root@(none):/# hwclock --rtc /dev/rtc0
> hwclock: ioctl(RTC_RD_TIME) to /dev/rtc0 to read the time failed:
> Invalid argument
> root@(none):/# hwclock --rtc /dev/rtc1
> Thu Oct  9 23:33:06 2014  -0.111978 seconds
>

Strange, I don't get that error when testing on my Peach Pit with
linux-next + $subject

[    2.311591] max77802-rtc max77802-rtc: rtc core: registered
max77802-rtc as rtc0
[    3.594438] s3c-rtc 101e0000.rtc: rtc core: registered s3c as rtc1

# hwclock --rtc /dev/rtc0
Fri 10 Oct 2014 12:19:23 PM UTC  -0.909103 seconds
# hwclock --rtc /dev/rtc1
Fri 10 Oct 2014 12:19:26 PM UTC  -0.719862 seconds

I'll take a look but if you have a test case that makes it fail
consistently that would be really helpful.

Best regards,
Javier
