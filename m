Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbaDWBb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:31:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39956 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbaDWB15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:27:57 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Joel Fernandes <joelf@ti.com>
Subject: [PATCH 0/8] OMAP2+ system timer cleanup series
Date: Tue, 22 Apr 2014 20:27:01 -0500
Message-ID: <1398216429-4681-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a clean up series that attempts to separate out some of the DT-only vs
legacy system timer usage for OMAP2+. Emphasis is on separating legacy stuff,
and abstracting annoyances such as hwmod to give us the flexibilty for the
migration. The series will relieve some of the difficulties in moving out the
timer code from mach layer. As such it is incremental and there is a bit of
duplication for fallback cases, but emphasis is on keeping things working
during the migration.

Earlier series posted for dmtimer cleanup, and changes for OMAP1 is at [1].

[1] https://lkml.org/lkml/2014/4/16/737

Joel Fernandes (8):
  ARM: OMAP2+: timer: Add a powerup function
  ARM: OMAP2+: timer: Simplify clock event/source name setting
  ARM: OMAP2+: timer: Add comment on timer clk parenting
  ARM: OMAP2+: timer: Remove hwmod look-up dependency for DT-boot
  ARM: OMAP2+: timer: Use of_clk_get for DT platforms
  ARM: OMAP2+: timer: Fix error message to not use hwmod structure
  ARM: OMAP2+: timer: Add fallback for of_clk_get
  ARM: OMAP2+: timer: Add legacy code for old way of getting fclk

 arch/arm/mach-omap2/timer.c |  111 +++++++++++++++++++++++++++++++++----------
 1 file changed, 85 insertions(+), 26 deletions(-)

-- 
1.7.9.5

