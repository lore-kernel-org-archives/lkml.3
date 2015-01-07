Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbbAGRxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:53:05 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:45661 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbbAGRw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:52:57 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/10] rcutorture: Add checks for stall ending before dump start
Date: Wed,  7 Jan 2015 09:52:40 -0800
Message-Id: <1420653168-6434-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420653168-6434-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107175225.GA4237@linux.vnet.ibm.com>
 <1420653168-6434-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0033-0000-0000-0000033D2477
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The current rcutorture scripting checks for actual stalls (via the "Call
Trace:" check), but fails to spot the case where a stall ends just as it
is being detected.  This commit therefore adds a check for this case.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/parse-console.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rcutorture/bin/parse-console.sh b/tools/testing/selftests/rcutorture/bin/parse-console.sh
index f962ba4cf68b..d8f35cf116be 100755
--- a/tools/testing/selftests/rcutorture/bin/parse-console.sh
+++ b/tools/testing/selftests/rcutorture/bin/parse-console.sh
@@ -36,7 +36,7 @@ if grep -Pq '\x00' < $file
 then
 	print_warning Console output contains nul bytes, old qemu still running?
 fi
-egrep 'Badness|WARNING:|Warn|BUG|===========|Call Trace:|Oops:' < $file | grep -v 'ODEBUG: ' | grep -v 'Warning: unable to open an initial console' > $T
+egrep 'Badness|WARNING:|Warn|BUG|===========|Call Trace:|Oops:|Stall ended before state dump start' < $file | grep -v 'ODEBUG: ' | grep -v 'Warning: unable to open an initial console' > $T
 if test -s $T
 then
 	print_warning Assertion failure in $file $title
-- 
1.8.1.5

