Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab3GMBep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 21:34:45 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:42465 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984Ab3GMBen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 21:34:43 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH RFC 0/2] qrwlock: Introducing a queue read/write lock implementation
Date: Fri, 12 Jul 2013 21:34:07 -0400
Message-Id: <1373679249-27123-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces a queue-based read/write implementation that
is both faster and fairer than the current read/write lock. It can
also be used as a replacement for ticket spinlocks that are highly
contended if lock size increase is not an issue.

There is no change in the interface. By just replacing the current
read/write lock with the queue read/write lock, we can have a faster
and more deterministic system.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Waiman Long (2):
  qrwlock: A queue read/write lock implementation
  x86 qrwlock: Enable x86 to use queue read/write lock

 arch/x86/Kconfig                      |    3 +
 arch/x86/include/asm/spinlock.h       |    2 +
 arch/x86/include/asm/spinlock_types.h |    4 +
 include/asm-generic/qrwlock.h         |  124 +++++++++++++++++
 lib/Kconfig                           |   11 ++
 lib/Makefile                          |    1 +
 lib/qrwlock.c                         |  246 +++++++++++++++++++++++++++++++++
 7 files changed, 391 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/qrwlock.h
 create mode 100644 lib/qrwlock.c

