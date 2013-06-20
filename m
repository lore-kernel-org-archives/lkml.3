Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965362Ab3FTLcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:32:21 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34875 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965276Ab3FTLcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:32:18 -0400
Subject: [PATCH v5 0/7] add mutex wait/wound/style style locks
To: linux-kernel@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, peterz@infradead.org, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, rostedt@goodmis.org, daniel@ffwll.ch,
        tglx@linutronix.de, mingo@kernel.org, linux-media@vger.kernel.org
Date: Thu, 20 Jun 2013 13:30:55 +0200
Message-ID: <20130620112811.4001.86934.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v4:
- Some documentation cleanups.
- Added a lot more tests to cover all the DEBUG_LOCKS_WARN_ON cases.
- Added EDEADLK tests.
- Split off the normal mutex tests to a separate patch.
- Added a patch to not allow tests to fail that succeed with PROVE_LOCKING enabled.

---

Daniel Vetter (1):
      mutex: w/w mutex slowpath debugging

Maarten Lankhorst (6):
      arch: make __mutex_fastpath_lock_retval return whether fastpath succeeded or not.
      mutex: add support for wound/wait style locks, v5
      mutex: Add ww tests to lib/locking-selftest.c. v5
      mutex: add more tests to lib/locking-selftest.c
      mutex: add more ww tests to test EDEADLK path handling
      locking-selftests: handle unexpected failures more strictly


 Documentation/ww-mutex-design.txt |  343 ++++++++++++++++++
 arch/ia64/include/asm/mutex.h     |   10 -
 arch/powerpc/include/asm/mutex.h  |   10 -
 arch/sh/include/asm/mutex-llsc.h  |    4 
 arch/x86/include/asm/mutex_32.h   |   11 -
 arch/x86/include/asm/mutex_64.h   |   11 -
 include/asm-generic/mutex-dec.h   |   10 -
 include/asm-generic/mutex-null.h  |    2 
 include/asm-generic/mutex-xchg.h  |   10 -
 include/linux/mutex-debug.h       |    1 
 include/linux/mutex.h             |  363 +++++++++++++++++++
 kernel/mutex.c                    |  384 ++++++++++++++++++--
 lib/Kconfig.debug                 |   13 +
 lib/debug_locks.c                 |    2 
 lib/locking-selftest.c            |  720 ++++++++++++++++++++++++++++++++++++-
 15 files changed, 1802 insertions(+), 92 deletions(-)
 create mode 100644 Documentation/ww-mutex-design.txt

-- 
Signature
