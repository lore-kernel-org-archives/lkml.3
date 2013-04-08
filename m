Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964943Ab3DHKAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:00:49 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:40915 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964931Ab3DHKAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:00:46 -0400
MIME-Version: 1.0
In-Reply-To: <1365409058-32643-1-git-send-email-amit.daniel@samsung.com>
References: <1365409058-32643-1-git-send-email-amit.daniel@samsung.com>
Date: Mon, 8 Apr 2013 15:30:45 +0530
Message-ID: <CAKohpo==g5AvKdNpi49P6t8TP4i-2pDtNZ30iRyip+mXF8uKEQ@mail.gmail.com>
Subject: Re: [PATCH V6 0/4] cpufreq: exynos5440: support for cpufreq driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>, cpufreq@vger.kernel.org,
        Inderpal Singh <inderpal.singh@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 April 2013 13:47, Amit Daniel Kachhap <amit.daniel@samsung.com> wrote:
> Submitting the V6 version of exynos5440 cpufreq driver. This patchset addresses
> all the coding and design concerns raised especially by Viresh.
>
> Changes in V6:
> * Used cpufreq post-change notifier call back in case of failure as pointed by
>   Viresh.
> * Called cpufreq_frequency_table_cpuinfo before calling
>   cpufreq_frequency_table_get_attr as pointed by Viresh.
> * Used modified API cpufreq_notify_transition.
>
> Changes in V5:
> * Removed the unnecessary DT look up entry from mach-exynos5-dt.c.
> * Fixed all coding and comments issue raised by Viresh.
>
> Changes in V4:
> * Added dev_err logs instead of pr_err.
> * Used the devm_ioremap_resource API.
> * Implemented several coding guidelines and minor error comments from Sylwester,
>   Russell and Viresh.
>
> Changes in V3:
> * Converted the driver to probe based as suggested by Viresh. This is also
>   beneficial for multiplatform kernel.
> * Other coding guidelines related changes.
> * Moved the DT node outside cpu0 node as the driver is now a platform
>   driver.
>
> Changes in V2:
> * Added OPP library support to parse DT parameters.
> * Removed a hack to handle interrupts in bootup.
> * Implemented other review comments from Viresh and Inder.
>
> All these patches are dependent on Thomas Abraham common clock patches.
> (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg15860.html)
> This whole patch series is based on Rafael tree.
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git bleeding-edge
>
> Amit Daniel Kachhap (4):
>   cpufreq: exynos: Add cpufreq driver for exynos5440
>   cpufreq: exynos: Remove error return even if no soc is found
>   arm: exynos: Enable OPP library support for exynos5440
>   arm: dts: Add cpufreq controller node for Exynos5440 SoC
>
>  .../bindings/cpufreq/cpufreq-exynos5440.txt        |   28 ++
>  arch/arm/boot/dts/exynos5440.dtsi                  |   12 +
>  arch/arm/mach-exynos/Kconfig                       |    2 +
>  drivers/cpufreq/Kconfig.arm                        |    9 +
>  drivers/cpufreq/Makefile                           |    1 +
>  drivers/cpufreq/exynos-cpufreq.c                   |    2 +-
>  drivers/cpufreq/exynos5440-cpufreq.c               |  479 ++++++++++++++++++++
>  7 files changed, 532 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-exynos5440.txt
>  create mode 100644 drivers/cpufreq/exynos5440-cpufreq.c

With the resent of 1/4,

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
