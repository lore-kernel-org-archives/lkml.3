Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab3JGPaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:30:35 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:6535 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab3JGPac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:30:32 -0400
Message-ID: <5252D397.6040302@tilera.com>
Date: Mon, 7 Oct 2013 11:30:31 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] tile bug fixes for v3.12-rc5
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for 3.12-rc5 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable

This fixes some serious issues with PREEMPT support, and a couple of smaller
corner-case issues fixed in the last couple of weeks.

Andy Shevchenko (1):
      arch: tile: re-use kbasename() helper

Chen Gang (1):
      tile: include: asm: use 'long long' instead of 'u64' for atomic64_t and its related functions

Chris Metcalf (2):
      tile: ensure interrupts disabled for preempt_schedule_irq()
      tile: use a more conservative __my_cpu_offset in CONFIG_PREEMPT

Henrik Austad (1):
      tile: change lock initalization in hardwall

 arch/tile/include/asm/atomic.h    |  5 +++--
 arch/tile/include/asm/atomic_32.h | 27 +++++++++++++++------------
 arch/tile/include/asm/cmpxchg.h   | 28 +++++++++++++++++-----------
 arch/tile/include/asm/percpu.h    | 34 +++++++++++++++++++++++++++++++---
 arch/tile/kernel/hardwall.c       |  6 +++---
 arch/tile/kernel/intvec_32.S      |  3 +++
 arch/tile/kernel/intvec_64.S      |  3 +++
 arch/tile/kernel/stack.c          | 12 +++++-------
 arch/tile/lib/atomic_32.c         |  8 ++++----
 9 files changed, 84 insertions(+), 42 deletions(-)
-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

