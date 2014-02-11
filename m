Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaBKFip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 00:38:45 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52717 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaBKFio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 00:38:44 -0500
Date: Mon, 10 Feb 2014 21:38:42 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org
Subject: Re: [PATCH v3 2/5] clocksource: qcom: Move clocksource code out of
 mach-msm
Message-ID: <20140211053842.GE10784@codeaurora.org>
References: <1391725484-6673-1-git-send-email-galak@codeaurora.org>
 <1391725484-6673-3-git-send-email-galak@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391725484-6673-3-git-send-email-galak@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06, Kumar Gala wrote:
> diff --git a/arch/arm/mach-msm/timer.c b/drivers/clocksource/qcom-timer.c
> similarity index 98%
> rename from arch/arm/mach-msm/timer.c
> rename to drivers/clocksource/qcom-timer.c
> index fd16449..dca829e 100644
> --- a/arch/arm/mach-msm/timer.c
> +++ b/drivers/clocksource/qcom-timer.c
> @@ -1,7 +1,7 @@
>  /*
>   *
>   * Copyright (C) 2007 Google, Inc.
> - * Copyright (c) 2009-2012, The Linux Foundation. All rights reserved.
> + * Copyright (c) 2009-2012,2014, The Linux Foundation. All rights reserved.
>   *
>   * This software is licensed under the terms of the GNU General Public
>   * License version 2, as published by the Free Software Foundation, and
> @@ -26,10 +26,6 @@
>  #include <linux/of_irq.h>
>  #include <linux/sched_clock.h>
>  
> -#include <asm/mach/time.h>
> -
> -#include "common.h"
> -

This will cause sparse warnings because we no longer have the header included.

  CHECK   drivers/clocksource/qcom-timer.c
drivers/clocksource/qcom-timer.c:304:13: warning: symbol 'msm7x01_timer_init' was not declared. Should it be static?
drivers/clocksource/qcom-timer.c:317:13: warning: symbol 'msm7x30_timer_init' was not declared. Should it be static?
drivers/clocksource/qcom-timer.c:324:13: warning: symbol 'qsd8x50_timer_init' was not declared. Should it be static?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
