Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaBCLZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 06:25:43 -0500
Received: from 11.mo3.mail-out.ovh.net ([87.98.184.158]:40416 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751501AbaBCLZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 06:25:41 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH 0/3] clk: at91: various fixes and improvements
Date: Mon,  3 Feb 2014 12:25:27 +0100
Message-Id: <1391426731-9392-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 8986088632964577308
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrieelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrieelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mike,

This series fixes a bug in the prog clk prepare function (the platform hangs
when preparing a prog clk).

It also implements the determine_rate callback for these prog clks and allow
system clk to propagate the rate change to its parent.

These modifications are needed to get the atmel_wm8904 driver working (this
driver make use of prog clks), and if possible, should be merged in the next
3.14 release (at least the first patch of this series).

Let me know if this is not possible.

Thanks.

Best Regards,

Boris

Boris BREZILLON (3):
  clk: at91: fix programmable clk irq handling
  clk: at91: replace prog clk round_rate with determine_rate
  clk: at91: propagate rate change on system clks

 drivers/clk/at91/clk-programmable.c |   61 ++++++++++++++++++-----------------
 drivers/clk/at91/clk-system.c       |    3 +-
 2 files changed, 34 insertions(+), 30 deletions(-)

-- 
1.7.9.5

