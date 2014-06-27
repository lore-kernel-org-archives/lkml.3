Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbaF0Mcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:32:50 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:53966 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753419AbaF0Mcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:32:48 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+9giXZg5p+q9KBpfKidJ6SWWYCWMvYmNI=
X-DKIM: OpenDKIM Filter v2.0.1 titan 0198E59BAF6
Date: Fri, 27 Jun 2014 08:32:45 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: Core changes for v3.17
Message-ID: <20140627123245.GE23978@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Here's a round of changes for irqchip that have been in -next for
several days.

irqchip/core now has a dependency on irqchip/urgent for:

  4f4366033945 irqchip: spear_shirq: Fix interrupt offset

Please pull.

thx,

Jason.

Note: I've hand-edited the default output of 'git request-pull' below
since it doesn't handle merged branches well.  I used a temporary merge
branch to generate an accurate diffstat for this branch.  Please let me
know if it doesn't look right or is other than expected.

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.infradead.org/users/jcooper/linux.git tags/irqchip-core-3.17

for you to fetch changes up to 1b0a76c146adce782ddb8e71f01729f5f3671c66:

  irqchip: spear_shirq: Simplify register access code (2014-06-24 12:38:45 +0000)

----------------------------------------------------------------
irqchip core changes for v3.17

 - nvic
    - use generic noop function

 - spear_shirq
    - generic cleanup, simplification, and refactoring

----------------------------------------------------------------
Daniel Thompson (1):
      irqchip: nvic: Use the generic noop function

Jason Cooper (1):
      Merge branch 'irqchip/urgent' into irqchip/core

Thomas Gleixner (13):
      irqchip: spear_shirq: Kill pointless static
      irqchip: spear_shirq: Move private structs to source
      irqchip: spear_shirq: No point in storing the parent irq
      irqchip: spear_shirq: Namespace cleanup
      irqchip: spear_shirq: Reorder the spear320 ras blocks
      irqchip: spear_shirq: Use the proper interfaces
      irqchip: spear_shirq: Precalculate status mask
      irqchip: spear_shirq: Kill the clear_reg nonsense
      irqchip: spear_shirq: Simplify chained handler
      irqchip: spear_shirq: Remove the parent irq "ack"/unmask
      irqchip: spear_shirq: Use proper irq chips for the different SoCs
      irqchip: spear_shirq: Simplify register access code

 drivers/irqchip/irq-nvic.c          |  13 ++----
 drivers/irqchip/spear-shirq.c       | 304 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------------
 include/linux/irqchip/spear-shirq.h |  64 -----------------------------
 3 files changed, 141 insertions(+), 240 deletions(-)
 delete mode 100644 include/linux/irqchip/spear-shirq.h
