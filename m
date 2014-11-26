Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaKZHmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 02:42:47 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:49903 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752055AbaKZHmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 02:42:46 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/mGVaEHos1XcHKvdtuSVLkzU7/5ZCuPtY=
X-DKIM: OpenDKIM Filter v2.0.1 titan D37AE62428F
Date: Wed, 26 Nov 2014 02:42:42 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: Core changes for v3.19 (round 3)
Message-ID: <20141126074242.GB22670@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

This round of changes includes the legacy orion platform gpio build
regression fix.  This adds a dependency on mvebu/fixes.  Both patches
are already a part of v3.18-rc5.  This is the cleanest way I could come
up with the resolve the issue.  Please let me know if you know of a
better way.

All changes have been in -next for a while except for

  2f90bce7ff1f ARM: orion: convert the irq_reg_{readl,writel} calls to the new API

I build-tested it against the legacy defconfigs before and after
applying and it did fix the regression.

This is an incremental pull request from tags/irqchip-core-3.19-2 up to
tags/irqchip-core-3.19-3 in the irqchip/core branch.

Please pull.

thx,

Jason.


The following changes since commit 1abbdbac362af44f337fdbae5dcbe8d9ced8d063:

  irqchip: brcmstb-l2: Convert driver to use irq_reg_{readl,writel} (2014-11-09 04:03:35 +0000)

are available in the git repository at:

  git://git.infradead.org/users/jcooper/linux.git tags/irqchip-core-3.19-3

for you to fetch changes up to 377df64a1676fe069be9d9555edd862459d6090b:

  Merge branch 'irqchip/atmel' into irqchip/core (2014-11-26 07:02:27 +0000)

----------------------------------------------------------------
irqchip core changes for v3.19 (round 3)

 - orion gpio
    - Use irq_reg_{readl,writel} API with a fix in mvebu

 - atmel-aic
    - Migrate irq fixups from platform code to drivers

----------------------------------------------------------------
Boris BREZILLON (5):
      irqchip: atmel-aic: Add irq fixup for RTT block
      irqchip: atmel-aic: Add irq fixups for at91sam926x SoCs
      irqchip: atmel-aic: Add specific irq fixup function for sam9g45 and sam9rl
      irqchip: atmel-aic: Rename at91sam9_aic_irq_fixup for naming consistency
      irqchip: atmel-aic: Add missing entry for rm9200 irq fixups

Gregory CLEMENT (1):
      ARM: orion: convert the irq_reg_{readl,writel} calls to the new API

Jason Cooper (2):
      Merge tag 'tags/mvebu-fixes-3.18' into irqchip/core
      Merge branch 'irqchip/atmel' into irqchip/core

 drivers/irqchip/irq-atmel-aic-common.c | 26 ++++++++++++++++++++++++
 drivers/irqchip/irq-atmel-aic-common.h |  2 ++
 drivers/irqchip/irq-atmel-aic.c        | 26 +++++++++++++++++++-----
 5 files changed, 82 insertions(+), 10 deletions(-)

----------------------------------------------------------------
NOTE:  The following changes are already in mainline and were removed
from the above summary:

Andrew Lunn (1):
      ARM: mvebu: armada xp: Generalize use of i2c quirk

Evgeniy Dushistov (1):
      ARM: orion: Fix for certain sequence of request_irq can cause irq storm

 arch/arm/mach-mvebu/board-v7.c         |  2 +-
 arch/arm/plat-orion/gpio.c             | 36 ++++++++++++++++++++++++++++++----

The trailing chg/ins/del line has _not_ been adjusted to reflect this.

