Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3ALLuK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 06:50:10 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:8851
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689Ab3ALLuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 06:50:07 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz103dKzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh17326ahz2dh87h2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Shawn Guo <shawn.guo@linaro.org>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: John Stultz <john.stultz@linaro.org>, <arm@kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 0/3] Use helper clockevents_config_and_register()
Date: Sat, 12 Jan 2013 19:50:03 +0800
Message-ID: <1357991406-22778-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clockevent core is able to figure out the best mult and shift,
calculate min_delta_ns and max_delta_ns, with the necessary info passed
into clockevents_config_and_register().  Use this handy helper to make
the drivers less error prone and save some LOC.

Changes since v1:
 - Add one patch to export clockevents_config_and_register for fixing
   the error [1] reported by Fengguang.
 - Add Acked-by and Tested-by tags given by people (Thanks!)

[1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/209152

Shawn Guo (3):
  clockevents: export clockevents_config_and_register for module use
  ARM: use clockevents_config_and_register() where possible
  clocksource: use clockevents_config_and_register() where possible

 arch/arm/mach-at91/at91rm9200_time.c     |    7 ++-----
 arch/arm/mach-cns3xxx/core.c             |   13 +++----------
 arch/arm/mach-exynos/mct.c               |   18 ++++--------------
 arch/arm/mach-footbridge/dc21285-timer.c |    6 +-----
 arch/arm/mach-imx/epit.c                 |   15 +++------------
 arch/arm/mach-imx/time.c                 |   15 +++------------
 arch/arm/mach-ixp4xx/common.c            |   11 ++---------
 arch/arm/mach-lpc32xx/timer.c            |    9 +--------
 arch/arm/mach-mmp/time.c                 |    7 ++-----
 arch/arm/mach-msm/timer.c                |    6 +-----
 arch/arm/mach-mxs/timer.c                |   24 +++++-------------------
 arch/arm/mach-netx/time.c                |   10 ++--------
 arch/arm/mach-omap1/time.c               |   11 ++---------
 arch/arm/mach-omap1/timer32k.c           |   12 ++----------
 arch/arm/mach-omap2/timer.c              |   13 +++----------
 arch/arm/mach-prima2/timer.c             |   10 ++--------
 arch/arm/mach-pxa/time.c                 |    8 ++------
 arch/arm/mach-sa1100/time.c              |    8 ++------
 arch/arm/mach-tegra/timer.c              |    8 ++------
 arch/arm/mach-vt8500/timer.c             |    9 ++-------
 arch/arm/mach-w90x900/time.c             |   10 ++--------
 arch/arm/plat-iop/time.c                 |    9 ++-------
 arch/arm/plat-orion/time.c               |    6 +-----
 arch/arm/plat-samsung/s5p-time.c         |    9 +--------
 arch/arm/plat-spear/time.c               |    8 +-------
 drivers/clocksource/cs5535-clockevt.c    |   11 ++---------
 drivers/clocksource/sunxi_timer.c        |   11 ++---------
 drivers/clocksource/tcb_clksrc.c         |    7 +------
 kernel/time/clockevents.c                |    1 +
 29 files changed, 59 insertions(+), 233 deletions(-)

-- 
1.7.9.5


