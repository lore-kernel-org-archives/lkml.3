Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbaBEUFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:05:13 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36951 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbaBEUFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:03 -0500
Message-ID: <52F2996B.4080005@wwwdotorg.org>
Date: Wed, 05 Feb 2014 13:04:59 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Chew <achew@nvidia.com>, daniel.lezcano@linaro.org,
        tglx@linutronix.de, thierry.reding@gmail.com, rob@landley.net,
        grant.likely@linaro.org, robh+dt@kernel.org, abrestic@chromium.org,
        dgreid@chromium.org, katierh@chromium.org
CC: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 1/3] clocksource: tegra: Add nvidia,tegra30-timer compat
References: <1391473055-3158-1-git-send-email-achew@nvidia.com> <1391473055-3158-2-git-send-email-achew@nvidia.com>
In-Reply-To: <1391473055-3158-2-git-send-email-achew@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 05:17 PM, Andrew Chew wrote:
> There are some differences between tegra20's timer registers and tegra30's
> (and later).  For example, tegra30 has more timers.  In addition, watchdogs
> are not present in tegra20.
> 
> Add this compatibility string in order to be able to distinguish
> whether the additional timers and watchdogs are there or not.

> diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c

>  CLOCKSOURCE_OF_DECLARE(tegra20_timer, "nvidia,tegra20-timer", tegra20_init_timer);
> +CLOCKSOURCE_OF_DECLARE(tegra30_timer, "nvidia,tegra30-timer", tegra20_init_timer);

Thinking about this more, nothing in this driver actually cares about
Tegra20 vs. Tegra30+, since the timer that's used is present in all
chips. Hence, this patch isn't needed.

