Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaBQWNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:13:18 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:54838 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaBQWNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:12 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/55] rcutorture: Move common qemu flags to kvm-test-1.sh
Date: Mon, 17 Feb 2014 14:12:09 -0800
Message-Id: <1392675179-11560-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-3532-0000-0000-000005BEDC53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently, most qemu flags are calculated in kvm-test-1-rcu.sh,
except that -nographics is set up by kvm.sh.  This commit promotes
one-stop shopping by consolidating the determination of qemu flags into
kvm-test-1-rcu.sh.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh | 1 +
 tools/testing/selftests/rcutorture/bin/kvm.sh            | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
index c3a396518113..a06a0a6ce5ac 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
@@ -126,6 +126,7 @@ echo ' ---' `date`: Starting kernel
 QEMU="`identify_qemu $builddir/vmlinux.o`"
 
 # Generate -smp qemu argument.
+qemu_args="-nographic $qemu_args"
 cpu_count=`configNR_CPUS.sh $config_template`
 vcpus=`identify_qemu_vcpus`
 if test $cpu_count -gt $vcpus
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 979881baa80f..f2113493bbfc 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -203,7 +203,7 @@ do
 	fi
 	mkdir "${rd}"
 	echo Results directory: $rd
-	kvm-test-1-rcu.sh $CONFIGFRAG/$kversion/$CF $builddir $rd $dur "-nographic $RCU_QEMU_ARG" "$RCU_BOOTARGS"
+	kvm-test-1-rcu.sh $CONFIGFRAG/$kversion/$CF $builddir $rd $dur "$RCU_QEMU_ARG" "$RCU_BOOTARGS"
 done
 # Tracing: trace_event=rcu:rcu_grace_period,rcu:rcu_future_grace_period,rcu:rcu_grace_period_init,rcu:rcu_nocb_wake,rcu:rcu_preempt_task,rcu:rcu_unlock_preempted_task,rcu:rcu_quiescent_state_report,rcu:rcu_fqs,rcu:rcu_callback,rcu:rcu_kfree_callback,rcu:rcu_batch_start,rcu:rcu_invoke_callback,rcu:rcu_invoke_kfree_callback,rcu:rcu_batch_end,rcu:rcu_torture_read,rcu:rcu_barrier
 
-- 
1.8.1.5

