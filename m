Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084Ab3BHKGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 05:06:15 -0500
Received: from ozlabs.org ([203.10.76.45]:56380 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab3BHKGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 05:06:11 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] Documentation: Add a simple doc for selftests
Message-Id: <1360317764.684151.590003024082.1.gpush@pecola>
In-Reply-To: <20130207151333.f01d415c.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
From: Jeremy Kerr <jk@ozlabs.org>
Date: Fri, 08 Feb 2013 18:02:44 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/13 07:13, Andrew Morton wrote:

> The general ruleset for selftests is: do as much as you can if you're not
> root and don't take too long and don't break the build on any
> architecture and don't cause the top-level "make run_tests" to fail if
> your feature is unconfigured.

This change adds a little documentation to the tests under
tools/testing/selftests/, based on akpm's explanation.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>

---
 Documentation/selftests.txt |   43 ++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/Documentation/selftests.txt b/Documentation/selftests.txt
new file mode 100644
index 0000000..a00e477
--- /dev/null
+++ b/Documentation/selftests.txt
@@ -0,0 +1,43 @@
+Linux Kernel Selftests
+
+The kernel contains a set of "self tests" under the tools/testing/selftests/
+directory. These are intended to be small unit tests to exercise individual
+code paths in the kernel.
+
+Running the selftests
+=====================
+
+To build the tests:
+
+  $ make -C tools/testing/selftests
+
+
+To run the tests:
+
+  $ make -C tools/testing/selftests run_tests
+
+- note that some tests will require root privileges.
+
+
+To run only tests targetted for a single subsystem:
+
+  $  make -C tools/testing/selftests TARGETS=cpu-hotplug run_tests
+
+See the top-level tools/testing/selftests/Makefile for the list of all possible
+targets.
+
+
+Contributing new tests
+======================
+
+In general, the rules for for selftests are
+
+ * Do as much as you can if you're not root;
+
+ * Don't take too long;
+
+ * Don't break the build on any architecture, and
+
+ * Don't cause the top-level "make run_tests" to fail if your feature is
+   unconfigured.
+
