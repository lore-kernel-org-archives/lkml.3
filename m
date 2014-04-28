Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083AbaD1Td1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:33:27 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:24163 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932433AbaD1TdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:33:22 -0400
Date: Mon, 28 Apr 2014 18:37:43 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, Samuel Ortiz <sameo@linux.intel.com>,
        b.zolnierkie@samsung.com, Sangbeom Kim <sbkim73@samsung.com>,
        t.figa@samsung.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, chow.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RESUBMIT RFC PATCH v2 3/3] drivers: mfd: Add support for Exynos
 PMU driver
Message-ID: <20140428173743.GA14853@arm.com>
References: <1398687607-4554-1-git-send-email-pankaj.dubey@samsung.com>
 <1398687607-4554-4-git-send-email-pankaj.dubey@samsung.com>
 <20140428122646.GF21279@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428122646.GF21279@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 01:26:46PM +0100, Lee Jones wrote:
> > This patch moves Exynos PMU driver implementation from
> > "arm/mach-exynos" to "drivers/mfd".
> > This driver is mainly used for setting misc bits of register from PMU IP
> > of Exynos SoC which will be required to configure before Suspend/Resume.
> > Currently all these settings are done in "arch/arm/mach-exynos/pmu.c" but
> > moving ahead for ARM64 based SoC support, there is a need of DT based
> > implementation of PMU driver.
> > This driver uses already existing DT binding information.
> > 
> > CC: Sangbeom Kim <sbkim73@samsung.com>
> > CC: Samuel Ortiz <sameo@linux.intel.com>
> > CC: Lee Jones <lee.jones@linaro.org>
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > ---
> >  arch/arm/mach-exynos/Kconfig                           |    2 ++
> >  arch/arm/mach-exynos/Makefile                          |    2 --
> >  drivers/mfd/Kconfig                                    |    9 +++++++++
> >  drivers/mfd/Makefile                                   |    1 +
> >  arch/arm/mach-exynos/pmu.c => drivers/mfd/exynos-pmu.c |    0
> >  5 files changed, 12 insertions(+), 2 deletions(-)
> >  rename arch/arm/mach-exynos/pmu.c => drivers/mfd/exynos-pmu.c (100%)
> 
> So I just took a look at the code as zero changes looks suspicious to
> me. The driver can not simply be copied and pasted into the MFD
> subsystem in its current state.
> 
> The fundamental question is; is this chip actually an MFD? What does
> it do besides Power Management?

I looked at the code briefly as well and I don't think it matches the
mfd idea. Maybe it could be merged together with
arch/arm/mach-exynos/pm.c and moved to drivers/power/ or a more
appropriate directory for platform_suspend_ops.

-- 
Catalin
