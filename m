Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbaCDSXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 13:23:15 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53670 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaCDSXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 13:23:12 -0500
Date: Tue, 4 Mar 2014 10:23:10 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Mark Brown <broonie@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2 01/11] base: power: Add generic OF-based power domain
 look-up
Message-ID: <20140304182310.GA9985@codeaurora.org>
References: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com>
 <1393862536-9842-2-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393862536-9842-2-git-send-email-tomasz.figa@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03, Tomasz Figa wrote:
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> index dc127e5..006b455 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -3,12 +3,16 @@
>   *
>   * Copyright (C) 2011 Rafael J. Wysocki <rjw@sisk.pl>, Renesas Electronics Corp.
>   *
> + * Support for Device Tree based power domain providers:
> + * Copyright (C) 2014 Tomasz Figa <tomasz.figa@gmail.com>
> + *
>   * This file is released under the GPLv2.
>   */
>  
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/io.h>
> +#include <linux/platform_device.h>

Is this still needed?

>  #include <linux/pm_runtime.h>
>  #include <linux/pm_domain.h>
>  #include <linux/pm_qos.h>
[...]
> +
> +/*
> + * DEVICE<->DOMAIN BINDING USING DEVICE TREE LOOK-UP
> + *
> + * The code below registers a notifier for platform bus devices'
> + * BUS_NOTIFY_BIND_DRIVER events and tries to attach devices to their power
> + * domains by looking them up using Device Tree.
> + *
> + * Similarly in BUS_NOTIFY_UNBOUND_DRIVER the device is detached from its
> + * domain, since it no longer supports runtime PM without any driver bound
> + * to it.

This looks outdated.

> + *
> + * Both generic and legacy Samsung-specific DT bindings are supported to
> + * keep backwards compatibility with existing DTBs.
> + */
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
