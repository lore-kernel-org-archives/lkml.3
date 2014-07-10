Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaGJKUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:20:38 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:36330 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaGJKUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:20:36 -0400
MIME-Version: 1.0
In-Reply-To: <1404987355.23201.65.camel@samson1.armitage.org.uk>
References: <1404987355.23201.65.camel@samson1.armitage.org.uk>
Date: Thu, 10 Jul 2014 15:50:36 +0530
Message-ID: <CAKohpo=kj9qsz2qRDdF5M4T3zSyZTa_HHOJH27Q4Y3mnhKw4gA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: kirkwood: Reinstate cpufreq driver for ARCH_KIRKWOOD
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Quentin Armitage <quentin@armitage.org.uk>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 July 2014 15:45, Quentin Armitage <quentin@armitage.org.uk> wrote:
> Commit ff1f0018cf66080d8e6f59791e552615648a033a ("drivers: Enable
> building of Kirkwood drivers for mach-mvebu") added Kirkwood into
> mach-mvebu, adding MACH_KIRKWOOD to ARCH_KIRKWOOD in the KConfig files.
>
> The change for ARM_KIRKWOOD_CPUFREQ replaced ARCH_KIRKWOOD with
> MACH_KIRKWOOD, whereas all the other changes were ARCH_KIRKWOOD ||
> MACH_KIRKWOOD.
>
> As a consequence of this change, the cpufreq driver is no longer enabled
> for ARCH_KIRKWOOD. This patch reinstates ARM_KIRKWOOD_CPUFREQ for
> ARCH_KIRKWOOD.
>
> Signed-off-by: Quentin Armitage <quentin@armitage.org.uk>
> ---
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index ebac671..24778f0 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -118,7 +118,7 @@ config ARM_INTEGRATOR
>           If in doubt, say Y.
>
>  config ARM_KIRKWOOD_CPUFREQ
> -       def_bool MACH_KIRKWOOD
> +       def_bool ARCH_KIRKWOOD || MACH_KIRKWOOD
>         help
>           This adds the CPUFreq driver for Marvell Kirkwood
>           SoCs.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
