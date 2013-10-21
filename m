Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3JUMQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 08:16:17 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:38751 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab3JUMQO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 08:16:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <5264425E.4040301@samsung.com>
Cc: rjw@sisk.pl, kgene.kim@samsung.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, linux-doc@vger.kernel.org,
        viresh.kumar@linaro.org, s.nawrocki@samsung.com,
        m.szyprowski@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        thomas.abraham@linaro.org, b.zolnierkie@samsung.com,
        t.stanislaws@samsung.com, devicetree@vger.kernel.org,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        rob.herring@calxeda.com, ben-linux@fluff.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, rob@landley.net
References: <1380027009-2239-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1816869.ggMDlA1qNY@flatron> <5264425E.4040301@samsung.com>
Message-ID: <20131021121605.11944.74007@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v5 0/3] ARM: S5PV210: move to common clk framework
Date: Mon, 21 Oct 2013 05:16:05 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kukjin Kim (2013-10-20 13:51:42)
> On 10/20/13 01:03, Tomasz Figa wrote:
> > Hi Mike, Kukjin, Rafael,
> >
> > On Tuesday 24 of September 2013 14:50:06 Mateusz Krawczuk wrote:
> >> This patch series is the new s5pv210 clock implementation
> >> (using common clk framework).
> >>
> >> This implementation is compatible with device tree definition and board
> >> files.
> >>
> >> This patch series is based on linux-next and has been tested on goni and
> >> aquila
> >> boards using board file.
> >>
> >> Since v4:
> >> Corrected mux flags for finpll.
> >>
> >> Since v3:
> >>
> >> Replace s5pv210_clk_register_finpll, by creating mux finpll
> >> with xusbxti and xxti as parrents.
> >>
> >>
> >> Mateusz Krawczuk (3):
> >>    clk: samsung: Add clock driver for s5pc110/s5pv210
> >>    Cpufreq: s5pv210 cpufreq fixes for CCF
> >>    ARM: s5pv210: Migrate clock handling to Common Clock Framework
> >>
> >>   .../bindings/clock/samsung,s5pv210-clock.txt       |  75 +++
> >>   arch/arm/mach-s5pv210/Kconfig                      |   9 +
> >>   arch/arm/mach-s5pv210/Makefile                     |   4 +-
> >>   arch/arm/mach-s5pv210/common.c                     |  17 +
> >>   arch/arm/mach-s5pv210/common.h                     |  10 +
> >>   arch/arm/mach-s5pv210/mach-goni.c                  |   2 +-
> >>   arch/arm/mach-s5pv210/mach-smdkv210.c              |   2 +-
> >>   arch/arm/plat-samsung/Kconfig                      |   2 +-
> >>   drivers/clk/samsung/Makefile                       |   3 +
> >>   drivers/clk/samsung/clk-s5pv210.c                  | 673
> >> +++++++++++++++++++++ drivers/cpufreq/s5pv210-cpufreq.c
> >>   |   6 +-
> >>   include/dt-bindings/clock/samsung,s5pv210-clock.h  | 224 +++++++
> >>   12 files changed, 1019 insertions(+), 8 deletions(-)
> >>   create mode 100644
> >> Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt
> >> create mode 100644 drivers/clk/samsung/clk-s5pv210.c
> >>   create mode 100644 include/dt-bindings/clock/samsung,s5pv210-clock.h
> >
> > I believe this series is reasonable to be applied. Could we agree on
> > the tree it would go through and get all tne required acks?
> >
> > Best regards,
> > Tomasz
> 
> I agree.
> 
> Mike, how do you think the common clk stuff for s5pv210?

Clock code looks good to me. Which tree do you want to take it through?

Regards,
Mike

> 
> - Kukjin
