Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3JBAQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 20:16:06 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:50674 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab3JBAPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 20:15:34 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 9/9][v5] powerpc/perf: Update perf-mem man page for Power
Date: Tue,  1 Oct 2013 17:15:10 -0700
Message-Id: <1380672911-12812-10-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100200-1542-0000-0000-000001EAF77D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a few lines to the perf-mem man page to indicate:

	- its dependence on the mem-loads and mem-stores events

	- how to use the feature on Power architecture.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/Documentation/perf-mem.txt |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/perf/Documentation/perf-mem.txt b/tools/perf/Documentation/perf-mem.txt
index 888d511..f4881a0 100644
--- a/tools/perf/Documentation/perf-mem.txt
+++ b/tools/perf/Documentation/perf-mem.txt
@@ -18,6 +18,17 @@ from it, into perf.data. Perf record options are accepted and are passed through
 "perf mem -t <TYPE> report" displays the result. It invokes perf report with the
 right set of options to display a memory access profile.
 
+This command works on architectures that implement *mem-loads* and *mem-stores*
+perf events.
+
+The PowerPC architecture does not implement *mem-loads* and *mem-stores*
+events.  To get the memory hierarchy information for samples involving
+memory loads and stores, use a marked event like PM_MRK_GRP_CMPL.
+
+	perf record -d -e 'cpu/PM_MRK_GRP_CMPL/' <application>
+
+	perf report -n --mem-mode
+
 OPTIONS
 -------
 <command>...::
-- 
1.7.9.5

