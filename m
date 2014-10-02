Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaJBNhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:37:19 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:24582 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbaJBNhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:37:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/oaqkgT+QGAPMNm/W5KeV1BKvfSflO51s=
X-DKIM: OpenDKIM Filter v2.0.1 titan 558695F3ACF
Date: Thu, 2 Oct 2014 09:37:13 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: core: Last changes for v3.18
Message-ID: <20141002133713.GA27230@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Here's the last round of changes for irqchip/core.  This is it for
v3.18.  Unfortunately, I've been a bit wrapped around the axle this
cycle with other commitments, so this is really late.  The only thing I
have to say for myself is that every commit listed below has been in
linux-next for at *least* 12 of Stephen's 'next-YYYYMMDD' tags.

Hopefully it'll be ok for you to take this since Linus is either
delaying the opening of the merge window by a week or leaving it open a
week longer.

This is an incremental pull request from tags/irqchip-core-3.18 up to
tags/irqchip-core-3.18-2 on the irqchip/core branch.

Please pull.

thx,

Jason.

The following changes since commit 468a903c0e5147e3f93187f0b808a3ef957fd00e:

  Merge branch 'irqchip/handle_domain' into irqchip/core (2014-09-14 07:53:54 +0000)

are available in the git repository at:

  git://git.infradead.org/users/jcooper/linux.git tags/irqchip-core-3.18-2

for you to fetch changes up to fae119b6d427a087be0c6a85431c1b8ee9ffea96:

  Merge branch 'irqchip/gic' into irqchip/core (2014-10-02 13:04:58 +0000)

----------------------------------------------------------------
irqchip core changes for v3.18 (round 2)

 - atmel
    - Add sama5d4 support
    - Correct # irqs for sama5d3

 - broadcom
    - Add bcm7120 l2 interrupt controller and DT binding

 - gic-v3
    - Add CPU PM notifier
    - Add enable/disable support to gic_enable_redist

----------------------------------------------------------------
Alexandre Belloni (2):
      irqchip: atmel-aic5: The sama5d3 has 48 IRQs
      irqchip: atmel-aic5: Add sama5d4 support

Florian Fainelli (2):
      irqchip: bcm7120-l2: Add Broadcom BCM7120-style Level 2 interrupt controller
      Documentation: bcm7120-l2: Add Broadcom BCM7120-style L2 binding

Jason Cooper (3):
      Merge branch 'irqchip/atmel' into irqchip/core
      Merge branch 'irqchip/broadcom' into irqchip/core
      Merge branch 'irqchip/gic' into irqchip/core

Sudeep Holla (2):
      irqchip: gic-v3: Refactor gic_enable_redist to support both enabling and disabling
      irqchip: gic-v3: Implement CPU PM notifier

 .../bindings/interrupt-controller/atmel,aic.txt    |   2 +-
 .../interrupt-controller/brcm,bcm7120-l2-intc.txt  |  86 ++++++++
 drivers/irqchip/Makefile                           |   3 +-
 drivers/irqchip/irq-atmel-aic5.c                   |  12 +-
 drivers/irqchip/irq-bcm7120-l2.c                   | 219 +++++++++++++++++++++
 drivers/irqchip/irq-gic-v3.c                       |  87 ++++++--
 6 files changed, 385 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
 create mode 100644 drivers/irqchip/irq-bcm7120-l2.c
