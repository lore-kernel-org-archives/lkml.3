Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbaD2J1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:27:33 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:48609 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbaD2J1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:27:30 -0400
Date: Tue, 29 Apr 2014 10:27:23 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, t.figa@samsung.com, chow.kim@samsung.com,
        yg1004.jang@samsung.com, vikas.sajjan@samsung.com,
        b.zolnierkie@samsung.com, Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RESUBMIT RFC PATCH v2 3/3] drivers: mfd: Add support for Exynos
 PMU driver
Message-ID: <20140429092723.GG29462@lee--X1>
References: <1398687607-4554-1-git-send-email-pankaj.dubey@samsung.com>
 <1398687607-4554-4-git-send-email-pankaj.dubey@samsung.com>
 <20140428122646.GF21279@lee--X1>
 <535F5AA7.2050001@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <535F5AA7.2050001@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>This patch moves Exynos PMU driver implementation from
> >>"arm/mach-exynos" to "drivers/mfd".
> >>This driver is mainly used for setting misc bits of register from PMU IP
> >>of Exynos SoC which will be required to configure before Suspend/Resume.
> >>Currently all these settings are done in "arch/arm/mach-exynos/pmu.c" but
> >>moving ahead for ARM64 based SoC support, there is a need of DT based
> >>implementation of PMU driver.
> >>This driver uses already existing DT binding information.
> >>
> >>CC: Sangbeom Kim <sbkim73@samsung.com>
> >>CC: Samuel Ortiz <sameo@linux.intel.com>
> >>CC: Lee Jones <lee.jones@linaro.org>
> >>Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> >>---
> >>  arch/arm/mach-exynos/Kconfig                           |    2 ++
> >>  arch/arm/mach-exynos/Makefile                          |    2 --
> >>  drivers/mfd/Kconfig                                    |    9 +++++++++
> >>  drivers/mfd/Makefile                                   |    1 +
> >>  arch/arm/mach-exynos/pmu.c => drivers/mfd/exynos-pmu.c |    0
> >>  5 files changed, 12 insertions(+), 2 deletions(-)
> >>  rename arch/arm/mach-exynos/pmu.c => drivers/mfd/exynos-pmu.c (100%)
> >So I just took a look at the code as zero changes looks suspicious to
> >me. The driver can not simply be copied and pasted into the MFD
> >subsystem in its current state.
> >
> >The fundamental question is; is this chip actually an MFD? What does
> >it do besides Power Management?
> 
> Exynos PMU chip controls different power states of Exynos, so mainly it
> does power management related stuff. Apart from this it has few registers
> which controls PHY of various IP blocks of Exynos such as USB, HDMI,
> ADC etc. But these phy controlling register are currently being accessed
> via "syscon" driver provided regmap APIs. For same the same reason
> Exynos PMU has second compatibility string as "syscon".

I suggest that this is not suitable for the MFD subsystem then.

Try drivers/power.


-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
