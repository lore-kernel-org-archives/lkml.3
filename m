Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3FNVIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:08:14 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:56254 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab3FNVIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:08:13 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 00/11] irqdomain: Refactor
Date: Fri, 14 Jun 2013 22:07:55 +0100
Message-Id: <1371244086-9189-1-git-send-email-grant.likely@linaro.org>
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

This is the second posting of this series. I've added a couple more
patches and dropped an unrelated patch to the versatile irq driver.

irqdomain: Relax failure path on setting up mappings
irqdomain: Replace LEGACY mapping with LINEAR
irqdomain: Add a name field
irqdomain: merge linear and tree reverse mappings.
irqdomain: Eliminate revmap type
irqdomain: Clean up aftermath of irq_domain refactoring
irqdomain: Beef up debugfs output
irqdomain: Refactor irq_domain_associate_many()
irqdomain: remove irq_domain_generate_simple()
irqdomain: make irq_linear_revmap() a fast path again
irqdomain: Include hwirq number in /proc/interrupts

 arch/powerpc/platforms/cell/beat_interrupt.c |   2 +-
 arch/powerpc/platforms/powermac/smp.c        |   2 +-
 arch/x86/kernel/devicetree.c                 |   4 +-
 include/linux/irqdomain.h                    | 142 +++++++------
 kernel/irq/generic-chip.c                    |   6 +-
 kernel/irq/irqdomain.c                       | 571 ++++++++++++++++----------------------------------
 kernel/irq/proc.c                            |   2 +
 7 files changed, 261 insertions(+), 468 deletions(-)

I've pushed this series out to my git server at the following branch:

git://git.secretlab.ca/git/linux irqdomain/test

It depends on the tip tree's irq/for-arm branch and also Linus' mainline
(they need to be merged). The branch above includes both.

Cheers,
g.

