Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892AbaBEUd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:33:58 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10706 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbaBEUHA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:00 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 05 Feb 2014 12:05:01 -0800
From: Andrew Chew <AChew@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "abrestic@chromium.org" <abrestic@chromium.org>,
        "dgreid@chromium.org" <dgreid@chromium.org>,
        "katierh@chromium.org" <katierh@chromium.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Date: Wed, 5 Feb 2014 12:06:57 -0800
Subject: RE: [PATCH v2 1/3] clocksource: tegra: Add nvidia,tegra30-timer
 compat
Thread-Topic: [PATCH v2 1/3] clocksource: tegra: Add nvidia,tegra30-timer
 compat
Thread-Index: Ac8irZLYr4OBvFSEQfOUgi4C0k+svgAABL9g
Message-ID: <643E69AA4436674C8F39DCC2C05F763863199859AC@HQMAIL03.nvidia.com>
References: <1391473055-3158-1-git-send-email-achew@nvidia.com>
 <1391473055-3158-2-git-send-email-achew@nvidia.com>
 <52F2996B.4080005@wwwdotorg.org>
In-Reply-To: <52F2996B.4080005@wwwdotorg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 02/03/2014 05:17 PM, Andrew Chew wrote:
> > There are some differences between tegra20's timer registers and
> > tegra30's (and later).  For example, tegra30 has more timers.  In
> > addition, watchdogs are not present in tegra20.
> >
> > Add this compatibility string in order to be able to distinguish
> > whether the additional timers and watchdogs are there or not.
> 
> > diff --git a/drivers/clocksource/tegra20_timer.c
> > b/drivers/clocksource/tegra20_timer.c
> 
> >  CLOCKSOURCE_OF_DECLARE(tegra20_timer, "nvidia,tegra20-timer",
> > tegra20_init_timer);
> > +CLOCKSOURCE_OF_DECLARE(tegra30_timer, "nvidia,tegra30-timer",
> > +tegra20_init_timer);
> 
> Thinking about this more, nothing in this driver actually cares about
> Tegra20 vs. Tegra30+, since the timer that's used is present in all chips.
> Hence, this patch isn't needed.

Don't I need to add nvidia,tegra30-timer so that the tegra WDT driver
can match against it?  It would be weird to have the tegra WDT driver
bind against nvidia,tegra20-timer when the tegra WDT driver as it is won't
work at all on tegra20.
