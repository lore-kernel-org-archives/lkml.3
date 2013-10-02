Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab3JBMld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:41:33 -0400
Received: from 3.mo4.mail-out.ovh.net ([46.105.57.129]:55341 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753636Ab3JBMlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:41:32 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PATCH 0/3] ARM: at91/tc/clocksource: various robustness improvements
Date: Wed,  2 Oct 2013 14:34:25 +0200
Message-Id: <1380717265-6497-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 1356990863375562860
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrudegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrudegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series include several improvements regarding the at91 tc clocksource
driver:
 - use clk_prepare/unprepare_enable/disable functions instead of the
   clk_enable/disable functions to prepare the transition to the common clk
   framework
 - check several function return values instead of considering these functions
   always suceed.
 - remove the deprecated IRQF_DISABLED flag

Best Regards,

Boris

Boris BREZILLON (3):
  ARM: at91/tc/clocksource: replace clk_enable/disable with
    clk_prepare_enable/disable_unprepare
  ARM: at91/tc/clocksource: improve driver robustness
  ARM: at91/tc/clocksource: remove IRQF_DISABLED

 drivers/clocksource/tcb_clksrc.c |   61 +++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 11 deletions(-)

-- 
1.7.9.5

