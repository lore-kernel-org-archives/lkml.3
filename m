Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab3LQOyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 09:54:05 -0500
Received: from 19.mo3.mail-out.ovh.net ([178.32.98.231]:33026 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752340Ab3LQOyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:54:04 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Landley <rob@landley.net>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 0/2] clk: add clk accuracy support
Date: Tue, 17 Dec 2013 15:36:21 +0100
Message-Id: <1387290983-6236-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 7024770995661207650
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series adds support for clock accuracy retrieval in the common clk
framework.

Best Regards,

Boris

Changes since v2:
 - fix __clk_recalc_accuracies function comment
 - modify __clk_get_accuracy to return the current clock accuracy even when the
   clock is orphan
 - only recalculate clock accuracy when reparent succeed

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
 drivers/clk/clk.c                                  |  103 ++++++++++++++++++--
 include/linux/clk-private.h                        |    1 +
 include/linux/clk-provider.h                       |   15 +++
 include/linux/clk.h                                |   17 ++++
 7 files changed, 173 insertions(+), 13 deletions(-)

-- 
1.7.9.5

