Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab3I3OG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:06:58 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:43727 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab3I3OG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:06:57 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Russell King <rmk@arm.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arm Linux <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 0/3] nohz full: drop 64-bit requirement, enable ARM support v2
Date: Mon, 30 Sep 2013 16:06:49 +0200
Message-Id: <1380550012-7321-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

Your patchset was fine but I just did a second round. Namely I did the following changes:

* Drop the 64 bits dependency after we settle the new dependency on HAVE_VIRT_CPU_ACCOUNTING_GEN
and not before. This way we don't have a middle state that loose the dependency in the middle of
the patchset. Probablyt no big deal but it looks more natural this way.

* Refined a few changelogs.

If you're ok I'll send a pull request to Ingo.

Thanks.

Kevin Hilman (3):
  vtime: Add HAVE_VIRT_CPU_ACCOUNTING_GEN Kconfig
  nohz: Drop generic vtime obsolete dependency on CONFIG_64BIT
  ARM: Kconfig: allow full nohz CPU accounting

 arch/Kconfig        | 12 ++++++++++++
 arch/arm/Kconfig    |  1 +
 init/Kconfig        |  3 ++-
 kernel/time/Kconfig |  2 +-
 4 files changed, 16 insertions(+), 2 deletions(-)

-- 
1.8.3.1

