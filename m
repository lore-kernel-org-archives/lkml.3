Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaIXTZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:25:18 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:53748 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaIXTZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:25:11 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        Jiri Olsa <jolsa@redhat.com>, peterz@infradead.org, eranian@google.com,
        Paul Mackerras <paulus@samba.org>
Cc: dev@codyps.com, Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>, hbabu@us.ibm.com,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 3/4] perf Documentation: sysfs events/ interfaces
Date: Wed, 24 Sep 2014 12:24:40 -0700
Message-Id: <1411586681-21262-4-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411586681-21262-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1411586681-21262-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092419-9332-0000-0000-000002202B12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

Add documentation for the <event>, <event>.scale, and <event>.unit
files in sysfs.

<event>.scale and <event>.unit were undocumented.
<event> was previously documented only for specific powerpc pmu events.

CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Haren Myneni <hbabu@us.ibm.com>
CC: Cody P Schafer <dev@codyps.com>
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
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
-- 
1.8.3.1

