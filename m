Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab3D1Rw2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 13:52:28 -0400
Received: from adelie.canonical.com ([91.189.90.139]:40230 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab3D1RwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 13:52:25 -0400
Subject: [PATCH v3 0/3] Wait/wound mutex implementation, v3
To: linux-kernel@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, peterz@infradead.org, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, rostedt@goodmis.org, daniel@ffwll.ch,
        tglx@linutronix.de, mingo@elte.hu, linux-media@vger.kernel.org
Date: Sun, 28 Apr 2013 19:03:34 +0200
Message-ID: <20130428165914.17075.57751.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements the updated api for wait/wound mutex locks.
The documentation and api should be complete, the implementation may not be
final. There is no support for -rt yet, and TASK_DEADLOCK handling is missing
too. However I believe that this is an implementation detail, and that the
interface for users of the api will not behave differently.

ww_acquire_ctx has been added, and a whole lot of api abuses are now correctly
detected because of the extra state carried in ww_acquire_ctx if debugging is
enabled.

---

Maarten Lankhorst (3):
      arch: make __mutex_fastpath_lock_retval return whether fastpath succeeded or not.
      mutex: add support for wound/wait style locks, v3
      mutex: Add ww tests to lib/locking-selftest.c. v3


 Documentation/ww-mutex-design.txt |  322 +++++++++++++++++++++++++
 arch/ia64/include/asm/mutex.h     |   10 -
 arch/powerpc/include/asm/mutex.h  |   10 -
 arch/sh/include/asm/mutex-llsc.h  |    4 
 arch/x86/include/asm/mutex_32.h   |   11 -
 arch/x86/include/asm/mutex_64.h   |   11 -
 include/asm-generic/mutex-dec.h   |   10 -
 include/asm-generic/mutex-null.h  |    2 
 include/asm-generic/mutex-xchg.h  |   10 -
 include/linux/mutex-debug.h       |    1 
 include/linux/mutex.h             |  257 ++++++++++++++++++++
 kernel/mutex.c                    |  473 ++++++++++++++++++++++++++++++++++---
 lib/debug_locks.c                 |    2 
 lib/locking-selftest.c            |  439 +++++++++++++++++++++++++++++++++-
 14 files changed, 1469 insertions(+), 93 deletions(-)
 create mode 100644 Documentation/ww-mutex-design.txt

-- 
Signature
