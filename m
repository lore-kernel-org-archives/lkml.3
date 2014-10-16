Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbaJPFXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:23:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33516 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaJPFXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:23:48 -0400
Date: Wed, 15 Oct 2014 22:21:51 -0700
From: tip-bot for Cody P Schafer <tipbot@zytor.com>
Message-ID: <tip-ed90a4466340e51699139ea83dbe0f4536360e6d@git.kernel.org>
Cc: jolsa@redhat.com, sukadev@linux.vnet.ibm.com, acme@redhat.com,
        hpa@zytor.com, michaele@au1.ibm.com, mingo@kernel.org,
        khandual@linux.vnet.ibm.com, tglx@linutronix.de, hbabu@us.ibm.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, dev@codyps.com,
        ak@linux.intel.com, eranian@google.com, paulus@samba.org
Reply-To: linux-kernel@vger.kernel.org, peterz@infradead.org, dev@codyps.com,
        ak@linux.intel.com, paulus@samba.org, eranian@google.com,
        sukadev@linux.vnet.ibm.com, hpa@zytor.com, acme@redhat.com,
        jolsa@redhat.com, mingo@kernel.org, michaele@au1.ibm.com,
        khandual@linux.vnet.ibm.com, tglx@linutronix.de, hbabu@us.ibm.com
In-Reply-To: <1412143402-26061-4-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1412143402-26061-4-git-send-email-sukadev@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf Documentation: sysfs events/ interfaces
Git-Commit-ID: ed90a4466340e51699139ea83dbe0f4536360e6d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed90a4466340e51699139ea83dbe0f4536360e6d
Gitweb:     http://git.kernel.org/tip/ed90a4466340e51699139ea83dbe0f4536360e6d
Author:     Cody P Schafer <dev@codyps.com>
AuthorDate: Tue, 30 Sep 2014 23:03:19 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Oct 2014 15:54:40 -0300

perf Documentation: sysfs events/ interfaces

Add documentation for the <event>, <event>.scale, and <event>.unit
files in sysfs.

	<event>.scale and <event>.unit were undocumented.
	<event> was previously documented only for specific powerpc pmu events.

Signed-off-by: Cody P Schafer <dev@codyps.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Cody P Schafer <dev@codyps.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Michael Ellerman <michaele@au1.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lkml.kernel.org/r/1412143402-26061-4-git-send-email-sukadev@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../testing/sysfs-bus-event_source-devices-events  | 60 ++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
index 7b40a3c..a5226f0 100644
--- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
@@ -599,3 +599,63 @@ Description:	POWER-systems specific performance monitoring events
 		Further, multiple terms like 'event=0xNNNN' can be specified
 		and separated with comma. All available terms are defined in
 		the /sys/bus/event_source/devices/<dev>/format file.
+
+What: /sys/bus/event_source/devices/<pmu>/events/<event>
+Date: 2014/02/24
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Per-pmu performance monitoring events specific to the running system
+
+		Each file (except for some of those with a '.' in them, '.unit'
+		and '.scale') in the 'events' directory describes a single
+		performance monitoring event supported by the <pmu>. The name
+		of the file is the name of the event.
+
+		File contents:
+
+			<term>[=<value>][,<term>[=<value>]]...
+
+		Where <term> is one of the terms listed under
+		/sys/bus/event_source/devices/<pmu>/format/ and <value> is
+		a number is base-16 format with a '0x' prefix (lowercase only).
+		If a <term> is specified alone (without an assigned value), it
+		is implied that 0x1 is assigned to that <term>.
+
+		Examples (each of these lines would be in a seperate file):
+
+			event=0x2abc
+			event=0x423,inv,cmask=0x3
+			domain=0x1,offset=0x8,starting_index=0xffff
+
+		Each of the assignments indicates a value to be assigned to a
+		particular set of bits (as defined by the format file
+		corresponding to the <term>) in the perf_event structure passed
+		to the perf_open syscall.
+
+What: /sys/bus/event_source/devices/<pmu>/events/<event>.unit
+Date: 2014/02/24
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Perf event units
+
+		A string specifying the English plural numerical unit that <event>
+		(once multiplied by <event>.scale) represents.
+
+		Example:
+
+			Joules
+
+What: /sys/bus/event_source/devices/<pmu>/events/<event>.scale
+Date: 2014/02/24
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Perf event scaling factors
+
+		A string representing a floating point value expressed in
+		scientific notation to be multiplied by the event count
+		recieved from the kernel to match the unit specified in the
+		<event>.unit file.
+
+		Example:
+
+			2.3283064365386962890625e-10
+
+		This is provided to avoid performing floating point arithmetic
+		in the kernel.
