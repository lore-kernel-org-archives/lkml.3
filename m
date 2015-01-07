Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbbAGSWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:22:50 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:55740 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbbAGSTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:19:51 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/12] torture: Add "-enable-kvm -soundhw pcspk" to qemu command line
Date: Wed,  7 Jan 2015 10:19:36 -0800
Message-Id: <1420654779-11213-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107181915.GA7803@linux.vnet.ibm.com>
 <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010718-0033-0000-0000-0000033D3B4E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

More recent qemu implementations really want "-enable-kvm", and the
"-soundhw pcspk" makes the script a bit less dependent on odd audio
libraries being installed.  This commit therefore adds both to the
default qemu command line.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index 8ca9f21f2efc..35b8532ed053 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -8,9 +8,9 @@
 #
 # Usage: kvm-test-1-run.sh config builddir resdir minutes qemu-args boot_args
 #
-# qemu-args defaults to "-nographic", along with arguments specifying the
-#			number of CPUs and other options generated from
-#			the underlying CPU architecture.
+# qemu-args defaults to "-enable-kvm -soundhw pcspk -nographic", along with
+#			arguments specifying the number of CPUs and other
+#			options generated from the underlying CPU architecture.
 # boot_args defaults to value returned by the per_version_boot_params
 #			shell function.
 #
@@ -138,7 +138,7 @@ then
 fi
 
 # Generate -smp qemu argument.
-qemu_args="-nographic $qemu_args"
+qemu_args="-enable-kvm -soundhw pcspk -nographic $qemu_args"
 cpu_count=`configNR_CPUS.sh $config_template`
 cpu_count=`configfrag_boot_cpus "$boot_args" "$config_template" "$cpu_count"`
 vcpus=`identify_qemu_vcpus`
-- 
1.8.1.5

