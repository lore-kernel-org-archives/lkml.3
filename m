Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaHEW4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 18:56:48 -0400
Received: from imap.thunk.org ([74.207.234.97]:46199 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbaHEW4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 18:56:47 -0400
Date: Tue, 5 Aug 2014 18:56:40 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] random changes for 3.17
Message-ID: <20140805225640.GA19511@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1795cd9b3a91d4b5473c97f491d63892442212ab:

  Linux 3.16-rc5 (2014-07-13 14:04:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git tags/random_for_linus

for you to fetch changes up to e02b876597777ab26288dd2611a97b597d14d661:

  hwrng: Pass entropy to add_hwgenerator_randomness() in bits, not bytes (2014-08-05 16:50:10 -0400)

----------------------------------------------------------------
Cleanups and bug fixes to /dev/random, add a new getrandom(2) system
call, which is a superset of OpenBSD's getentropy(2) call, for use
with userspace crypto libraries such as LibreSSL.  Also add the
ability to have a kernel thread to pull entropy from hardware rng
devices into /dev/random.

----------------------------------------------------------------
Stephen Boyd (1):
      hwrng: Pass entropy to add_hwgenerator_randomness() in bits, not bytes

Theodore Ts'o (8):
      random: always update the entropy pool under the spinlock
      random: remove unneeded hash of a portion of the entropy pool
      random: only update the last_pulled time if we actually transferred entropy
      random: clean up interrupt entropy accounting for archs w/o cycle counters
      random: use an improved fast_mix() function
      random: use registers from interrupted code for CPU's w/o a cycle counter
      random: introduce getrandom(2) system call
      random: limit the contribution of the hw rng to at most half

Torsten Duwe (4):
      random: add_hwgenerator_randomness() for feeding entropy from devices
      hwrng: create filler thread
      hwrng: add per-device entropy derating
      hw_random: fix sparse warning (NULL vs 0 for pointer)

 arch/x86/syscalls/syscall_32.tbl  |   1 +
 arch/x86/syscalls/syscall_64.tbl  |   1 +
 drivers/char/hw_random/core.c     |  78 ++++++++++++++++--
 drivers/char/random.c             | 315 +++++++++++++++++++++++++++++++++++++++++++-----------------------------
 include/linux/hw_random.h         |   5 ++
 include/linux/syscalls.h          |   3 +
 include/uapi/asm-generic/unistd.h |   4 +-
 include/uapi/linux/random.h       |   9 +++
 8 files changed, 282 insertions(+), 134 deletions(-)
