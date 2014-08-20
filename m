Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaHTNjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:39:32 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:56996 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaHTNja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:39:30 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 0/2] Legacy SH_INTC cleanup
Date: Wed, 20 Aug 2014 15:39:21 +0200
Message-Id: <1408541963-20736-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Simon, Magnus,

This series cleans up some of the legacy SH_INTC support, which is only used
on 32-bit SuperH and early ARM SH-Mobile (sh7372/sh73a).

There are no dependencies between the two patches.
The first one is destined for your sh-drivers-for-v3.18 branch, while the
second one is meant for your cleanup-for-v3.18 branch.

Geert Uytterhoeven (2):
  sh: intc: Confine SH_INTC to platforms that need it
  ARM: shmobile: Move legacy INTC definitions from irqs.h to intc.h

 arch/arm/mach-shmobile/Kconfig          | 2 ++
 arch/arm/mach-shmobile/board-kzm9g.c    | 1 +
 arch/arm/mach-shmobile/board-mackerel.c | 1 +
 arch/arm/mach-shmobile/intc.h           | 6 ++++++
 arch/arm/mach-shmobile/irqs.h           | 6 ------
 arch/arm/mach-shmobile/setup-sh7372.c   | 1 +
 arch/arm/mach-shmobile/setup-sh73a0.c   | 1 +
 arch/sh/Kconfig                         | 3 +++
 drivers/sh/Makefile                     | 3 +--
 drivers/sh/intc/Kconfig                 | 6 +++++-
 10 files changed, 21 insertions(+), 9 deletions(-)

-- 
1.9.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
