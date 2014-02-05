Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbaBEVlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:41:35 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14377 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaBEVla convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 16:41:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 05 Feb 2014 13:39:59 -0800
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
Date: Wed, 5 Feb 2014 13:41:28 -0800
Subject: RE: [PATCH v2 2/3] clocksource: tegra: Define timer bases in header
 file
Thread-Topic: [PATCH v2 2/3] clocksource: tegra: Define timer bases in
 header file
Thread-Index: Ac8irWVSH9BoUCtdRHCMp0LuK4ebbAADYoJw
Message-ID: <643E69AA4436674C8F39DCC2C05F76386319985A02@HQMAIL03.nvidia.com>
References: <1391473055-3158-1-git-send-email-achew@nvidia.com>
 <1391473055-3158-3-git-send-email-achew@nvidia.com>
 <52F29923.6020708@wwwdotorg.org>
In-Reply-To: <52F29923.6020708@wwwdotorg.org>
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

> > +/* Tegra 20 timers */
> > +#define TEGRA20_TIMER1_BASE	0x0
> > +#define TEGRA20_TIMER2_BASE	0x8
> > +#define TEGRA20_TIMER3_BASE	0x50
> > +#define TEGRA20_TIMER4_BASE	0x58
> > +
> > +/* Tegra 30 timers */
> > +#define TEGRA30_TIMER1_BASE	TEGRA20_TIMER1_BASE
> > +#define TEGRA30_TIMER2_BASE	TEGRA20_TIMER2_BASE
> > +#define TEGRA30_TIMER3_BASE	TEGRA20_TIMER3_BASE
> > +#define TEGRA30_TIMER4_BASE	TEGRA20_TIMER4_BASE
> > +#define TEGRA30_TIMER5_BASE	0x60
> > +#define TEGRA30_TIMER6_BASE	0x68
> > +#define TEGRA30_TIMER7_BASE	0x70
> > +#define TEGRA30_TIMER8_BASE	0x78
> > +#define TEGRA30_TIMER9_BASE	0x80
> > +#define TEGRA30_TIMER0_BASE	0x88
> 
> Why put the SoC name in the define names? Why not just have
> TIMER1_BASE..TIMER10_BASE (that should be 10 not 0 as in your patch,
> right?) and have the driver know that 1..4 are valid on Tegra20, and
> 1..10 are valid on later chips.
> 
> I guess if the defines are moved into a header file, adding a TEGRA_ prefix
> does make sense.
> 
> But I wonder if it wouldn't be simpler for the Tegra WDT driver to just call a
> function on the Tegra clocksource driver to find out which timer
> ID(s) to avoid using? Even simpler would be to just put a comment in the
> WDT driver saying that timer 5 was chosen arbitrarily, but if it's changed make
> sure not to conflict with the clocksource driver (and an equivalent change to
> the clocksource driver).

Alright, I think I'll just go with putting a comment in the WDT driver then, so that
We don't need to add this new header file.
