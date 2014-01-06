Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbaAFL6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:58:33 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52040 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752920AbaAFL6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:58:31 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: daniel.lezcano@linaro.org, lenb@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kyungmin.park@samsung.com
Subject: Re: [PATCH v2 0/9] cpuidle: rework device state count handling
Date: Mon, 06 Jan 2014 13:12:16 +0100
Message-ID: <2125614.4MjcCLIIsz@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com>
References: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 20, 2013 07:47:22 PM Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> Some cpuidle drivers assume that cpuidle core will handle cases where
> device->state_count is smaller than driver->state_count, unfortunately
> currently this is untrue (device->state_count is used only for handling
> cpuidle state sysfs entries and driver->state_count is used for all
> other cases) and will not be fixed in the future as device->state_count
> is planned to be removed [1].
> 
> This patchset fixes such drivers (ARM EXYNOS cpuidle driver and ACPI
> cpuidle driver), removes superflous device->state_count initialization
> from drivers for which device->state_count equals driver->state_count
> (POWERPC pseries cpuidle driver and intel_idle driver) and finally
> removes state_count field from struct cpuidle_device.
> 
> Additionaly (while at it) this patchset fixes C1E promotion disable
> quirk handling (in intel_idle driver) and converts cpuidle drivers code
> to use the common cpuidle_[un]register() routines (in POWERPC pseries
> cpuidle driver and intel_idle driver).
> 
> [1] http://permalink.gmane.org/gmane.linux.power-management.general/36908
> 
> Reference to v1:
> 	http://comments.gmane.org/gmane.linux.power-management.general/37390
> 
> Changes since v1:
> - synced patch series with next-20131220
> - added ACKs from Daniel Lezcano

I've queued up the series for 3.14, thanks!

> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
> 
> Bartlomiej Zolnierkiewicz (9):
>   ARM: EXYNOS: cpuidle: fix AFTR mode check
>   POWERPC: pseries: cpuidle: remove superfluous dev->state_count
>     initialization
>   POWERPC: pseries: cpuidle: use the common cpuidle_[un]register()
>     routines
>   ACPI / cpuidle: fix max idle state handling with hotplug CPU support
>   ACPI / cpuidle: remove dev->state_count setting
>   intel_idle: do C1E promotion disable quirk for hotplugged CPUs
>   intel_idle: remove superfluous dev->state_count initialization
>   intel_idle: use the common cpuidle_[un]register() routines
>   cpuidle: remove state_count field from struct cpuidle_device
> 
>  arch/arm/mach-exynos/cpuidle.c                  |   8 +-
>  arch/powerpc/platforms/pseries/processor_idle.c |  59 +---------
>  drivers/acpi/processor_idle.c                   |  29 +++--
>  drivers/cpuidle/cpuidle.c                       |   3 -
>  drivers/cpuidle/sysfs.c                         |   5 +-
>  drivers/idle/intel_idle.c                       | 140 +++++-------------------
>  include/linux/cpuidle.h                         |   1 -
>  7 files changed, 51 insertions(+), 194 deletions(-)
> 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
