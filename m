Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab3AZB45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:56:57 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:50617 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab3AZB4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:56:55 -0500
Date: Fri, 25 Jan 2013 17:56:57 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Petr Holasek <pholasek@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Greg KH <gregkh@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 2/11] ksm: add sysfs ABI Documentation
In-Reply-To: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils>
Message-ID: <alpine.LNX.2.00.1301251754580.29196@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petr Holasek <pholasek@redhat.com>

This patch adds sysfs documentation for Kernel Samepage Merging (KSM)
including new merge_across_nodes knob.

Signed-off-by: Petr Holasek <pholasek@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
---
 Documentation/ABI/testing/sysfs-kernel-mm-ksm |   52 ++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-mm-ksm

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ mmotm/Documentation/ABI/testing/sysfs-kernel-mm-ksm	2013-01-25 14:36:50.660205905 -0800
@@ -0,0 +1,52 @@
+What:		/sys/kernel/mm/ksm
+Date:		September 2009
+KernelVersion:	2.6.32
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Interface for Kernel Samepage Merging (KSM)
+
+What:		/sys/kernel/mm/ksm/full_scans
+What:		/sys/kernel/mm/ksm/pages_shared
+What:		/sys/kernel/mm/ksm/pages_sharing
+What:		/sys/kernel/mm/ksm/pages_to_scan
+What:		/sys/kernel/mm/ksm/pages_unshared
+What:		/sys/kernel/mm/ksm/pages_volatile
+What:		/sys/kernel/mm/ksm/run
+What:		/sys/kernel/mm/ksm/sleep_millisecs
+Date:		September 2009
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Kernel Samepage Merging daemon sysfs interface
+
+		full_scans: how many times all mergeable areas have been
+		scanned.
+
+		pages_shared: how many shared pages are being used.
+
+		pages_sharing: how many more sites are sharing them i.e. how
+		much saved.
+
+		pages_to_scan: how many present pages to scan before ksmd goes
+		to sleep.
+
+		pages_unshared: how many pages unique but repeatedly checked
+		for merging.
+
+		pages_volatile: how many pages changing too fast to be placed
+		in a tree.
+
+		run: write 0 to disable ksm, read 0 while ksm is disabled.
+			write 1 to run ksm, read 1 while ksm is running.
+			write 2 to disable ksm and unmerge all its pages.
+
+		sleep_millisecs: how many milliseconds ksm should sleep between
+		scans.
+
+		See Documentation/vm/ksm.txt for more information.
+
+What:		/sys/kernel/mm/ksm/merge_across_nodes
+Date:		January 2013
+KernelVersion:	3.9
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Control merging pages across different NUMA nodes.
+
+		When it is set to 0 only pages from the same node are merged,
+		otherwise pages from all nodes can be merged together (default).
