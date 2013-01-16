Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab3APORb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:17:31 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:58921 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3APOR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:17:29 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq_work changes for 3.9
Date: Wed, 16 Jan 2013 15:17:21 +0100
Message-Id: <1358345841-29136-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The printk changes for full dynticks support are still pending while
we don't know Linus's opinion about these. Meanwhile here is the
part of it that I think is uncontroversial. This way we can make
the next submission attempt to Linus a bit more simple.

These three patches are general fixes for irq work. The two first
patches fix tight races on global irq work claiming that prevent the irq work
subsystem from dropping a work enqueuing attempt because it thinks it's
already pending while it may be already executing or executed.

The last patch just extends irq work support everywhere. It's also a
kconfig cleanup.

The branch can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	core/irq_work

Head is: 6147a9d8070e1c9d16d57eb53a14942b95b28dc4

Thanks.

---
Frederic Weisbecker (3):
  irq_work: Fix racy IRQ_WORK_BUSY flag setting
  irq_work: Fix racy check on work pending flag
  irq_work: Remove CONFIG_HAVE_IRQ_WORK

 arch/alpha/Kconfig                  |    1 -
 arch/arm/Kconfig                    |    1 -
 arch/arm64/Kconfig                  |    1 -
 arch/blackfin/Kconfig               |    1 -
 arch/frv/Kconfig                    |    1 -
 arch/hexagon/Kconfig                |    1 -
 arch/mips/Kconfig                   |    1 -
 arch/parisc/Kconfig                 |    1 -
 arch/powerpc/Kconfig                |    1 -
 arch/s390/Kconfig                   |    1 -
 arch/sh/Kconfig                     |    1 -
 arch/sparc/Kconfig                  |    1 -
 arch/x86/Kconfig                    |    1 -
 drivers/staging/iio/trigger/Kconfig |    1 -
 init/Kconfig                        |    4 ----
 kernel/irq_work.c                   |   21 +++++++++++++++------
 16 files changed, 15 insertions(+), 24 deletions(-)

-- 
1.7.5.4

