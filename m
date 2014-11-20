Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbaKTF7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 00:59:05 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:62717 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaKTF7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 00:59:02 -0500
MIME-Version: 1.0
In-Reply-To: <546C4EFD.5030604@samsung.com>
References: <1415452601-13078-1-git-send-email-amit.daniel@samsung.com>
	<CADGdYn46=X1FS7TWp=qCDsm3J9Xg=pEZb945X8tfwc0k6thfvQ@mail.gmail.com>
	<546C4EFD.5030604@samsung.com>
Date: Thu, 20 Nov 2014 11:29:01 +0530
X-Google-Sender-Auth: 4Nka1LIZLNJtaANLIUpi24RWpwA
Message-ID: <CADGdYn5pMaiPi7rwd8006fc9sKhn56d9r8hzLwkLAjMhGBPxZA@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] exynos: Move pmu driver to driver/soc folder and
 add exynos7 support
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Lee Jones <lee.jones@linaro.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 1:34 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> On 11/13/14 17:56, amit daniel kachhap wrote:
>> On Sat, Nov 8, 2014 at 6:46 PM, Amit Daniel Kachhap
>> <amit.daniel@samsung.com> wrote:
>>> This patch series[1 - 6] performs,
>>>
>>> 1) Moves pmu driver to driver/soc/samsung folder. Some discussion happened about
>>>    this in the v1 version. Finally adding it in driver/soc folder as it too SoC
>>>    specific and not a general driver. Entire discussion can be found here (A).
>>> 2) Registers this driver as MFD client driver. This will be used by clients like exynos pm
>>>    sleep and pm domain driver.
>>> 3) Add exynos7 PMU support.
>>>
>>> Changes from V1:
>>> * Move pmu driver in driver/soc/samsung folder
>>> * Removed the power domain features. They will posted as a separate series.
>>> * Added exynos7 PMU support.
>>> * Link to v1 can be found here (B)
>>>
>>> This patch has dependency on following patches posted earlier by Pankaj (C),
>>> which is accepted by maintainer.
>>>
>>> Patch 6 was earlier posted by Abhilash (D) which has been reposted here with some
>>> extra changes.
>>>
>>> This complete patch series is rebased on linux-next.
>>>
>>> (A) - http://www.spinics.net/lists/linux-samsung-soc/msg38444.html
>>> (B) - http://www.spinics.net/lists/linux-samsung-soc/msg38442.html
>>> (C) - https://lkml.org/lkml/2014/10/6/581
>>> (D) - http://www.spinics.net/lists/arm-kernel/msg358230.html
>>>
>>> Amit Daniel Kachhap (6):
>>>   ARM: EXYNOS: Move pmu specific header files under "linux/soc/samsung"
>>>   drivers: soc: Add support for Exynos PMU driver
>>>   drivers: soc: samsung: Fix a spelling mistake
>>>   soc: samsung: exynos-pmu: Register exynos-pmu driver as a mfd driver
>>>   driver: soc: exynos-pmu: Add an API to be called after wakeup
>>>   drivers: soc: samsung: Add support for Exynos7 pmu
>>>
>>>  .../devicetree/bindings/arm/samsung/pmu.txt        |    1 +
>>>  arch/arm/mach-exynos/Makefile                      |    2 +-
>>>  arch/arm/mach-exynos/exynos.c                      |    2 +-
>>>  arch/arm/mach-exynos/mcpm-exynos.c                 |    2 +-
>>>  arch/arm/mach-exynos/platsmp.c                     |    2 +-
>>>  arch/arm/mach-exynos/pm.c                          |    4 +-
>>>  arch/arm/mach-exynos/regs-pmu.h                    |  335 -----------
>>>  arch/arm/mach-exynos/suspend.c                     |    3 +-
>>>  drivers/soc/Kconfig                                |    1 +
>>>  drivers/soc/Makefile                               |    1 +
>>>  drivers/soc/samsung/Kconfig                        |   19 +
>>>  drivers/soc/samsung/Makefile                       |    1 +
>>>  .../pmu.c => drivers/soc/samsung/exynos-pmu.c      |  471 ++++++++++++++-
>>
>> Hi Olof/Kukjin,
>>
>> I am not sure that driver/soc/samsung/* shall go in whose tree.
>> I am preparing the next version so if any comment from your side
>> please let me know.
>>
> In my opinion, it should be sent out via samsung tree because some PM
> related changes are in samsung tree and I'd like to apply exynos7 stuff
> in samsung tree as well... Please make sure your patches are based on
> top of samsung tree.
Thanks for clarification, Just posted the v3 version on top Samsung
for-next tree.

Regards,
Amit
>
> - Kukjin
>
>> Regards,
>> Amit
>>
>>>  .../linux/soc/samsung}/exynos-pmu.h                |    6 +
>>>  include/linux/soc/samsung/exynos-regs-pmu.h        |  608 ++++++++++++++++++++
>>>  15 files changed, 1109 insertions(+), 349 deletions(-)
>>>  delete mode 100644 arch/arm/mach-exynos/regs-pmu.h
>>>  create mode 100644 drivers/soc/samsung/Kconfig
>>>  create mode 100644 drivers/soc/samsung/Makefile
>>>  rename arch/arm/mach-exynos/pmu.c => drivers/soc/samsung/exynos-pmu.c (50%)
>>>  rename {arch/arm/mach-exynos => include/linux/soc/samsung}/exynos-pmu.h (78%)
>>>  create mode 100644 include/linux/soc/samsung/exynos-regs-pmu.h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
