Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3KPAgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:36:12 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:58256 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab3KPAfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:35:50 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH tip/core/rcu 02/28] rcutorture: Add datestamp argument to kvm.sh
Date: Fri, 15 Nov 2013 16:35:15 -0800
Message-Id: <1384562141-32446-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-6688-0000-0000-0000038DDF20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Allow datestamp to be specified to allow tests to be broken up and run
in parallel.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 46c75ee2f528..9fcceed81079 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -50,11 +50,13 @@ configs=" sysidleY.2013.06.19a \
 	  PT2-NH \
 	  NT1-nh \
 	  NT3-NH"
+ds=`date +%Y.%m.%d-%H:%M:%S`
 
 usage () {
 	echo "Usage: $scriptname optional arguments:"
 	echo "       --builddir absolute-pathname"
 	echo "       --configs \"config-file list\""
+	echo "       --datestamp string"
 	echo "       --duration minutes"
 	echo "       --rcu-kvm absolute-pathname"
 	echo "       --results absolute-pathname"
@@ -98,6 +100,11 @@ do
 		configs="$2"
 		shift
 		;;
+	--datestamp)
+		checkarg --datestamp "(relative pathname)" "$#" "$2" '^[^/]*$' '^--'
+		ds=$2
+		shift
+		;;
 	--duration)
 		checkarg --duration "(minutes)" $# "$2" '^[0-9]*$' error
 		dur=$2
@@ -147,13 +154,12 @@ if test -z "$resdir"
 then
 	resdir=$KVM/res
 	mkdir $resdir || :
-	ds=`date +%Y.%m.%d-%H:%M:%S`
-	mkdir $resdir/$ds
-	echo Datestamp: $ds
 else
-	mkdir -p "$resdir"
-	ds=""
+	mkdir -p "$resdir" || :
 fi
+mkdir $resdir/$ds
+echo Datestamp: $ds
+
 pwd > $resdir/$ds/testid.txt
 if test -d .git
 then
-- 
1.8.1.5

