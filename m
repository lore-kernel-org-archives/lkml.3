Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab3ARRsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:48:13 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55583 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab3ARRsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:48:11 -0500
Date: Fri, 18 Jan 2013 09:46:54 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Anton Blanchard <anton@au1.ibm.com>, robert.richter@amd.com,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH 6/6][v3] perf: Document the ABI of perf sysfs entries
Message-ID: <20130118174654.GA12575@us.ibm.com>
References: <20130110010347.GA32590@us.ibm.com>
 <20130110010703.GF32590@us.ibm.com>
 <20130115185759.GG5826@ghostprotocols.net>
 <20130116113013.GA1042@krava.brq.redhat.com>
 <20130116185815.GA3351@us.ibm.com>
 <20130117141145.GA3817@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130117141145.GA3817@krava.brq.redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011817-7182-0000-0000-0000048BDDF2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa [jolsa@redhat.com] wrote:
| Maybe it'd worth to mention, that it does not need to be just 'event',
| but anything from /sys/bus/event_source/devices/<dev>/format directory,
| like
| 
| 		The can be multiple terms like 'event=0xNNNN' specified
| 		and separated with comma. All available terms are located
| 		in /sys/bus/event_source/devices/<dev>/format file.
| 
| Please feel free to rephrase or use proper English ;-)
| 
| otherwise it's ok,
| jirka

Agree.  Thanks for the review. Here is the updated patch.

---
>From 1e3cc6b3ef87f533985b10574af472361e39eecd Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Tue, 8 Jan 2013 22:31:49 -0800
Subject: [PATCH] perf: Document the ABI of perf sysfs entries

This patchset addes two new sets of files to sysfs for POWER architecture.

	- perf event config format in /sys/devices/cpu/format/event
	- generic and POWER-specific perf events in /sys/devices/cpu/events/

The format of the first file is already documented in:

	sysfs-bus-event_source-devices-format

Document the format of the second set of files '/sys/devices/cpu/events/*'
which would also become part of the ABI.

Changelog[v3.2]: (small changes to this one patch).
	[Jiri Olsa]: Mention that multiple event= like terms can be specified
	in the 'events' file.

Changelog[v3.1]:
	(small changes to just this one patch).
	[Jiri Olsa]: Remove the documentation for the 'config format' file
	as it is already documented in 'Documentation/ABI/testing/'.
	[Jiri Olsa]: Move the documentation of 'events' also to 'testing'
	from 'stable'.

Changelog[v3]:
	[Greg KH] Include ABI documentation.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 .../testing/sysfs-bus-event_source-devices-events  |   62 ++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)
 delete mode 100644 Documentation/ABI/stable/sysfs-devices-cpu-events
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-events

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
-- 
1.7.1


