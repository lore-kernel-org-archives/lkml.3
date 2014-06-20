Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967400AbaFTStl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:49:41 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57224 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966716AbaFTStX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:49:23 -0400
Subject: [Patch] tracing: tell mm_migrate_pages event about numa_misplaced
From: Max Asbock <masbock@linux.vnet.ibm.com>
Reply-To: masbock@linux.vnet.ibm.com
To: rostedt@goodmis.org, mingo@redhat.com, mgorman@suse.de,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Jun 2014 11:49:16 -0700
Message-ID: <1403290156.4484.10.camel@oc3432500282.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062018-1542-0000-0000-000002B6C050
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The mm_migrate_pages trace event reports a reason for the migration, typically as a
symbolic string. The exception is the reason MR_NUMA_MISPLACED for which it just displays
the numeric value:
mm_migrate_pages: nr_succeeded=1 nr_failed=0 mode=MIGRATE_ASYNC reason=0x5

This patch makes the output consistent by introducing a string value for MR_NUMA_MISPLACED.
The event is then reported as:
mm_migrate_pages: nr_succeeded=1 nr_failed=0 mode=MIGRATE_ASYNC reason=numa_misplaced

Signed-off-by: Max Asbock <masbock@linux.vnet.ibm.com>

 migrate.h |    1 +
 1 file changed, 1 insertion(+)


--- linux-3.16-rc1/include/trace/events/migrate.h.orig	2014-06-20 10:00:26.768410407 -0700
+++ linux-3.16-rc1/include/trace/events/migrate.h	2014-06-20 10:01:55.432410334 -0700
@@ -17,6 +17,7 @@
 	{MR_MEMORY_HOTPLUG,	"memory_hotplug"},		\
 	{MR_SYSCALL,		"syscall_or_cpuset"},		\
 	{MR_MEMPOLICY_MBIND,	"mempolicy_mbind"},		\
+	{MR_NUMA_MISPLACED,	"numa_misplaced"},		\
 	{MR_CMA,		"cma"}
 
 TRACE_EVENT(mm_migrate_pages,


