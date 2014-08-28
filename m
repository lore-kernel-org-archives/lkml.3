Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbaH1TNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:13:41 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45046 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbaH1TMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:12:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/11] rcutorture: Set executable bit and drop bash from Usage
Date: Thu, 28 Aug 2014 12:12:15 -0700
Message-Id: <1409253143-31466-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409253143-31466-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828191203.GA26955@linux.vnet.ibm.com>
 <1409253143-31466-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082819-1344-0000-0000-000003CABFBC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

This commit sets the executable bit on test scripts config2frag.sh
and kvm.sh.  Since #!/bin/bash is set in all the scripts, this commit
also drops it from all usage lines because the scripts can now all be
invoked directly.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/config2frag.sh      | 2 +-
 tools/testing/selftests/rcutorture/bin/configcheck.sh      | 2 +-
 tools/testing/selftests/rcutorture/bin/configinit.sh       | 2 +-
 tools/testing/selftests/rcutorture/bin/kvm-build.sh        | 2 +-
 tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh | 2 +-
 tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh  | 2 +-
 tools/testing/selftests/rcutorture/bin/kvm-recheck.sh      | 2 +-
 tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh   | 2 +-
 tools/testing/selftests/rcutorture/bin/kvm.sh              | 2 +-
 tools/testing/selftests/rcutorture/bin/parse-build.sh      | 3 +--
 tools/testing/selftests/rcutorture/bin/parse-console.sh    | 3 +--
 tools/testing/selftests/rcutorture/bin/parse-torture.sh    | 3 +--
 12 files changed, 12 insertions(+), 15 deletions(-)
 mode change 100644 => 100755 tools/testing/selftests/rcutorture/bin/config2frag.sh
 mode change 100644 => 100755 tools/testing/selftests/rcutorture/bin/kvm.sh

diff --git a/tools/testing/selftests/rcutorture/bin/config2frag.sh b/tools/testing/selftests/rcutorture/bin/config2frag.sh
old mode 100644
new mode 100755
index 4e394efe3c92..56f51ae13d73
--- a/tools/testing/selftests/rcutorture/bin/config2frag.sh
+++ b/tools/testing/selftests/rcutorture/bin/config2frag.sh
@@ -1,5 +1,5 @@
 #!/bin/bash
-# Usage: bash config2frag.sh < .config > configfrag
+# Usage: config2frag.sh < .config > configfrag
 #
 # Converts the "# CONFIG_XXX is not set" to "CONFIG_XXX=n" so that the
 # resulting file becomes a legitimate Kconfig fragment.
diff --git a/tools/testing/selftests/rcutorture/bin/configcheck.sh b/tools/testing/selftests/rcutorture/bin/configcheck.sh
index 6173ed5ec684..eee31e261bf7 100755
--- a/tools/testing/selftests/rcutorture/bin/configcheck.sh
+++ b/tools/testing/selftests/rcutorture/bin/configcheck.sh
@@ -1,5 +1,5 @@
 #!/bin/bash
-# Usage: bash configcheck.sh .config .config-template
+# Usage: configcheck.sh .config .config-template
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
diff --git a/tools/testing/selftests/rcutorture/bin/configinit.sh b/tools/testing/selftests/rcutorture/bin/configinit.sh
index d8f74185be02..15f1a17ca96e 100755
--- a/tools/testing/selftests/rcutorture/bin/configinit.sh
+++ b/tools/testing/selftests/rcutorture/bin/configinit.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 #
-# bash configinit.sh config-spec-file [ build output dir ]
+# Usage: configinit.sh config-spec-file [ build output dir ]
 #
 # Create a .config file from the spec file.  Run from the kernel source tree.
 # Exits with 0 if all went well, with 1 if all went well but the config
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-build.sh b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
index e4bfb91abee5..00cb0db2643d 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-build.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
@@ -2,7 +2,7 @@
 #
 # Build a kvm-ready Linux kernel from the tree in the current directory.
 #
-# Usage: bash kvm-build.sh config-template build-dir more-configs
+# Usage: kvm-build.sh config-template build-dir more-configs
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
index 30cbb63e2c3f..43f764098e50 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
@@ -2,7 +2,7 @@
 #
 # Analyze a given results directory for locktorture progress.
 #
-# Usage: bash kvm-recheck-lock.sh resdir
+# Usage: kvm-recheck-lock.sh resdir
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
index 6e94a5e4605d..d6cc07fc137f 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
@@ -2,7 +2,7 @@
 #
 # Analyze a given results directory for rcutorture progress.
 #
-# Usage: bash kvm-recheck-rcu.sh resdir
+# Usage: kvm-recheck-rcu.sh resdir
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
index 3482b3fc34e9..4f5b20f367a9 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
@@ -4,7 +4,7 @@
 # check the build and console output for errors.  Given a directory
 # containing results directories, this recursively checks them all.
 #
-# Usage: bash kvm-recheck.sh resdir ...
+# Usage: kvm-recheck.sh resdir ...
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index 5c265da529f6..6d2f5fa48484 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -6,7 +6,7 @@
 # Execute this in the source tree.  Do not run it as a background task
 # because qemu does not seem to like that much.
 #
-# Usage: bash kvm-test-1-run.sh config builddir resdir minutes qemu-args boot_args
+# Usage: kvm-test-1-run.sh config builddir resdir minutes qemu-args boot_args
 #
 # qemu-args defaults to "-nographic", along with arguments specifying the
 #			number of CPUs and other options generated from
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
old mode 100644
new mode 100755
index ff147ade194f..36534f9938ca
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -7,7 +7,7 @@
 # Edit the definitions below to set the locations of the various directories,
 # as well as the test duration.
 #
-# Usage: bash kvm.sh [ options ]
+# Usage: kvm.sh [ options ]
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
diff --git a/tools/testing/selftests/rcutorture/bin/parse-build.sh b/tools/testing/selftests/rcutorture/bin/parse-build.sh
index 41eeeefd8a5c..499d1e598e42 100755
--- a/tools/testing/selftests/rcutorture/bin/parse-build.sh
+++ b/tools/testing/selftests/rcutorture/bin/parse-build.sh
@@ -6,8 +6,7 @@
 #
 # The file must contain kernel build output.
 #
-# Usage:
-#	bash parse-build.sh file title
+# Usage: parse-build.sh file title
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
diff --git a/tools/testing/selftests/rcutorture/bin/parse-console.sh b/tools/testing/selftests/rcutorture/bin/parse-console.sh
index 2517eaed8991..a0bde6c79456 100755
--- a/tools/testing/selftests/rcutorture/bin/parse-console.sh
+++ b/tools/testing/selftests/rcutorture/bin/parse-console.sh
@@ -4,8 +4,7 @@
 # The "file" is a pathname on the local system, and "title" is
 # a text string for error-message purposes.
 #
-# Usage:
-#	bash parse-console.sh file title
+# Usage: parse-console.sh file title
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
diff --git a/tools/testing/selftests/rcutorture/bin/parse-torture.sh b/tools/testing/selftests/rcutorture/bin/parse-torture.sh
index bbec40b487e9..e3c5f0705696 100755
--- a/tools/testing/selftests/rcutorture/bin/parse-torture.sh
+++ b/tools/testing/selftests/rcutorture/bin/parse-torture.sh
@@ -7,8 +7,7 @@
 # The file must contain torture output, but can be interspersed
 # with other dmesg text, as in console-log output.
 #
-# Usage:
-#	bash parse-torture.sh file title
+# Usage: parse-torture.sh file title
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
-- 
1.8.1.5

