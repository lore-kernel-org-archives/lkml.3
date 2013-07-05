Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3GEGmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 02:42:00 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33474 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab3GEGl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 02:41:59 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 5 Jul 2013 07:41:38 +0100
X-Google-Sender-Auth: _xtvIhabyZxkpGtDGZRvGUxuPNY
Message-ID: <CACxGe6tCOnYpZz9a1=RKqnYEsarXHe7bAvUBx6Fm9T-BQAm9rw@mail.gmail.com>
Subject: [GIT PULL] irqdomain refactoring for v3.11
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following irqdomain tree.

The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a10:

  Linux 3.10-rc5 (2013-06-08 17:41:04 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux tags/irqdomain-for-linus

for you to fetch changes up to 798f0fd188be3656991c8745104b5ee045769a5f:

  irq: fix checkpatch error (2013-06-24 14:02:43 +0100)

----------------------------------------------------------------
(from the branch description for irqdomain/next local branch)

clone of "devicetree/test"
irqdomain refactoring for v3.11

This is the long awaited simplification of irqdomain. It gets rid of the
different types of irq domains and instead both linear and tree mappings
can be supported in a single domain. Doing this removes a lot of special
case code and makes irq domains simpler to understand overall.

----------------------------------------------------------------
Grant Likely (12):
      Merge remote-tracking branch 'tip/irq/for-arm' into irqdomain/next
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

Kefeng Wang (1):
      irq: fix checkpatch error

 arch/powerpc/platforms/cell/beat_interrupt.c |   2 +-
 arch/powerpc/platforms/powermac/smp.c        |   2 +-
 arch/x86/kernel/devicetree.c                 |   4 +-
 include/linux/irq.h                          |  47 ++-
 include/linux/irqdomain.h                    | 140 ++++---
 kernel/irq/generic-chip.c                    | 299 ++++++++++++--
 kernel/irq/irqdomain.c                       | 585 +++++++++------------------
 kernel/irq/proc.c                            |   2 +
 8 files changed, 569 insertions(+), 512 deletions(-)
