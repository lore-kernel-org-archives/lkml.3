Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161006Ab3BALEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 06:04:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52315 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030202Ab3BALEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 06:04:35 -0500
Date: Fri, 1 Feb 2013 03:04:11 -0800
From: tip-bot for Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Message-ID: <tip-2ac3634a7e1c8eedc961030c87c5c36ebd5bbf8e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, robert.richter@amd.com,
        anton@au1.ibm.com, ak@linux.intel.com, tglx@linutronix.de,
        sukadev@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, robert.richter@amd.com,
        anton@au1.ibm.com, ak@linux.intel.com, sukadev@linux.vnet.ibm.com,
        tglx@linutronix.de
In-Reply-To: <20130123062645.GG13720@us.ibm.com>
References: <20130123062645.GG13720@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Document the ABI of perf sysfs entries
Git-Commit-ID: 2ac3634a7e1c8eedc961030c87c5c36ebd5bbf8e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 01 Feb 2013 03:04:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ac3634a7e1c8eedc961030c87c5c36ebd5bbf8e
Gitweb:     http://git.kernel.org/tip/2ac3634a7e1c8eedc961030c87c5c36ebd5bbf8e
Author:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
AuthorDate: Tue, 22 Jan 2013 22:26:45 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jan 2013 13:07:51 -0300

perf: Document the ABI of perf sysfs entries

This patchset addes two new sets of files to sysfs for POWER architecture.

	- perf event config format in /sys/devices/cpu/format/event
	- generic and POWER-specific perf events in /sys/devices/cpu/events/

The format of the first file is already documented in:

	sysfs-bus-event_source-devices-format

Document the format of the second set of files '/sys/devices/cpu/events/*'
which would also become part of the ABI.

Changelog[v4]:
	[Jiri Olsa]: Mention that multiple event= like terms can be specified
	in the 'events' file.
	[Jiri Olsa]: Remove the documentation for the 'config format' file
	as it is already documented in 'Documentation/ABI/testing/'.
	[Jiri Olsa]: Move ABI documentation from 'stable/' to 'testing/'

Changelog[v3]:
	[Greg KH] Include ABI documentation.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: linuxppc-dev@ozlabs.org
Link: http://lkml.kernel.org/r/20130123062645.GG13720@us.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../testing/sysfs-bus-event_source-devices-events  | 62 ++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-devices-cpu-events b/Documentation/ABI/stable/sysfs-devices-cpu-events
deleted file mode 100644
index e69de29..0000000
diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
new file mode 100644
index 0000000..0adeb52
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
@@ -0,0 +1,62 @@
+What:		/sys/devices/cpu/events/
+		/sys/devices/cpu/events/branch-misses
+		/sys/devices/cpu/events/cache-references
+		/sys/devices/cpu/events/cache-misses
+		/sys/devices/cpu/events/stalled-cycles-frontend
+		/sys/devices/cpu/events/branch-instructions
+		/sys/devices/cpu/events/stalled-cycles-backend
+		/sys/devices/cpu/events/instructions
+		/sys/devices/cpu/events/cpu-cycles
+
+Date:		2013/01/08
+
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+
+Description:	Generic performance monitoring events
+
+		A collection of performance monitoring events that may be
+		supported by many/most CPUs. These events can be monitored
+		using the 'perf(1)' tool.
+
+		The contents of each file would look like:
+
+			event=0xNNNN
+
+		where 'N' is a hex digit and the number '0xNNNN' shows the
+		"raw code" for the perf event identified by the file's
+		"basename".
+
+
+What: 		/sys/devices/cpu/events/PM_LD_MISS_L1
+		/sys/devices/cpu/events/PM_LD_REF_L1
+		/sys/devices/cpu/events/PM_CYC
+		/sys/devices/cpu/events/PM_BRU_FIN
+		/sys/devices/cpu/events/PM_GCT_NOSLOT_CYC
+		/sys/devices/cpu/events/PM_BRU_MPRED
+		/sys/devices/cpu/events/PM_INST_CMPL
+		/sys/devices/cpu/events/PM_CMPLU_STALL
+
+Date:		2013/01/08
+
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+		Linux Powerpc mailing list <linuxppc-dev@ozlabs.org>
+
+Description:	POWER-systems specific performance monitoring events
+
+		A collection of performance monitoring events that may be
+		supported by the POWER CPU. These events can be monitored
+		using the 'perf(1)' tool.
+
+		These events may not be supported by other CPUs.
+
+		The contents of each file would look like:
+
+			event=0xNNNN
+
+		where 'N' is a hex digit and the number '0xNNNN' shows the
+		"raw code" for the perf event identified by the file's
+		"basename".
+
+		Further, multiple terms like 'event=0xNNNN' can be specified
+		and separated with comma. All available terms are defined in
+		the /sys/bus/event_source/devices/<dev>/format file.
