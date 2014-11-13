Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbaKMI40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 03:56:26 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:40144 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbaKMI4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 03:56:24 -0500
MIME-Version: 1.0
In-Reply-To: <1415452601-13078-1-git-send-email-amit.daniel@samsung.com>
References: <1415452601-13078-1-git-send-email-amit.daniel@samsung.com>
Date: Thu, 13 Nov 2014 14:26:23 +0530
X-Google-Sender-Auth: X3VmTfOwsK5qJWwYUADIorKDZyU
Message-ID: <CADGdYn46=X1FS7TWp=qCDsm3J9Xg=pEZb945X8tfwc0k6thfvQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] exynos: Move pmu driver to driver/soc folder and
 add exynos7 support
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Lee Jones <lee.jones@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 8, 2014 at 6:46 PM, Amit Daniel Kachhap
<amit.daniel@samsung.com> wrote:
> This patch series[1 - 6] performs,
>
> 1) Moves pmu driver to driver/soc/samsung folder. Some discussion happened about
>    this in the v1 version. Finally adding it in driver/soc folder as it too SoC
>    specific and not a general driver. Entire discussion can be found here (A).
> 2) Registers this driver as MFD client driver. This will be used by clients like exynos pm
>    sleep and pm domain driver.
> 3) Add exynos7 PMU support.
>
> Changes from V1:
> * Move pmu driver in driver/soc/samsung folder
> * Removed the power domain features. They will posted as a separate series.
> * Added exynos7 PMU support.
> * Link to v1 can be found here (B)
>
> This patch has dependency on following patches posted earlier by Pankaj (C),
> which is accepted by maintainer.
>
> Patch 6 was earlier posted by Abhilash (D) which has been reposted here with some
> extra changes.
>
> This complete patch series is rebased on linux-next.
>
> (A) - http://www.spinics.net/lists/linux-samsung-soc/msg38444.html
> (B) - http://www.spinics.net/lists/linux-samsung-soc/msg38442.html
> (C) - https://lkml.org/lkml/2014/10/6/581
> (D) - http://www.spinics.net/lists/arm-kernel/msg358230.html
>
> Amit Daniel Kachhap (6):
>   ARM: EXYNOS: Move pmu specific header files under "linux/soc/samsung"
>   drivers: soc: Add support for Exynos PMU driver
>   drivers: soc: samsung: Fix a spelling mistake
>   soc: samsung: exynos-pmu: Register exynos-pmu driver as a mfd driver
>   driver: soc: exynos-pmu: Add an API to be called after wakeup
>   drivers: soc: samsung: Add support for Exynos7 pmu
>
>  .../devicetree/bindings/arm/samsung/pmu.txt        |    1 +
>  arch/arm/mach-exynos/Makefile                      |    2 +-
>  arch/arm/mach-exynos/exynos.c                      |    2 +-
>  arch/arm/mach-exynos/mcpm-exynos.c                 |    2 +-
>  arch/arm/mach-exynos/platsmp.c                     |    2 +-
>  arch/arm/mach-exynos/pm.c                          |    4 +-
>  arch/arm/mach-exynos/regs-pmu.h                    |  335 -----------
>  arch/arm/mach-exynos/suspend.c                     |    3 +-
>  drivers/soc/Kconfig                                |    1 +
>  drivers/soc/Makefile                               |    1 +
>  drivers/soc/samsung/Kconfig                        |   19 +
>  drivers/soc/samsung/Makefile                       |    1 +
>  .../pmu.c => drivers/soc/samsung/exynos-pmu.c      |  471 ++++++++++++++-

Hi Olof/Kukjin,

I am not sure that driver/soc/samsung/* shall go in whose tree.
I am preparing the next version so if any comment from your side
please let me know.

Regards,
Amit

>  .../linux/soc/samsung}/exynos-pmu.h                |    6 +
>  include/linux/soc/samsung/exynos-regs-pmu.h        |  608 ++++++++++++++++++++
>  15 files changed, 1109 insertions(+), 349 deletions(-)
>  delete mode 100644 arch/arm/mach-exynos/regs-pmu.h
>  create mode 100644 drivers/soc/samsung/Kconfig
>  create mode 100644 drivers/soc/samsung/Makefile
>  rename arch/arm/mach-exynos/pmu.c => drivers/soc/samsung/exynos-pmu.c (50%)
>  rename {arch/arm/mach-exynos => include/linux/soc/samsung}/exynos-pmu.h (78%)
>  create mode 100644 include/linux/soc/samsung/exynos-regs-pmu.h
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
