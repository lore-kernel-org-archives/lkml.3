Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab3F1FUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 01:20:00 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:60474 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab3F1FT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 01:19:58 -0400
MIME-Version: 1.0
In-Reply-To: <CADGdYn5RvSNke=RjROrZRNNe0BFYS-et_Z5DUQkhyiZ6Q6F-8Q@mail.gmail.com>
References: <1372071051-3167-1-git-send-email-amit.daniel@samsung.com>
	<51C87E48.4040604@samsung.com>
	<51C8A33E.1000009@ti.com>
	<CADGdYn5RvSNke=RjROrZRNNe0BFYS-et_Z5DUQkhyiZ6Q6F-8Q@mail.gmail.com>
Date: Fri, 28 Jun 2013 10:49:57 +0530
X-Google-Sender-Auth: uOqjiF1_BAO40AXWask2mErEmIg
Message-ID: <CADGdYn6Y1fut3D+RhNbuGE_1DjjMRHCnLBUgKzcHTSKYtAxp-A@mail.gmail.com>
Subject: Re: [PATCH V7 00/30] thermal: exynos: Re-structure driver and add
 support for exynos5440
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-pm@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 5:23 PM, amit daniel kachhap
<amit.daniel@samsung.com> wrote:
> On Tue, Jun 25, 2013 at 1:21 AM, Eduardo Valentin
> <eduardo.valentin@ti.com> wrote:
>> On 24-06-2013 13:13, Kukjin Kim wrote:
>>> On 06/24/13 19:50, Amit Daniel Kachhap wrote:
>>>> Submitting V7 version with all comments fixed. Most of the patches are
>>>> acked by
>>>> Eduardo. All the un-acked patches are modified according to the review
>>>> comments.
>>>> If any comments please let me know.
>>>>
>>>> Thanks,
>>>> Amit Daniel
>>>>
>>>> Changes in V7:
>>>> * Fixed all the coding guidelines comments given by Eduardo.
>>>> * Moved the request irq call below the core thermal registration as
>>>> per discussion
>>>>    with Eduardo.
>>>> * Appropriate logs/TODO's/comments added for some review comments
>>>> which are still
>>>>    same as before,
>>>>    1) calibration register setting still uses enums.
>>>>    2) very few soc check's still left in the driver.
>>>>    3) Cooling devices stored in an array in the exynos core thermal
>>>> layer.
>>>>
>>>> Changes in V6:
>>>> * Uses ARCH_HAS_BANDGAP config flag which is merged now in arm tree.
>>>> (http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7758/1).
>>>> * In this version patches 1, 2, 3, 4 and 30 are modified. Others are
>>>> same as V5.
>>>> * Added acked by from Jonghwa Lee.
>>>> * Rebased against Thermal Maintainer next tree.
>>>>
>>>> Changes in V5:
>>>> * Most of the changes in this version is as per suggestion from
>>>> Jonghwa Lee. I
>>>>   have retained one to one mapping of platform data with TMU instances
>>>> as the
>>>>   TMU's are different devices. In exynos5440 soc there is some register
>>>>   sharing across multiple TMU's but in exynos5420 there is no register
>>>> between
>>>>   multiple TMU's, so the current implementation is useful to support
>>>> both of the
>>>>   above.
>>>>   This patch uses localized ARCH_HAS_TMU Kconfig option and is a
>>>> temporary solution
>>>>   until a more generic macro ARCH_HAS_BANDGAP is introduced as per
>>>> discussion in
>>>>   the link https://patchwork.kernel.org/patch/2659001/.
>>>> * trip type is passed as platform data.
>>>> * HW trip is allowed only for maximum level.
>>>> * Platform data structure is now abstracted inside 1 more structure to
>>>> support
>>>>    multiple sensor TMU data.
>>>>
>>>> Changes in V4:
>>>>   Almost all the changes in this version is as per suggestion from
>>>> Eduardo.The
>>>>   major ones are listed below,
>>>> * Added kconfig symbol ARCH_HAS_TMU which needs to be enabled by
>>>> platform. With
>>>>    this change existing symbol EXYNOS_TMU_DATA is not needed.
>>>> * Movement of freq_clip_table from exynos_tmu.h to
>>>> exynos_thermal_common.h is
>>>>    explained in the commit logs.
>>>> * Wrote all register description documentation.
>>>> * Split 5440 TMU support patch into controller change, configuration
>>>> data and
>>>>    feature addition patches.
>>>> * Remove all *LINUX_* in the header files.
>>>> * Still regulator enable is kept optional but a TODO: comment is added
>>>> to fix
>>>>    it later.
>>>>
>>>> Changes in V3:
>>>> * Added proper dependency of different exynos thermal Kconfig symbols.
>>>> Basically 3
>>>>   Kconfig can be enabled now and corresponds to tmu driver. exynos
>>>> common part
>>>>   and exynos configuration data. This issue was raised by Rui Zhang.
>>>>
>>>> Changes in V2:
>>>> * Separated SOC data from TMU driver. This is as per suggestion from
>>>> Eduardo.
>>>> * Merged the new file created for exynos5440 TMU controller with the
>>>> existing
>>>>   TMU controller code.
>>>> * Removed the DT parsing code as now the SOC specific data are cleanly
>>>> put
>>>>   inside the data specific file.
>>>> * Even the register definations/bitfields are treated as data as there is
>>>>   some variation across SOC's.
>>>>
>>>> This patchset adds TMU(Thermal management Unit) driver support for
>>>> exynos5440 platform. There are 3 instances of the TMU controllers so
>>>> necessary cleanup/re-structure is done to handle multiple thermal zone.
>>>>
>>>> Patch (exynos4: Add documentation for Exynos SoC thermal bindings) from
>>>> Lukasz Majewski is already posted to mainline. Using it as it is needed.
>>>> (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg17817.html)
>>>>
>>>>
>>>> Patch (thermal: exynos: Support thermal tripping ) from Jonghwan Choi is
>>>> added here with some changes.
>>>> (https://patchwork.kernel.org/patch/1668371/)
>>>>
>>>> Patch (thermal: exynos: Support for TMU regulator defined at device tree)
>>>> is a repost of my earlier
>>>> patch(https://patchwork-mail1.kernel.org/patch/2510771/)
>>>> and adds regulator support.
>>>>
>>>> Patch (ARM: dts: Add device tree node for exynos5440 TMU controller) and
>>>> patch (arm: exynos: enable ARCH_HAS_BANDGAP) can be merged through
>>>> exynos platform
>>>> maintainer as this can cause merge conflict.
>>>>
>>>> All these patches are based on thermal maintainers git tree,
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next.
>>>>
>>>> Amit Daniel Kachhap (30):
>>>>    thermal: exynos: Moving exynos thermal files into samsung directory
>>>>    thermal: exynos: Use ARCH_HAS_BANDGAP config to know the supported
>>>>      soc's
>>>>    thermal: exynos: Remove un-necessary CPU_THERMAL dependency
>>>>    thermal: exynos: Bifurcate exynos thermal common and tmu controller
>>>>      code
>>>>    thermal: exynos: Rename exynos_thermal.c to exynos_tmu.c
>>>>    thermal: exynos: Move exynos_thermal.h from include/* to driver/*
>>>>      folder
>>>>    thermal: exynos: Bifurcate exynos tmu driver and configuration data
>>>>    thermal: exynos: Add missing definations and code cleanup
>>>>    thermal: exynos: Add extra entries in the tmu platform data
>>>>    thermal: exynos: Move register definitions from driver to data file
>>>>    thermal: exynos: Support thermal tripping
>>>>    thermal: exynos: Fix to clear only the generated interrupts
>>>>    thermal: exynos: Add support for instance based register/unregister
>>>>    thermal: exynos: Modify private_data to appropriate name driver_data
>>>>    thermal: exynos: Return success even if no cooling data supplied
>>>>    thermal: exynos: Make the zone handling use trip information
>>>>    thermal: exynos: Remove non DT based support
>>>>    thermal: exynos: Add support to handle many instances of TMU
>>>>    thermal: exynos: Add TMU features to check instead of using SOC type
>>>>    thermal: exynos: use device resource management infrastructure
>>>>    thermal: exynos: Add support to access common register for
>>>>      multistance
>>>>    thermal: exynos: Add driver support for exynos5440 TMU sensor
>>>>    thermal: exynos: Add thermal configuration data for exynos5440 TMU
>>>>      sensor
>>>>    thermal: exynos: Fix to set the second point correction value
>>>>    thermal: exynos: Add hardware mode thermal calibration support
>>>>    thermal: exynos: Support for TMU regulator defined at device tree
>>>>    ARM: dts: thermal: exynos: Add documentation for Exynos SoC thermal
>>>>      bindings
>>>>    Documentation: thermal: Explain the exynos thermal driver model
>>>>    ARM: dts: Add device tree node for exynos5440 TMU controller
>>>>    arm: exynos: enable ARCH_HAS_BANDGAP
>>>>
>>>>   .../devicetree/bindings/thermal/exynos-thermal.txt |   55 +
>>>>   Documentation/thermal/exynos_thermal               |   43 +-
>>>>   arch/arm/boot/dts/exynos5440.dtsi                  |   30 +
>>>>   arch/arm/mach-exynos/Kconfig                       |    5 +
>>>>   drivers/thermal/Kconfig                            |   13 +-
>>>>   drivers/thermal/Makefile                           |    2 +-
>>>>   drivers/thermal/exynos_thermal.c                   | 1058
>>>> --------------------
>>>>   drivers/thermal/samsung/Kconfig                    |   18 +
>>>>   drivers/thermal/samsung/Makefile                   |    7 +
>>>>   drivers/thermal/samsung/exynos_thermal_common.c    |  432 ++++++++
>>>>   drivers/thermal/samsung/exynos_thermal_common.h    |  107 ++
>>>>   drivers/thermal/samsung/exynos_tmu.c               |  752
>>>> ++++++++++++++
>>>>   drivers/thermal/samsung/exynos_tmu.h               |  309 ++++++
>>>>   drivers/thermal/samsung/exynos_tmu_data.c          |  250 +++++
>>>>   drivers/thermal/samsung/exynos_tmu_data.h          |  155 +++
>>>>   include/linux/platform_data/exynos_thermal.h       |  119 ---
>>>>   16 files changed, 2160 insertions(+), 1195 deletions(-)
>>>>   create mode 100644
>>>> Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>>>>   delete mode 100644 drivers/thermal/exynos_thermal.c
>>>>   create mode 100644 drivers/thermal/samsung/Kconfig
>>>>   create mode 100644 drivers/thermal/samsung/Makefile
>>>>   create mode 100644 drivers/thermal/samsung/exynos_thermal_common.c
>>>>   create mode 100644 drivers/thermal/samsung/exynos_thermal_common.h
>>>>   create mode 100644 drivers/thermal/samsung/exynos_tmu.c
>>>>   create mode 100644 drivers/thermal/samsung/exynos_tmu.h
>>>>   create mode 100644 drivers/thermal/samsung/exynos_tmu_data.c
>>>>   create mode 100644 drivers/thermal/samsung/exynos_tmu_data.h
>>>>   delete mode 100644 include/linux/platform_data/exynos_thermal.h
>>>>
>>> Hi Eduardo,
>>>
>>> I think, Amit almost addressed comments from you guys, there are several
>>> comments though. And it can be fixed during -rc ;-)
>>>
>>> So please consider pick this series in your tmu tree. If any concerns,
>>> please kindly let me know.
>>>
>>> Note, if any merge conflicts with Samsung DT files, let me check.
>>
>> No concerns so far. I have acked almost all the remaining. There two
>> patches that still need some minor amendment (16 and 25). I am ok to add
>> this series to my tree. But the final pull request to Linus goes via
>> Rui. Rui how do you want to proceed with this series? Do you want me to
>> send you a pull request?
> Hi Eduardo,
>
> thanks for the acks.
> I just submitted the resend version of patch16(cool device size
> fixed), patch 20(due to dependency on patch 16) and patch 25(fixing
> enum issue).
>
> Thanks,
> Amit D
Hi Rui,

Any update on this patch series? Now all 30  patches in V7
version(with RESEND patch 16, 20, 25) are acked by Eduardo.

Thanks,
Amit Daniel
>>
>>>
>>> Thanks,
>>> - Kukjin
>>>
>>>
>>
>>
>> --
>> You have got to be excited about what you are doing. (L. Lamport)
>>
>> Eduardo Valentin
>>
