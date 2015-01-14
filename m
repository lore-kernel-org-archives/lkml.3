Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbbANHJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:09:52 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:46127 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbbANHJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:09:50 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        james.hogan@imgtec.com, avagin@openvz.org, Paul.Clothier@imgtec.com,
        palves@redhat.com, oleg@redhat.com, dhowells@redhat.com,
        davej@redhat.com, davem@davemloft.net, mikey@neuling.org,
        benh@kernel.crashing.org, sukadev@linux.vnet.ibm.com,
        mpe@ellerman.id.au, sam.bobroff@au1.ibm.com, kirjanov@gmail.com,
        shuahkh@osg.samsung.com
Subject: [PATCH V7 8/8] selftests: Make GIT ignore all binaries in powerpc test suite
Date: Wed, 14 Jan 2015 12:38:50 +0530
Message-Id: <1421219330-19984-9-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421219330-19984-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1421219330-19984-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011407-0017-0000-0000-000000AA20BC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes all of the powerpc test binaries into the
.gitignore file listing in their respective directories. This
will make sure that GIT ignores all of these test binaries while
displaying status.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
NOTE: As Michael had mentioned (https://lkml.org/lkml/2015/1/13/868)
adding binaries into different .gitignore file in their respective
test directories under powerpc.

 .../testing/selftests/powerpc/copyloops/.gitignore |  4 ++++
 tools/testing/selftests/powerpc/mm/.gitignore      |  1 +
 tools/testing/selftests/powerpc/pmu/.gitignore     |  3 +++
 tools/testing/selftests/powerpc/pmu/ebb/.gitignore | 22 ++++++++++++++++++++++
 .../selftests/powerpc/primitives/.gitignore        |  1 +
 tools/testing/selftests/powerpc/tm/.gitignore      |  2 ++
 6 files changed, 33 insertions(+)
 create mode 100644 tools/testing/selftests/powerpc/copyloops/.gitignore
 create mode 100644 tools/testing/selftests/powerpc/mm/.gitignore
 create mode 100644 tools/testing/selftests/powerpc/pmu/.gitignore
 create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/.gitignore
 create mode 100644 tools/testing/selftests/powerpc/primitives/.gitignore
 create mode 100644 tools/testing/selftests/powerpc/tm/.gitignore

diff --git a/tools/testing/selftests/powerpc/copyloops/.gitignore b/tools/testing/selftests/powerpc/copyloops/.gitignore
new file mode 100644
index 0000000..25a192f
--- /dev/null
+++ b/tools/testing/selftests/powerpc/copyloops/.gitignore
@@ -0,0 +1,4 @@
+copyuser_64
+copyuser_power7
+memcpy_64
+memcpy_power7
diff --git a/tools/testing/selftests/powerpc/mm/.gitignore b/tools/testing/selftests/powerpc/mm/.gitignore
new file mode 100644
index 0000000..156f4e8
--- /dev/null
+++ b/tools/testing/selftests/powerpc/mm/.gitignore
@@ -0,0 +1 @@
+hugetlb_vs_thp_test
diff --git a/tools/testing/selftests/powerpc/pmu/.gitignore b/tools/testing/selftests/powerpc/pmu/.gitignore
new file mode 100644
index 0000000..e748f33
--- /dev/null
+++ b/tools/testing/selftests/powerpc/pmu/.gitignore
@@ -0,0 +1,3 @@
+count_instructions
+l3_bank_test
+per_event_excludes
diff --git a/tools/testing/selftests/powerpc/pmu/ebb/.gitignore b/tools/testing/selftests/powerpc/pmu/ebb/.gitignore
new file mode 100644
index 0000000..42bddbe
--- /dev/null
+++ b/tools/testing/selftests/powerpc/pmu/ebb/.gitignore
@@ -0,0 +1,22 @@
+reg_access_test
+event_attributes_test
+cycles_test
+cycles_with_freeze_test
+pmc56_overflow_test
+ebb_vs_cpu_event_test
+cpu_event_vs_ebb_test
+cpu_event_pinned_vs_ebb_test
+task_event_vs_ebb_test
+task_event_pinned_vs_ebb_test
+multi_ebb_procs_test
+multi_counter_test
+pmae_handling_test
+close_clears_pmcc_test
+instruction_count_test
+fork_cleanup_test
+ebb_on_child_test
+ebb_on_willing_child_test
+back_to_back_ebbs_test
+lost_exception_test
+no_handler_test
+cycles_with_mmcr2_test
diff --git a/tools/testing/selftests/powerpc/primitives/.gitignore b/tools/testing/selftests/powerpc/primitives/.gitignore
new file mode 100644
index 0000000..4cc4e31
--- /dev/null
+++ b/tools/testing/selftests/powerpc/primitives/.gitignore
@@ -0,0 +1 @@
+load_unaligned_zeropad
diff --git a/tools/testing/selftests/powerpc/tm/.gitignore b/tools/testing/selftests/powerpc/tm/.gitignore
new file mode 100644
index 0000000..71f9f9d
--- /dev/null
+++ b/tools/testing/selftests/powerpc/tm/.gitignore
@@ -0,0 +1,2 @@
+tm-ptrace
+tm-resched-dscr
-- 
1.9.3

