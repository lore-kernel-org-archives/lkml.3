Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab3FJAta (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 20:49:30 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:41785 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab3FJAt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 20:49:29 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC 00/10] Refactor irqdomain
Date: Mon, 10 Jun 2013 01:49:12 +0100
Message-Id: <1370825362-11145-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've done a bunch of refactoring work on the irq_domain infrastructure.
Some of these patches I've posted before, and some our brand new. The
goal of this is to greatly simplify how irq_domains work. With this
series, instead of there being multiple different types of irq domains,
each with different mapping rules, instead there is now only one time of
irq_domain that contains both kinds of map; the linear map for irqs
below a certain value, and the radix tree for large & sparse irq
controllers. As you can see from the following diffstat, the result is a
fair bit less code. It should make it easier to understand irqdomains
too.

 arch/powerpc/platforms/cell/beat_interrupt.c |   2 +-
 arch/powerpc/platforms/powermac/smp.c        |   2 +-
 drivers/irqchip/Kconfig                      |   1 +
 drivers/irqchip/irq-versatile-fpga.c         | 104 ++++------
 include/linux/irqdomain.h                    | 123 ++++++-----
 kernel/irq/generic-chip.c                    |   6 +-
 kernel/irq/irqdomain.c                       | 555
 ++++++++++++++++----------------------------------
 7 files changed, 282 insertions(+), 511 deletions(-)

I've pushed this series out to my git server at the following branch:

git://git.secretlab.ca/git/linux irqdomain/next

It depends on the tip tree's irq/for-arm branch and also Linus' mainline
(they need to be merged). The branch above includes both.

I've tested this on ARM qemu models, but not much else. I'll test on
real hardware before pushing out, but I would appreciate anybody doing
additional testing, particularly on PowerPC and other non-ARM platforms.

Cheers,
g.

