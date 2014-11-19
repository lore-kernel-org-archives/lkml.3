Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbaKSP5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:57:46 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:52867 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbaKSP5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:57:41 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH RFC 0/7] ARM: shmobile: sh73a0: DT PM domain support
Date: Wed, 19 Nov 2014 16:57:27 +0100
Message-Id: <1416412654-6508-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Simon, Magnus,

This patch series enables DT support for PM domains on the Renesas SH-Mobile
AG5 (sh73a0) SoC.  It is marked "RFC" due to the addition of memory-controllers
nodes without bindings in patch [5/7] and [7/7].

This series builds further on the series "[PATCH v5 0/8] ARM: shmobile:
R-Mobile: DT PM domain support", which added similar support for R-Mobile A1
(r8a7740).  Due to the similarity of the SYSC System-Controller on the various
SH-Mobile/R-Mobile SoCs, and the abstraction of PM domains in DT, the same
driver can handle sh73a0 after some small modifications, without changing the
DT bindings.

Compared to r8a7740, the only significant change is the move of the
memory-controller(s) to separate PM domains on sh73a0 (and also on R-Mobile
APE6 (r8a73a4)). Hence a provision must be made to not turn off these PM
domains inadvertently. Please see patch [5/7] ("[RFC] ARM: shmobile: sh73a0
dtsi: Add PM domain support"), and the follow-up patch for r8a7740 [7/7]
("[RFC] ARM: shmobile: r8a7740 dtsi: Add missing memory-controller node") for
more details.

This was tested on kzm9g-multiplatform.
Functionality-wise, it behaves the same as the legacy (non-DT) version (modulo
missing DT support in some device drivers).

Thanks for your comments!

Dependencies:
  - [PATCH v5 0/8] ARM: shmobile: R-Mobile: DT PM domain support,
  - [[PATCH v5 0/6] sh73a0 common clock framework implementation,
  - [PATCH 2/2] ARM: shmobile: sh73a0 dtsi: Add missing INTCA0 clock for
    irqpin module.

Geert Uytterhoeven (7):
  PM / Domains: Document SH-Mobile AG5 (sh73a0) binding
  ARM: shmobile: R-Mobile: Consolidate rmobile_pd_suspend_*()
  ARM: shmobile: R-Mobile: Generalize adding/looking up special PM
    domains
  ARM: shmobile: R-Mobile: Special-case PM domains containing SBSCs
  [RFC] ARM: shmobile: sh73a0 dtsi: Add PM domain support
  drivers: sh: Disable PM runtime for multi-platform sh73a0 with genpd
  [RFC] ARM: shmobile: r8a7740 dtsi: Add missing memory-controller node

 .../bindings/power/renesas,sysc-rmobile.txt        |   1 +
 arch/arm/boot/dts/r8a7740.dtsi                     |   6 +
 arch/arm/boot/dts/sh73a0.dtsi                      | 159 ++++++++++++++++++++-
 arch/arm/mach-shmobile/pm-rmobile.c                | 159 +++++++++++++--------
 drivers/sh/pm_runtime.c                            |   4 +-
 5 files changed, 268 insertions(+), 61 deletions(-)

-- 
1.9.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
