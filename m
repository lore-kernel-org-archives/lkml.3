Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbaIQItf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:49:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:26031 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbaIQItd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:49:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="387289420"
From: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Enable Quark X1000 support in gpio-sch
Date: Wed, 17 Sep 2014 16:49:02 +0800
Message-Id: <1410943745-9354-1-git-send-email-rebecca.swee.fun.chang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series is about enabling legacy GPIO support for Quark X1000.
The patches were developed on top of Mika Westerberg's commit on
consolidating core and resume banks. Please refer to the link below for
more information about his commit.
https://lkml.org/lkml/2014/8/17/13

The patches are generally enable GPIO support for Intel Quark X1000 SoC.
In the first patch of the series, I've also done some consolidating work as
there are similar algorithms that can be merged and generalized.

The second patch is about adding Quark X1000 pci ids and gpio pins supported
in the legacy gpio bridge.

The last patch in the series is about enable IRQ handling for gpio-sch. Intel
Quark X1000's legacy GPIO is an IRQ based GPIO. The IRQ resources will be
provided by MFD's lpc_sch.c. The changes in MFD (lpc_sch.c) required in order
to support gpio-sch has been merged into linux-next.git.

The patches has been built and tested working on Intel Galileo board.

Thank you.

Regards
Rebecca

Chang Rebecca Swee Fun (3):
  gpio: sch: Consolidate similar algorithms
  gpio: sch: Add support for Intel Quark X1000 SoC
  gpio: sch: Enable IRQ support for Quark X1000

 drivers/gpio/Kconfig    |   11 +-
 drivers/gpio/gpio-sch.c |  362 ++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 318 insertions(+), 55 deletions(-)

-- 
1.7.9.5

