Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab3JMRSI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 13:18:08 -0400
Received: from 13.mo3.mail-out.ovh.net ([188.165.33.202]:52127 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754305Ab3JMRSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 13:18:07 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Landley <rob@landley.net>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH RESEND 0/2] clk: add clk accuracy support
Date: Sun, 13 Oct 2013 19:17:09 +0200
Message-Id: <1381684631-10835-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 15393022051619928162
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.500001/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry for the noise, but I didn't get any feedback on this patch series.

This patch series is a proposal to add clock accuracy retrieval support to the
common clk framework.

The support of accuracy retrieval may benefit to the at91 platform (I explain
why in the following paragraphs).

I don't know if other platforms may benefit from this accuracy support. This
series is here to get feedbacks from other developpers/maintainers, and see if
this can be integrated in the clk framework.

Here is why at91 platform may need the clk accuracy informations:

AT91 SoCs provide a slow clock (32 KHz clock) which can be used as a clock
source for some peripherals (USART, TC blocks, ...).

This slow clock can be generated from 2 sources:
- a 32KHz internal RC with a poor accuracy (50000 ppm)
- a 32KHz external crystal oscillator

Most of the supported at91 boards (if not all) use the external 32KHz crystal
source except for the kizbox (the board I'm working with :)).
It probably comes from a bad hardware design (hardware team should have
connected a crystal oscillator to the SoC instead of relying on the unaccurate
internal RC).
Anyway, I can't change the hardware as it is already widely deployed.

What I'm proposing is to give clock users the ability to retrieve clocks
accuracies in order to choose the most accurate source (or at least discard
clocks with poor accuracy).

Could you tell me if this approach is right, and if other platforms/boards have
similar issues and would be interrested by this series ?

Best Regards,

Boris

Boris BREZILLON (2):
  clk: add clk accuracy retrieval support
  clk: add accuracy support for fixed clock

 Documentation/clk.txt                              |    4 +
 .../devicetree/bindings/clock/fixed-clock.txt      |    3 +
 drivers/clk/Kconfig                                |    4 +
 drivers/clk/clk-fixed-rate.c                       |   43 +++++++--
 drivers/clk/clk.c                                  |   92 +++++++++++++++++++-
 include/linux/clk-private.h                        |    1 +
 include/linux/clk-provider.h                       |   14 +++
 include/linux/clk.h                                |   17 ++++
 8 files changed, 168 insertions(+), 10 deletions(-)

-- 
1.7.9.5

