Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaINIHb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 04:07:31 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52070 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752397AbaINIHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 04:07:22 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Aj3ecXwftN6hM75AEBwyhQ+jBJOaZRzM=
X-DKIM: OpenDKIM Filter v2.0.1 titan 063405E1671
Date: Sun, 14 Sep 2014 04:07:19 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: Fixes for v3.17
Message-ID: <20140914080719.GR21986@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Sorry, I got a bit wrapped around the axle and these sat longer than I
wanted.  They've been in -next quite a while.

Please pull.

thx,

Jason.

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.infradead.org/users/jcooper/linux.git tags/irqchip-urgent-3.17

for you to fetch changes up to fea322d1df439a8daefc6e00d65b879a03f83b17:

  irqchip: gic-v3: Declare rdist as __percpu pointer to __iomem pointer (2014-09-03 12:08:10 +0000)

----------------------------------------------------------------
irqchip fixes for v3.17

 - gic-v3
    - SMP build fix
    - tag low level accessors __maybe_unused
    - declare rdist as __percpu

 - gic
    - staticize

 - crossbar
    - fix off-by-one bug

 - exynos-combiner
    - fix arm64 build error

----------------------------------------------------------------
Dan Carpenter (1):
      irqchip: crossbar: Off by one bugs in init

Mark Brown (2):
      irqchip: gic-v3: Only define gic_peek_irq() when building SMP
      irqchip: gic-v3: Tag all low level accessors __maybe_unused

Naveen Krishna Chatradhi (1):
      irqchip: exynos-combiner: Fix compilation error on ARM64

Will Deacon (2):
      irqchip: gic: Make gic_default_routable_irq_domain_ops static
      irqchip: gic-v3: Declare rdist as __percpu pointer to __iomem pointer

 drivers/irqchip/exynos-combiner.c |  1 +
 drivers/irqchip/irq-crossbar.c    |  4 ++--
 drivers/irqchip/irq-gic-v3.c      | 38 +++++++++++++++++++-------------------
 drivers/irqchip/irq-gic.c         |  2 +-
 4 files changed, 23 insertions(+), 22 deletions(-)
