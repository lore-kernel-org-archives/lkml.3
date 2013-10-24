Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3JXHAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:00:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab3JXHAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:00:49 -0400
From: NeilBrown <neilb@suse.de>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Date: Thu, 24 Oct 2013 17:57:40 +1100
Subject: [PATCH 0/2] ARM: OMAP: dmtimers improvements.
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Belisko Marek <marek.belisko@gmail.com>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Message-ID: <20131024065536.16889.49902.stgit@notabene.brown>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to use omap dmtimer for a PWM driver (for the backlight
on my display).
But there are two difficulties.

Unfortunately Jon Hunter (who has helped me with dmtimers before)
seems to have disappeared.  So I guess I get to do it myself :-)

Following two patches make dmtimers more usable.

1/ allow the counter to be set even when the timer isn't counting.
2/ move the include file to a more useful location

Any help you can provide in getting these fixes upstream would be appreciated.

Thanks,
NeilBrown

---

NeilBrown (2):
      ARM: OMAP2+: dmtimer: allow counter to be set at any time.
      ARM: OMAP: move dmtimer.h from plat-omap/include/plat to include/linux


 arch/arm/mach-omap1/pm.c                           |    2 
 arch/arm/mach-omap1/timer.c                        |    2 
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |    2 
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |    2 
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c |    2 
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |    2 
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |    2 
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c         |    2 
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |    2 
 arch/arm/mach-omap2/timer.c                        |    2 
 arch/arm/plat-omap/dmtimer.c                       |   11 -
 arch/arm/plat-omap/include/plat/dmtimer.h          |  415 --------------------
 drivers/media/rc/ir-rx51.c                         |    2 
 drivers/pwm/pwm-omap.c                             |    2 
 drivers/staging/tidspbridge/core/dsp-clock.c       |    2 
 include/linux/omap-dmtimer.h                       |  415 ++++++++++++++++++++
 16 files changed, 434 insertions(+), 433 deletions(-)
 delete mode 100644 arch/arm/plat-omap/include/plat/dmtimer.h
 create mode 100644 include/linux/omap-dmtimer.h

-- 
Signature

