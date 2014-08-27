Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826AbaH1DwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 23:52:19 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:36405 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbaH1DwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 23:52:18 -0400
Subject: [PATCH v4 3/3] perf/sdt : Documentation for SDT events
To: linux-kernel@vger.kernel.org
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Date: Thu, 28 Aug 2014 03:23:16 +0530
Message-ID: <20140827215120.13454.30680.stgit@hemant-fedora>
In-Reply-To: <20140827213745.13454.46266.stgit@hemant-fedora>
References: <20140827213745.13454.46266.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082803-0013-0000-0000-000000290A6F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds documentation for perf support to SDT events.

Signed-off-by : Hemant Kumar <hemant@linux.vnet.ibm.com>
---
 tools/perf/Documentation/SDT-support.txt |   48 ++++++++++++++++++++++++++++++
 tools/perf/Documentation/perf-list.txt   |    4 ++-
 2 files changed, 51 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/Documentation/SDT-support.txt

diff --git a/tools/perf/Documentation/SDT-support.txt b/tools/perf/Documentation/SDT-support.txt
new file mode 100644
index 0000000..273912b
--- /dev/null
+++ b/tools/perf/Documentation/SDT-support.txt
@@ -0,0 +1,48 @@
+Support to perf for listing the SDT markers :
+
+This helps in listing dtrace style markers(SDT) present in user space
+applications through perf. SDT Notes/markers are placed at important places by the
+developers. They have a negligible overhead when not enabled.
+We can enable them and probe at these places and find some important information
+like the arguments' values, etc.
+
+How to add SDT markers into user applications:
+We need to have this header sys/sdt.h present.
+sys/sdt.h used is version 3.
+If not present, install systemtap-sdt-devel package (for fedora-18).
+
+A very simple example:
+
+$ cat user_app.c
+
+#include <sys/sdt.h>
+
+void main () {
+       /* ... */
+       /*
+        * user_app is the provider name
+        * test_probe is the marker name
+        */
+       STAP_PROBE(user_app, test_mark);
+       /* ... */
+}
+
+$ gcc user_app.c
+$ perf list sdt ./a.out
+./a.out:
+%user_app:test_mark
+
+For more information on usage of SDT markers, visit the following link:
+http://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation
+
+This link shows an example of marker probing with Systemtap:
+https://sourceware.org/systemtap/wiki/AddingUserSpaceProbingToApps
+
+- Markers in binaries :
+These SDT markers are present in the ELF in the section named
+".note.stapsdt".
+This section contains the name of the marker, its provider, type, location, base
+address, semaphore address.
+We can retrieve these values using the members name_off and desc_off in
+Nhdr structure. If these markers are not enabled, they are present in the ELF in
+the form of a "nop" instruction.
diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 6fce6a6..5c72785 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -8,7 +8,7 @@ perf-list - List all symbolic event types
 SYNOPSIS
 --------
 [verse]
-'perf list' [hw|sw|cache|tracepoint|pmu|event_glob]
+'perf list' [hw|sw|cache|tracepoint|pmu|sdt|event_glob]
 
 DESCRIPTION
 -----------
@@ -108,6 +108,8 @@ To limit the list use:
 
 . 'pmu' to print the kernel supplied PMU events.
 
+. 'sdt' to print the SDT events present in a file. Takes a file_name as an argument.
+
 . If none of the above is matched, it will apply the supplied glob to all
   events, printing the ones that match.
 

