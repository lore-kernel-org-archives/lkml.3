Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbaCFAqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:46:51 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:48552 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746AbaCFAp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:45:27 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: linux-doc@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, rob@landley.net
Subject: [PATCH 2/2] perf Documentation: remove duplicated docs for powerpc cpu specific events
Date: Wed,  5 Mar 2014 16:44:15 -0800
Message-Id: <1394066658-16766-3-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394066658-16766-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1394066658-16766-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030600-9332-0000-0000-00000006DE29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Listing specific events doesn't actually help us at all here because:
 - these events actually vary between different ppc processors, they
   aren't garunteed to be present.
 - the documentation of the file contents is now duplicated by the
   docs for arbitrary event file contents.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 .../testing/sysfs-bus-event_source-devices-events  | 57 ----------------------
 1 file changed, 57 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
index 5393e1ed6..50c30a6 100644
--- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
@@ -26,63 +26,6 @@ Description:	Generic performance monitoring events
 		"raw code" for the perf event identified by the file's
 		"basename".
 
-
-What: 		/sys/devices/cpu/events/PM_1PLUS_PPC_CMPL
-		/sys/devices/cpu/events/PM_BRU_FIN
-		/sys/devices/cpu/events/PM_BR_MPRED
-		/sys/devices/cpu/events/PM_CMPLU_STALL
-		/sys/devices/cpu/events/PM_CMPLU_STALL_BRU
-		/sys/devices/cpu/events/PM_CMPLU_STALL_DCACHE_MISS
-		/sys/devices/cpu/events/PM_CMPLU_STALL_DFU
-		/sys/devices/cpu/events/PM_CMPLU_STALL_DIV
-		/sys/devices/cpu/events/PM_CMPLU_STALL_ERAT_MISS
-		/sys/devices/cpu/events/PM_CMPLU_STALL_FXU
-		/sys/devices/cpu/events/PM_CMPLU_STALL_IFU
-		/sys/devices/cpu/events/PM_CMPLU_STALL_LSU
-		/sys/devices/cpu/events/PM_CMPLU_STALL_REJECT
-		/sys/devices/cpu/events/PM_CMPLU_STALL_SCALAR
-		/sys/devices/cpu/events/PM_CMPLU_STALL_SCALAR_LONG
-		/sys/devices/cpu/events/PM_CMPLU_STALL_STORE
-		/sys/devices/cpu/events/PM_CMPLU_STALL_THRD
-		/sys/devices/cpu/events/PM_CMPLU_STALL_VECTOR
-		/sys/devices/cpu/events/PM_CMPLU_STALL_VECTOR_LONG
-		/sys/devices/cpu/events/PM_CYC
-		/sys/devices/cpu/events/PM_GCT_NOSLOT_BR_MPRED
-		/sys/devices/cpu/events/PM_GCT_NOSLOT_BR_MPRED_IC_MISS
-		/sys/devices/cpu/events/PM_GCT_NOSLOT_CYC
-		/sys/devices/cpu/events/PM_GCT_NOSLOT_IC_MISS
-		/sys/devices/cpu/events/PM_GRP_CMPL
-		/sys/devices/cpu/events/PM_INST_CMPL
-		/sys/devices/cpu/events/PM_LD_MISS_L1
-		/sys/devices/cpu/events/PM_LD_REF_L1
-		/sys/devices/cpu/events/PM_RUN_CYC
-		/sys/devices/cpu/events/PM_RUN_INST_CMPL
-
-Date:		2013/01/08
-
-Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
-		Linux Powerpc mailing list <linuxppc-dev@ozlabs.org>
-
-Description:	POWER-systems specific performance monitoring events
-
-		A collection of performance monitoring events that may be
-		supported by the POWER CPU. These events can be monitored
-		using the 'perf(1)' tool.
-
-		These events may not be supported by other CPUs.
-
-		The contents of each file would look like:
-
-			event=0xNNNN
-
-		where 'N' is a hex digit and the number '0xNNNN' shows the
-		"raw code" for the perf event identified by the file's
-		"basename".
-
-		Further, multiple terms like 'event=0xNNNN' can be specified
-		and separated with comma. All available terms are defined in
-		the /sys/bus/event_source/devices/<dev>/format file.
-
 What: /sys/bus/event_source/devices/<pmu>/events/<event>
 Date: 2014/02/24
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
-- 
1.9.0

