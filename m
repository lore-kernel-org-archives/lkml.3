Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762480Ab3ECEvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 00:51:48 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:47948 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab3ECEvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 00:51:46 -0400
MIME-Version: 1.0
In-Reply-To: <1367507786-505303-3-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
	<1367507786-505303-3-git-send-email-arnd@arndb.de>
Date: Fri, 3 May 2013 10:21:45 +0530
Message-ID: <CAKohpomBKuaxk+sSF63cu6JKut1uV7J7Sj2o85c3wQ=fodx+Ow@mail.gmail.com>
Subject: Re: [PATCH, RFC 02/22] cpufreq: ARM_DT_BL_CPUFREQ needs ARM_CPU_TOPOLOGY
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 May 2013 20:46, Arnd Bergmann <arnd@arndb.de> wrote:
> The big.LITTLE cpufreq driver uses the CPU topology API, which
> needs to be reflected in Kconfig to prevent broken configurations.
>
> warning: (ARM_DT_BL_CPUFREQ) selects ARM_BIG_LITTLE_CPUFREQ which
> has unmet direct dependencies (ARCH_HAS_CPUFREQ && CPU_FREQ && ARM && ARM_CPU_TOPOLOGY)
>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: cpufreq@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/cpufreq/Kconfig.arm | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index f3af18b..3fd6bdf 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -10,6 +10,7 @@ config ARM_DT_BL_CPUFREQ
>         tristate "Generic ARM big LITTLE CPUfreq driver probed via DT"
>         select ARM_BIG_LITTLE_CPUFREQ
>         depends on OF && HAVE_CLK
> +       depends on ARM_CPU_TOPOLOGY
>         help
>           This enables the Generic CPUfreq driver for ARM big.LITTLE platform.
>           This gets frequency tables from DT.

This Kconfig thing has always been confusing to me. This is how the code looks
currently.

config ARM_BIG_LITTLE_CPUFREQ
        tristate
        depends on ARM_CPU_TOPOLOGY

config ARM_DT_BL_CPUFREQ
        tristate "Generic ARM big LITTLE CPUfreq driver probed via DT"
        select ARM_BIG_LITTLE_CPUFREQ
        depends on OF && HAVE_CLK
        help
          This enables the Generic CPUfreq driver for ARM big.LITTLE platform.
          This gets frequency tables from DT.

Because all ARM big LITTLE cpufreq stuff have dependency on
ARM_CPU_TOPOLOGY, i have added dependency at a common place. So that
we don't end up adding this in every glue layer driver. How should this be done?
