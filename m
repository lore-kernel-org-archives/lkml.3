Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaIYT7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:59:40 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63307 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750793AbaIYT7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:59:37 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] ARM: shmobile: R-Mobile: DT PM domain support
Date: Thu, 25 Sep 2014 22:19:27 +0200
Message-ID: <3136347.ncZoJtR6MK@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
References: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 25, 2014 06:28:27 PM Geert Uytterhoeven wrote:
> 	Hi Rafael, Simon, Magnus,
> 
> This patch series enables DT support for PM domains on Renesas R-Mobile SoCs.
> 
> Currently it's limited to R-Mobile A1 (r8a7740), but given the similarity of
> the SYSC System-Controller on the various SH-Mobile/R-Mobile SoCs, and the
> abstraction of PM domains in DT, it should be sufficiently generic to handle
> other SoCs in the future (e.g. SH-Mobile AP4 (sh7372), SH-Mobile AG5 (sh73a0),
> R-Mobile APE6 (r8a73a4)).
> 
> Changes compared to v2 (more detailed changelogs in the individual patches):
>   - Minor changes to attach/detach callbacks,
>   - Really add the A4MP and D4 PM domains, as fixes are available (see
>     dependencies below),
>   - Scan DT topology to identify special PM domains (CPUs and console),
>   - Move PM domain power-on/off latencies to a separate patch.
> 
> Changes compared to v1 (more detailed changelogs in the individual patches):
>   - Several new patches: PM QoS device latencies in DT, attach/detach
>     callbacks,
>   - Run-Time management of the module clocks, making the hack in
>     drivers/sh/pm_runtime.c obsolete for DT platforms using genpd,
>   - Addition of PM QoS device latencies, specified from DT,
>   - Addition of build glue, so this builds and runs without additional
>     changes, incl. s2ram.
> 
> This means that functionality-wise, the DT version is now on par with the
> legacy version ("[PATCH v2 00/11] ARM: shmobile: r8a7740/armadillo800eva legacy
> PM domain support").
> 
> Dependencies:
>   - Simon Horman's renesas-devel-20140924-v3.17-rc6,
>   - Rafael J. Wysocki's linux-pm.git#linux-next,
>   - Jason Cooper's linux.git#irqchip/for-next.
>   - "ARM: shmobile: R-Mobile: Store SYSC base address in rmobile_pm_domain"
>     depends on the legacy version of this series, but if the legacy version
>     will never be accepted, the conflicts are trivial to resolve (drop changes
>     to non-existing PM domains),
>   - Working resume from s2ram depends on:
>       - "[PATCH/RFC] fbdev: sh_mobile_hdmi: Re-init regs before irq re-enable
> 	on resume",
>       - "[PATCH] ARM: hw_breakpoint: Trap undef instruction exceptions on
> 	wake-up", or an alternative solution.
>   - Working "no_console_suspend" handling depends on "[PATCH 06/13] ARM:
>     shmobile: armadillo800eva dts: Add chosen/stdout-path".
> 
> For your convenience, I've also pushed this (incl. its dependencies) to
> git://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-drivers.git#rmobile-genpd
> 
> Rafael: If you accept "PM / Domains: Add genpd attach/detach callbacks", it
> would be good to get this patch in v3.18-rc1, as it's the only hard dependency
> on linux-pm.git for the rest of this series. The other parts have relaxed
> ordering constraints due to the separation of code and DTS.

OK, this one looks good to me, so I can push it for 3.18.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
