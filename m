Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab3K0Mpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 07:45:55 -0500
Received: from 20.mo6.mail-out.ovh.net ([178.32.124.17]:38677 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755559Ab3K0Mpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:45:45 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Landley <rob@landley.net>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/2] clk: add clk accuracy support
Date: Wed, 27 Nov 2013 13:44:43 +0100
Message-Id: <1385556285-19180-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 16811937409055029346
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series adds support for clock accuracy retrieval in the common clk
framework.

Best Regards,

Boris

Changes since v1:
 - remove HAVE_CLK_GET_ACCURACY option and enable clk accuracy support only
   when using the CCF
 - export __clk_get_accuracy (might be used by clk-providers)
 - fix documentation (s/recalc_rate/recalc_accuracy/)
 - move fixed_accuracy field addition (struct clk_fixed_rate) from the 1st
   patch to the 2nd patch of this series

Boris BREZILLON (2):
  clk: add clk accuracy retrieval support
  clk: add accuracy support for fixed clock

 Documentation/clk.txt                              |    4 +
 .../devicetree/bindings/clock/fixed-clock.txt      |    3 +
 drivers/clk/clk-fixed-rate.c                       |   43 ++++++--
 drivers/clk/clk.c                                  |  109 +++++++++++++++++++-
 include/linux/clk-private.h                        |    1 +
 include/linux/clk-provider.h                       |   15 +++
 include/linux/clk.h                                |   17 +++
 7 files changed, 182 insertions(+), 10 deletions(-)

-- 
1.7.9.5

