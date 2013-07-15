Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab3GOV4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:56:14 -0400
Received: from mail-gh0-f178.google.com ([209.85.160.178]:56895 "EHLO
	mail-gh0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab3GOV4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:56:12 -0400
Date: Mon, 15 Jul 2013 17:38:15 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Jiri Olsa <jolsa@redhat.com>, linux-perf-users@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        acme@redhat.com, Stephane Eranian <eranian@gmail.com>
Subject: perf documentation: update Documentation/ABI/testing with missing
 perf-related files
Message-ID: <alpine.DEB.2.10.1307151736250.6555@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add documentation for various files perf_event creates under
/sys/bus/event_source/devices/<dev>/

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices b/Documentation/ABI/testing/sysfs-bus-event_source-devices
new file mode 100644
index 0000000..ffa2e4b
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices
@@ -0,0 +1,50 @@
+What:		/sys/bus/event_source/devices/<dev>/cpumask
+
+Date:		2012/09/10
+		
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+
+Description:	This value holds a representative core for each
+		socket in a system.  It is meant to help when
+		creating a perf_event event for socket-wide events
+		like uncore and northbridge events.
+
+		The format is a comma separated list of cpu numbers,
+		one for each socket in the system that the PMU in
+		question can run on.
+
+		For example, on a two-socket Sandybridge-EP machine and
+		the cbox0 uncore the value of the file will be:
+			0,8
+		    
+
+
+What:		/sys/bus/event_source/devices/cpu/rdpmc
+
+Date:		2011/11/20
+
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+
+Description:	Indicates whether a CPU allows userspace "rdpmc"
+		instructions (unprivileged reads of the performance
+		counter MSRs).
+
+		You can echo 0 to this value to disable user rdpmc
+		access.
+
+
+
+What:		/sys/bus/event_source/devices/<dev>/type
+
+Date:		2013/01/08
+
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+
+Description:	This value holds the PMU (Performance Monitor Unit) type
+		value that is passed into the perf_event_open()
+		attr:type field when opening an event.
+
+		The value is a decimal integer.
+
+
+
