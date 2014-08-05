Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbaHEMGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:06:48 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44757 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaHEMGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:06:45 -0400
Message-ID: <53E0C8CE.6050203@linaro.org>
Date: Tue, 05 Aug 2014 14:06:38 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v3 0/4] ARM: EXYNOS: cpuidle: fix AFTR mode on boards
 with secure firmware enabled
References: <1404926274-18411-1-git-send-email-b.zolnierkie@samsung.com> <53D5FF06.6080904@linaro.org> <1616004.BFfRa8qesz@amdc1032>
In-Reply-To: <1616004.BFfRa8qesz@amdc1032>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 02:04 PM, Bartlomiej Zolnierkiewicz wrote:
>
> Hi Daniel,
>
> On Monday, July 28, 2014 09:43:02 AM Daniel Lezcano wrote:
>> On 07/09/2014 07:17 PM, Bartlomiej Zolnierkiewicz wrote:
>>> Hi,
>>>
>>> This patch series adds support for AFTR idle mode on boards with
>>> secure firmware enabled and allows EXYNOS cpuidle driver usage on
>>> Exynos4x12 SoCs.
>>>
>>> It has been tested on Trats2 board (using Exynos4412 SoC with secure
>>> firmware enabled) on which AFTR mode reduces power consumption by ~12%
>>> when EXYNOS cpuidle driver is enabled (in both cases the default
>>> exynos_defconfig config is used and CPU1-3 are offlined).
>>
>>
>> Hi Bartlomiej,
>>
>> what is the status of this patchset ? Is it supposed to land for 3.17 ?
>
> I posted v4 yesterday:
> http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35197.html
>
> When it comes to merging the patchset for 3.17 it is up to Kukjin.

Ok, thanks for the sync up.

   -- Daniel

> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>
>> Thanks
>>
>>     -- Daniel
>>
>>> v3:
>>> - rebased on top of next-20140708 +
>>>     http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32809.html
>>>     (with rejects fixed)
>>>     http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32808.html
>>>     http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32991.html
>>>     (with rejects fixed in patch #2)
>>> - addressed review comments from Tomasz Figa and Daniel Lezcano
>>>
>>> Best regards,
>>> --
>>> Bartlomiej Zolnierkiewicz
>>> Samsung R&D Institute Poland
>>> Samsung Electronics
>>>
>>>
>>> Bartlomiej Zolnierkiewicz (4):
>>>     ARM: EXYNOS: PM: replace EXYNOS_BOOT_VECTOR_* macros by static inlines
>>>     ARM: EXYNOS: add AFTR mode support to firmware do_idle method
>>>     ARM: EXYNOS: cpuidle: add secure firmware support to AFTR mode code
>>>     ARM: EXYNOS: cpuidle: allow driver usage on Exynos4x12 SoCs
>>>
>>>    arch/arm/include/asm/firmware.h  |  2 +-
>>>    arch/arm/mach-exynos/common.h    |  7 ++++++-
>>>    arch/arm/mach-exynos/exynos.c    |  3 ++-
>>>    arch/arm/mach-exynos/firmware.c  | 36 ++++++++++++++++++++++++++----------
>>>    arch/arm/mach-exynos/pm.c        | 39 +++++++++++++++++++++++++++++----------
>>>    drivers/cpuidle/cpuidle-exynos.c |  6 +++---
>>>    6 files changed, 67 insertions(+), 26 deletions(-)
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

