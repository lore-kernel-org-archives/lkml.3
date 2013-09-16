Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab3IPW21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:28:27 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:43434 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3IPW2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:28:25 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] nohz/full: drop 64-bit requirement, enable ARM support
Date: Mon, 16 Sep 2013 15:28:18 -0700
Message-Id: <1379370502-30376-1-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of v3.10, the core ARM arch support is in mainline for NO_HZ_FULL.
The only remaining part is the removal of the hard-coded Kconfig
requirement on 64-bit platforms, which I believe can now be removed
after the nsec granularity cputime was made to work on non 64_BIT
(c.f. commit 8c23b80e, cputime_nsecs: use math64.h for nsec resolution
conversion helpers.)

This series makes the final Kconfig changes to bring NO_HZ_FULL
support to ARM.

I will queue up the arch/arm patch for Russell separately once the
generic changes are accepted.

Applies on today's linus master (commit bdbdfdef57)

Kevin

Kevin Hilman (4):
  nohz_full: Kconfig: VIRT_CPU_ACCOUNTING_GEN: drop 64-bit requirement
  nohz_full: Kconfig: drop requrement on 64-bit
  full_nohz: Kconfig: add HAVE_VIRT_CPU_ACCOUNTING_GEN
  ARM: Kconfig: allow full nohz CPU accounting

 arch/Kconfig        | 11 +++++++++++
 arch/arm/Kconfig    |  1 +
 init/Kconfig        |  3 ++-
 kernel/time/Kconfig |  2 --
 4 files changed, 14 insertions(+), 3 deletions(-)

-- 
1.8.3

