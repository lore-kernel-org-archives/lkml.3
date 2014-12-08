Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbaLHMpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 07:45:52 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:60082 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbaLHMpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 07:45:50 -0500
MIME-Version: 1.0
In-Reply-To: <2407638.dfZGaT4vm1@vostro.rjw.lan>
References: <2407638.dfZGaT4vm1@vostro.rjw.lan>
Date: Mon, 8 Dec 2014 13:45:48 +0100
Message-ID: <CAPDyKFpk3XW43e+7b0Py80a-RAUnbbZ3t+w7B9Sm8KdeyMZ5Ag@mail.gmail.com>
Subject: Re: [PATCH] ARM / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 December 2014 at 03:50, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
>
> Replace CONFIG_PM_RUNTIME with CONFIG_PM everywhere in the code under
> arch/arm/ (the defconfig files will be modified later).
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
>
> Please let me know if it is OK to take this one into linux-pm.
>
> ---
>  arch/arm/kernel/perf_event.c       |    2 +-
>  arch/arm/mach-davinci/pm_domain.c  |    2 +-
>  arch/arm/mach-keystone/pm_domain.c |    2 +-
>  arch/arm/mach-omap1/pm_bus.c       |    4 ++--
>  arch/arm/mach-omap2/io.c           |    2 +-
>  arch/arm/mach-omap2/omap_device.c  |    2 +-
>  6 files changed, 7 insertions(+), 7 deletions(-)

There are a bunch of Kconfig options that "selects/depends" on
"PM_RUNTIME". I suppose you should change them into "PM" as well.

Kind regards
Uffe
