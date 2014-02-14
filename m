Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaBNWEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 17:04:00 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57709 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbaBNWD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 17:03:57 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>, linux-doc@vger.kernel.org,
        Rob Landley <rob@landley.net>
Subject: [PATCH v2 11/11] powerpc/perf/hv_{gpci,24x7}: add documentation of device attributes
Date: Fri, 14 Feb 2014 14:02:15 -0800
Message-Id: <1392415338-16288-12-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.4
In-Reply-To: <1392415338-16288-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1392415338-16288-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021422-5806-0000-0000-00002423AF7D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpci and 24x7 expose some device specific attributes. Add some
documentation for them.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 .../testing/sysfs-bus-event_source-devices-hv_24x7 | 22 +++++++++++
 .../testing/sysfs-bus-event_source-devices-hv_gpci | 43 ++++++++++++++++++++++
 2 files changed, 65 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_gpci

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7 b/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
new file mode 100644
index 0000000..13474d3
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
@@ -0,0 +1,22 @@
+What:		/sys/bus/event_source/devices/hv_24x7/interface/catalog
+Date:		February 2014
+Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Description:
+		Provides access to the binary "24x7 catalog" provided by the
+		hypervisor on POWER7 and 8 systems. This catalog lists events
+		avaliable from the powerpc "hv_24x7" pmu. Its format is
+		documented in arch/powerpc/perf/hv_24x7.h.
+
+What:		/sys/bus/event_source/devices/hv_24x7/interface/catalog_length
+Date:		February 2014
+Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Description:
+		A number equal to the length in bytes of the catalog. This is
+		also extractable from the provided binary "catalog" sysfs entry.
+
+What:		/sys/bus/event_source/devices/hv_24x7/interface/catalog_version
+Date:		February 2014
+Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Description:
+		Exposes the "version" field of the 24x7 catalog. This is also
+		extractable from the provided binary "catalog" sysfs entry.
diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_gpci b/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_gpci
new file mode 100644
index 0000000..3fa58c2
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_gpci
@@ -0,0 +1,43 @@
+What:		/sys/bus/event_source/devices/hv_gpci/interface/collect_privileged
+Date:		February 2014
+Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Description:
+		'0' if the hypervisor is configured to forbid access to event
+		counters being accumulated by other guests and to physical
+		domain event counters.
+		'1' if that access is allowed.
+
+What:		/sys/bus/event_source/devices/hv_gpci/interface/ga
+Date:		February 2014
+Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Description:
+		0 or 1. Indicates whether we have access to "GA" events (listed
+		in arch/powerpc/perf/hv-gpci.h).
+
+What:		/sys/bus/event_source/devices/hv_gpci/interface/expanded
+Date:		February 2014
+Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Description:
+		0 or 1. Indicates whether we have access to "EXPANDED" events (listed
+		in arch/powerpc/perf/hv-gpci.h).
+
+What:		/sys/bus/event_source/devices/hv_gpci/interface/lab
+Date:		February 2014
+Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Description:
+		0 or 1. Indicates whether we have access to "LAB" events (listed
+		in arch/powerpc/perf/hv-gpci.h).
+
+What:		/sys/bus/event_source/devices/hv_gpci/interface/version
+Date:		February 2014
+Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Description:
+		A number indicating the version of the gpci interface that the
+		hypervisor reports supporting.
+
+What:		/sys/bus/event_source/devices/hv_gpci/interface/kernel_version
+Date:		February 2014
+Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Description:
+		A number indicating the latest version of the gpci interface
+		that the kernel is aware of.
-- 
1.8.5.4

