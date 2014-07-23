Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbaGWFLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:11:18 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:62709 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458AbaGWFLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:11:14 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:RCUTORTURE TEST F...)
Subject: [PATCH 16/16] rcu: kvm.sh: Fix error when you pass --cpus argument
Date: Wed, 23 Jul 2014 01:09:53 -0400
Message-Id: <1406092194-13004-17-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When you pass --cpus argument to kvm.sh, it errors out as it assumes you have
all the requires CPUs to run a batch. This commit fixes this along with a minor
comment fix.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 36534f9..1128d85 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -214,7 +214,7 @@ END {
 	batch = 0;
 	nc = -1;
 
-	# Each pass through the following loop creates on test batch
+	# Each pass through the following loop creates one test batch
 	# that can be executed concurrently given ncpus.  Note that a
 	# given test that requires more than the available CPUs will run in
 	# their own batch.  Such tests just have to make do with what
@@ -228,7 +228,7 @@ END {
 		for (i = 0; i < njobs; i++) {
 			if (done[i])
 				continue; # Already part of a batch.
-			if (nc >= cpus[i] || nc == ncpus) {
+			if (nc >= cpus[i]) {
 
 				# This test fits into the current batch.
 				done[i] = batch;
-- 
2.0.0.rc2

