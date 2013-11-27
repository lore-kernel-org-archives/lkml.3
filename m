Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab3K0OKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:10:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47743 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab3K0OKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:10:16 -0500
Date: Wed, 27 Nov 2013 06:09:41 -0800
From: tip-bot for Sasha Levin <tipbot@zytor.com>
Message-ID: <tip-f612ac05b7ce66919507d25f4c81e4272f7a8705@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1371163284-6346-9-git-send-email-sasha.levin@oracle.com>
References: <1371163284-6346-9-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] liblockdep: Add the 'lockdep'
  user-space utility
Git-Commit-ID: f612ac05b7ce66919507d25f4c81e4272f7a8705
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 27 Nov 2013 06:09:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f612ac05b7ce66919507d25f4c81e4272f7a8705
Gitweb:     http://git.kernel.org/tip/f612ac05b7ce66919507d25f4c81e4272f7a8705
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Thu, 13 Jun 2013 18:41:23 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 27 Nov 2013 11:56:25 +0100

liblockdep: Add the 'lockdep' user-space utility

This is a simple wrapper to make using liblockdep on existing
applications much easier.

After running 'make && make install', it becomes quite simple to
test things with liblockdep. For example, to try it on perf:

	lockdep perf

No other integration required.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@linux-foundation.org
Link: http://lkml.kernel.org/r/1371163284-6346-9-git-send-email-sasha.levin@oracle.com
[ Changed it to load ./liblockdep.so, so it can be tested in situ. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/lib/lockdep/lockdep | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/lockdep/lockdep b/tools/lib/lockdep/lockdep
new file mode 100755
index 0000000..49af9fe
--- /dev/null
+++ b/tools/lib/lockdep/lockdep
@@ -0,0 +1,3 @@
+#!/bin/bash
+
+LD_PRELOAD="./liblockdep.so $LD_PRELOAD" "$@"
