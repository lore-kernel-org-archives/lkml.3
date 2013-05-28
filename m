Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934441Ab3E1OtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:49:08 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46465 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934359Ab3E1OtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:49:04 -0400
Subject: [PATCH v4 0/4] add mutex wait/wound/style style locks
To: linux-kernel@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, peterz@infradead.org, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, rostedt@goodmis.org, daniel@ffwll.ch,
        tglx@linutronix.de, mingo@elte.hu, linux-media@vger.kernel.org
Date: Tue, 28 May 2013 16:48:26 +0200
Message-ID: <20130528144420.4538.70725.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 4 already?

Small api changes since v3:
- Remove ww_mutex_unlock_single and ww_mutex_lock_single.
- Rename ww_mutex_trylock_single to ww_mutex_trylock.
- Remove separate implementations of ww_mutex_lock_slow*, normal
  functions can be used. Inline versions still exist for extra
  debugging, and to annotate.
- Cleanup unneeded memory barriers, add comment to the remaining
  smp_mb().

Thanks to Daniel Vetter, Rob Clark and Peter Zijlstra for their feedback.
---

Daniel Vetter (1):
      mutex: w/w mutex slowpath debugging

Maarten Lankhorst (3):
      arch: make __mutex_fastpath_lock_retval return whether fastpath succeeded or not.
      mutex: add support for wound/wait style locks, v5
      mutex: Add ww tests to lib/locking-selftest.c. v4


 Documentation/ww-mutex-design.txt |  344 +++++++++++++++++++++++++++++++
 arch/ia64/include/asm/mutex.h     |   10 -
 arch/powerpc/include/asm/mutex.h  |   10 -
 arch/sh/include/asm/mutex-llsc.h  |    4 
 arch/x86/include/asm/mutex_32.h   |   11 -
 arch/x86/include/asm/mutex_64.h   |   11 -
 include/asm-generic/mutex-dec.h   |   10 -
 include/asm-generic/mutex-null.h  |    2 
 include/asm-generic/mutex-xchg.h  |   10 -
 include/linux/mutex-debug.h       |    1 
 include/linux/mutex.h             |  363 +++++++++++++++++++++++++++++++++
 kernel/mutex.c                    |  384 ++++++++++++++++++++++++++++++++---
 lib/Kconfig.debug                 |   13 +
 lib/debug_locks.c                 |    2 
 lib/locking-selftest.c            |  410 +++++++++++++++++++++++++++++++++++--
 15 files changed, 1492 insertions(+), 93 deletions(-)
 create mode 100644 Documentation/ww-mutex-design.txt

-- 
~Maarten
