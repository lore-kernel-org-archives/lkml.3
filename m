Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab3ILL1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:27:31 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:42412 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab3ILL13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:27:29 -0400
MIME-Version: 1.0
In-Reply-To: <1378985091-9447-1-git-send-email-bilhuang@nvidia.com>
References: <1378985091-9447-1-git-send-email-bilhuang@nvidia.com>
Date: Thu, 12 Sep 2013 16:57:28 +0530
Message-ID: <CAKohpom-8abJCL_VrdvowmKUkfyEw0svne-RpXFhhO1AH6NPew@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Remodel Tegra cpufreq driver to support Tegra
 series SoCs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Bill Huang <bilhuang@nvidia.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-tegra@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2013 16:54, Bill Huang <bilhuang@nvidia.com> wrote:
> This patch series remodel Tegra cpufreq driver to make it more easy to
> add new SoC support, in addition to that, adding probe function in the
> driver to let probe defer can be used to control init sequence when we
> going to support DVFS.
>
> Changes since v1:
>
> - Split up patches.
> - Split configuration-time data out of structure "tegra_cpufreq_data".
> - Bug fixes.
>
> Bill Huang (4):
>   cpufreq: tegra: Call tegra_cpufreq_init() specifically in machine
>     code
>   cpufreq: tegra: Remove not used header files and clean up codes
>   cpufreq: tegra: Re-model Tegra cpufreq driver
>   ARM: tegra: defconfig updates
>
>  arch/arm/configs/tegra_defconfig  |    1 +
>  arch/arm/mach-tegra/common.c      |    2 +
>  drivers/cpufreq/Kconfig.arm       |    8 +-
>  drivers/cpufreq/Makefile          |    1 +
>  drivers/cpufreq/tegra-cpufreq.c   |  194 +++++++++++++++++--------------------
>  drivers/cpufreq/tegra-cpufreq.h   |   42 ++++++++
>  drivers/cpufreq/tegra20-cpufreq.c |  138 ++++++++++++++++++++++++++
>  include/linux/tegra-soc.h         |   11 ++-
>  8 files changed, 290 insertions(+), 107 deletions(-)
>  create mode 100644 drivers/cpufreq/tegra-cpufreq.h
>  create mode 100644 drivers/cpufreq/tegra20-cpufreq.c

I haven't gone deeper into these yet, but there are some cleaup
patches that I have prepared/posted earlier, which will be queued
by Rafael soon.. And after that you would be required to rebase
your stuff on top of it..  As there would be many conflicts..

--
viresh
