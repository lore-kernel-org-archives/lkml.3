Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307AbaD2Aas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:30:48 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59722 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090AbaD2AZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:51 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 15/45] torture: Make config-fragment filtering RCU-independent
Date: Mon, 28 Apr 2014 17:25:03 -0700
Message-Id: <1398731133-18925-15-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-0928-0000-0000-0000018D1381
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The torture tests need to set specific values for their respective
Kconfig options (e.g., CONFIG_LOCK_TORTURE_TEST), and must therefore
filter any conflicting definitions from the Kconfig fragment
file.  Unfortunately, the code in kvm-build.sh was looking only for
CONFIG_RCU_TORTURE_TEST.  This commit therefore handles the general case
of CONFIG_[A-Z]*TORTURE_TEST.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm-build.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-build.sh b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
index e838c775f709..6d0b76d918f4 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-build.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
@@ -45,7 +45,7 @@ T=/tmp/test-linux.sh.$$
 trap 'rm -rf $T' 0
 mkdir $T
 
-cat ${config_template} | grep -v CONFIG_RCU_TORTURE_TEST > $T/config
+cat ${config_template} | grep -v 'CONFIG_[A-Z]*_TORTURE_TEST' > $T/config
 cat << ___EOF___ >> $T/config
 CONFIG_INITRAMFS_SOURCE="$TORTURE_INITRD"
 CONFIG_VIRTIO_PCI=y
-- 
1.8.1.5

