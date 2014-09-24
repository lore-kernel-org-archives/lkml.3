Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaIXRae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:30:34 -0400
Received: from 71-19-161-253.dedicated.allstream.net ([71.19.161.253]:59755
	"EHLO nsa.nbspaymentsolutions.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751987AbaIXRad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:30:33 -0400
X-Greylist: delayed 1439 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2014 13:30:33 EDT
From: Bill Pringlemeir <bpringlemeir@nbsps.com>
To: Stefan Agner <stefan@agner.ch>
Cc: shawn.guo@freescale.com, kernel@pengutronix.de, daniel.lezcano@linaro.org,
        tglx@linutronix.de, festevam@gmail.com, jingchang.lu@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] ARM: vf610: Fix/add clocksource
Organization: NBS Payment Solutions
References: <1411575610-20895-1-git-send-email-stefan@agner.ch>
Date: Wed, 24 Sep 2014 13:06:13 -0400
In-Reply-To: <1411575610-20895-1-git-send-email-stefan@agner.ch> (Stefan
	Agner's message of "Wed, 24 Sep 2014 18:20:07 +0200")
Message-ID: <87tx3xkkxm.fsf@nbsps.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 24 Sep 2014, stefan@agner.ch wrote:

> This patchset came out of need for a clocksource which supports
> shutdown.  In the first version I proposed to just replace the current
> clocksource with the ARM Global Timer and even proposed to remove the
> PIT clocksource driver. But Bill Pringlemeir brought up a reasonable
> point why we should keep the PIT clocksource.
>
> Since we need shutdown support for suspend/resume, I added another
> patch which fixes shutdown functionality for the PIT driver. Now it's
> possible to use suspend/resume functionality with each of the two
> clocksources.
>
> Changes in v2:
> - Added shutdown support for PIT clocksource (and hence clocksource
> maintainers as receipient).
> - Create Kconfig entries which allow to choose between the two
> clocksources
> - Clarified commit message
> - Renamed device tree node to "timer"
>
> Stefan Agner (3):
> clocksource: vf_pit_timer: Support shutdown mode
> ARM: dts: vf610: Add ARM Global Timer
> ARM: vf610: Add ARM Global Timer clocksource option
>
> arch/arm/boot/dts/vf610.dtsi       |  8 ++++++++
> arch/arm/mach-imx/Kconfig          | 19 ++++++++++++++++++-
> drivers/clocksource/vf_pit_timer.c |  5 +++++
> 3 files changed, 31 insertions(+), 1 deletion(-)

Acked-by: Bill Pringlemeir <bpringlemeir@nbsps.com>
