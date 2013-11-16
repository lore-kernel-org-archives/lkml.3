Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab3KPAjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:39:18 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:49412 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab3KPAfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:35:54 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH tip/core/rcu 17/28] rcutorture: Eliminate configdir argument from kvm-recheck.sh script
Date: Fri, 15 Nov 2013 16:35:30 -0800
Message-Id: <1384562141-32446-17-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-1344-0000-0000-0000034C9887
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Don't grab the configuration fragment from the configs directory because
it might well have been changed since the test was run.  Instead, use
the ConfigFragment file that was placed in the results directory.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rcutorture/bin/kvm-recheck.sh | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
index 0876af75b66b..26e82b5d67f8 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
@@ -4,7 +4,7 @@
 # check the build and console output for errors.  Given a directory
 # containing results directories, this recursively checks them all.
 #
-# Usage: sh kvm-recheck.sh configdir resdir ...
+# Usage: sh kvm-recheck.sh resdir ...
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
@@ -25,8 +25,6 @@
 # Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
 
 PATH=`pwd`/tools/testing/selftests/rcutorture/bin:$PATH; export PATH
-configdir=${1}
-shift
 for rd in "$@"
 do
 	dirs=`find $rd -name Make.defconfig.out -print | sort | sed -e 's,/[^/]*$,,' | sort -u`
@@ -34,7 +32,7 @@ do
 	do
 		configfile=`echo $i | sed -e 's/^.*\///'`
 		echo $i
-		configcheck.sh $i/.config $configdir/$configfile
+		configcheck.sh $i/.config $i/ConfigFragment
 		parse-build.sh $i/Make.out $configfile
 		parse-rcutorture.sh $i/console.log $configfile
 		parse-console.sh $i/console.log $configfile
-- 
1.8.1.5

