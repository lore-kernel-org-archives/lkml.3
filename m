Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab3KPAjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:39:31 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:38207 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab3KPAfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:35:53 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH tip/core/rcu 13/28] rcutorture: Remove decorative qemu argument
Date: Fri, 15 Nov 2013 16:35:26 -0800
Message-Id: <1384562141-32446-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-0928-0000-0000-0000037AA9F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The qemu -name argument doesn't seem to be useful in this environment,
so this commit removes it.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
index ddf3bd6eaf19..5e2e79b5eaba 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
@@ -137,7 +137,7 @@ boot_args="`rcutorture_param_n_barrier_cbs "$boot_args"`"
 # Pull in Kconfig-fragment boot parameters
 boot_args="`configfrag_boot_params "$boot_args" "$config_template"`"
 
-echo $QEMU -name rcu-test -serial file:$builddir/console.log $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append \"noapic selinux=0 console=ttyS0 initcall_debug debug rcutorture.stat_interval=15 rcutorture.shutdown_secs=$seconds rcutorture.rcutorture_runnable=1 $boot_args\" > $resdir/qemu-cmd
+echo $QEMU -serial file:$builddir/console.log $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append \"noapic selinux=0 console=ttyS0 initcall_debug debug rcutorture.stat_interval=15 rcutorture.shutdown_secs=$seconds rcutorture.rcutorture_runnable=1 $boot_args\" > $resdir/qemu-cmd
 $QEMU -name rcu-test -serial file:$builddir/console.log $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append "noapic selinux=0 console=ttyS0 initcall_debug debug rcutorture.stat_interval=15 rcutorture.shutdown_secs=$seconds rcutorture.rcutorture_runnable=1 $boot_args" &
 qemu_pid=$!
 commandcompleted=0
-- 
1.8.1.5

