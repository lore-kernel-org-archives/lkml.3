Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab3BKMcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:32:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60438 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab3BKMcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:32:47 -0500
Date: Mon, 11 Feb 2013 04:32:32 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-36c2dd52a2740ea6b87fc51713531e560d135c5c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1360456781-32462-10-git-send-email-sasha.levin@oracle.com>
References: <1360456781-32462-10-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] liblockdep:
  Add tests for the LD_PRELOAD feature
Git-Commit-ID: 36c2dd52a2740ea6b87fc51713531e560d135c5c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Feb 2013 04:32:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  36c2dd52a2740ea6b87fc51713531e560d135c5c
Gitweb:     http://git.kernel.org/tip/36c2dd52a2740ea6b87fc51713531e560d135c5c
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Sat, 9 Feb 2013 19:39:40 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Feb 2013 10:12:41 +0100

liblockdep: Add tests for the LD_PRELOAD feature

Use same tests, but without compiling with liblockdep in the
first place.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: jamie.iles@oracle.com
Cc: penberg@kernel.org
Cc: acme@ghostprotocols.net
Cc: paulus@samba.org
Cc: namhyung@kernel.org
Cc: peterz@infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1360456781-32462-10-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/lib/lockdep/run_tests.sh | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/lib/lockdep/run_tests.sh b/tools/lib/lockdep/run_tests.sh
index 4dd32d1..211e91d 100755
--- a/tools/lib/lockdep/run_tests.sh
+++ b/tools/lib/lockdep/run_tests.sh
@@ -13,3 +13,15 @@ for i in `ls tests/*.c`; do
 	fi
 	rm tests/$testname
 done
+
+for i in `ls tests/*.c`; do
+	testname=$(basename -s .c "$i")
+	gcc -o tests/$testname -lpthread -Iinclude $i &> /dev/null
+	echo -ne "(PRELOAD) $testname... "
+	if [ $(LD_PRELOAD=./liblockdep.so timeout 1 ./tests/$testname | wc -l) -gt 0 ]; then
+		echo "PASSED!"
+	else
+		echo "FAILED!"
+	fi
+	rm tests/$testname
+done
