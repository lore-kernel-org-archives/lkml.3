Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423018AbaKNXex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:34:53 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65316 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1422803AbaKNXet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:34:49 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: ssantosh@kernel.org, khilman@linaro.org, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v4 0/3] PM / clock_ops: add pm_clk_add_clk()
Date: Sat, 15 Nov 2014 00:55:48 +0100
Message-ID: <2428001.oIE0vavADH@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415281862-23764-1-git-send-email-grygorii.strashko@ti.com>
References: <1415281862-23764-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 06, 2014 03:50:59 PM Grygorii Strashko wrote:
> Hi Santosh, Kevin,
> 
> I've separated these patches in standalone series as requested by
> Santosh (https://lkml.org/lkml/2014/10/24/591). Also, I've kept
> versioning of patches from original series and therefor this
> is v4 of patches.
> 
> The patch 1 was originally introduced in [1] (Apr 2014) and it allows
> to fill per-device list of clock from DT.
> 
> The patch 2 is small clean up needed for patch 3.
> 
> The patch 3 was created as was discussed in v2 and first introduced in v3.
> Here I marked it as RFC, because I've found some disadvantages of such
> approach - see comments to the patch itself.
> 
> Finally, this series is needed to enable to enable Runtime
> PM for Keystone 2, but honestly I need only patch 1.
> 
> RFC version of patches can be found at [2].
> 
> Changes in v4:
>  - pm_clk_add_clk() changed to get reference on clock as
>    requested by Dmitry Torokhov (see v3). Now the caller has to
>    use clk_put() on clock pointer when done.
> 
> Changes in v3:
>  - handling of the case when !CONFIG_PM_RUNTIME has been
>    moved in PM clock framework.
> 
> Changes in v2:
> - minor comments applied and rebased on top of Linux 3.18-rc1.
> 
> Links on previous versions:
> v3:  https://lkml.org/lkml/2014/10/23/342
> v2:  https://lkml.org/lkml/2014/10/20/248
> v1:  https://lkml.org/lkml/2014/9/29/382
> 
> [1] "[PATCH/RFC 0/4] of: Register clocks for Runtime PM with PM core"
>   https://lkml.org/lkml/2014/4/24/1118
> 
> [2] "[RFC PATCH 0/4] ARM: keystone: pm: switch to use generic pm domains"
>   https://lkml.org/lkml/2014/9/25/364
> 
> CC: Santosh Shilimkar <ssantosh@kernel.org>
> CC: Kevin Hilman <khilman@linaro.org>
> CC: Ulf Hansson <ulf.hansson@linaro.org>
> CC: Geert Uytterhoeven <geert@linux-m68k.org>
> CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> Geert Uytterhoeven (1):
>   PM / clock_ops: Add pm_clk_add_clk()
> 
> Grygorii Strashko (2):
>   PM / clock_ops: make __pm_clk_enable more generic
>   PM / clock_ops: add and enable clocks always if !CONFIG_PM_RUNTIME
> 
>  drivers/base/power/clock_ops.c | 89 +++++++++++++++++++++++++++---------------
>  include/linux/pm_clock.h       |  8 ++++
>  2 files changed, 65 insertions(+), 32 deletions(-)

Patches [1-2/3] queued up for 3.19, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
