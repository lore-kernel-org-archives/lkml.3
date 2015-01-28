Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbbA1Uuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:50:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbbA1Uua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:30 -0500
Date: Wed, 28 Jan 2015 07:05:55 -0800
From: tip-bot for Cody P Schafer <tipbot@zytor.com>
Message-ID: <tip-98a43e0e9917059da32db89829b0eb95453a11ee@git.kernel.org>
Cc: sukadev@linux.vnet.ibm.com, dev@codyps.com, peterz@infradead.org,
        mingo@kernel.org, acme@redhat.com, tglx@linutronix.de,
        jolsa@kernel.org, linux-kernel@vger.kernel.org, paulus@samba.org,
        mpe@ellerman.id.au, cody@linux.vnet.ibm.com, jolsa@redhat.com,
        hbabu@us.ibm.com, hpa@zytor.com
Reply-To: sukadev@linux.vnet.ibm.com, dev@codyps.com, peterz@infradead.org,
        mingo@kernel.org, tglx@linutronix.de, jolsa@kernel.org,
        acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mpe@ellerman.id.au, cody@linux.vnet.ibm.com, jolsa@redhat.com,
        hpa@zytor.com, hbabu@us.ibm.com
In-Reply-To: <1420679633-28856-4-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1420679633-28856-4-git-send-email-sukadev@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf Documentation: Add event parameters
Git-Commit-ID: 98a43e0e9917059da32db89829b0eb95453a11ee
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

Commit-ID:  98a43e0e9917059da32db89829b0eb95453a11ee
Gitweb:     http://git.kernel.org/tip/98a43e0e9917059da32db89829b0eb95453a11ee
Author:     Cody P Schafer <cody@linux.vnet.ibm.com>
AuthorDate: Wed, 7 Jan 2015 17:13:52 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 13:24:33 -0300

perf Documentation: Add event parameters

Event parameters are a basic way for partial events to be specified in
sysfs with per-event names given to the fields that need to be filled in
when using a particular event.

It is intended for supporting cases where the single 'cpu' parameter is
insufficient. For example, POWER 8 has events for physical
sockets/cores/cpus that are accessible from with virtual machines. To
keep using the single 'cpu' parameter we'd need to perform a mapping
between Linux's cpus and the physical machine's cpus (in this case Linux
is running under a hypervisor). This isn't possible because bindings
between our cpus and physical cpus may not be fixed, and we probably
won't have a "cpu" on each physical cpu.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Cody P Schafer <dev@codyps.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lkml.kernel.org/r/1420679633-28856-4-git-send-email-sukadev@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Documentation/ABI/testing/sysfs-bus-event_source-devices-events | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
index 20979f8..505f080 100644
--- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
@@ -52,12 +52,18 @@ Description:	Per-pmu performance monitoring events specific to the running syste
 			event=0x2abc
 			event=0x423,inv,cmask=0x3
 			domain=0x1,offset=0x8,starting_index=0xffff
+			domain=0x1,offset=0x8,core=?
 
 		Each of the assignments indicates a value to be assigned to a
 		particular set of bits (as defined by the format file
 		corresponding to the <term>) in the perf_event structure passed
 		to the perf_open syscall.
 
+		In the case of the last example, a value replacing "?" would
+		need to be provided by the user selecting the particular event.
+		This is referred to as "event parameterization". Event
+		parameters have the format 'param=?'.
+
 What: /sys/bus/event_source/devices/<pmu>/events/<event>.unit
 Date: 2014/02/24
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
