Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab3HJRvO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 13:51:14 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40483 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab3HJRvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 13:51:13 -0400
Date: Sat, 10 Aug 2013 10:50:43 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Stephane Eranian <eranian@google.com>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 3/7] powerpc/perf: Create mem-loads/mem-stores events for
 Power8
Message-ID: <20130810175042.GD15551@us.ibm.com>
References: <20130810174831.GA15551@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130810174831.GA15551@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081017-7282-0000-0000-00001A4A5533
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH 3/7] powerpc/perf: Create mem-loads/mem-stores events for Power8

'perf mem' command depends on the support for generic hardware events
'mem-loads' and 'mem-stores'.

Create those events for Power8 and map them both to the event PM_MRK_GRP_CMPL.
While PM_MRK_GRP_CMPL is strictly not restricted to loads and stores, that
seems to be a close/resonable match.

Cc: Stephane Eranian <eranian@google.com>
Cc: Paul Mckerras <paulus@samba.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/powerpc/perf/power8-pmu.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
index ff98fb8..0a7b632 100644
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -24,6 +24,8 @@
 #define PME_PM_INST_CMPL			0x00002
 #define PME_PM_BRU_FIN				0x10068
 #define PME_PM_BR_MPRED_CMPL			0x400f6
+#define PME_PM_MEM_LOADS			0x40130
+#define PME_PM_MEM_STORES			0x40130
 
 
 /*
@@ -516,6 +518,8 @@ GENERIC_EVENT_ATTR(stalled-cycles-backend,	PM_CMPLU_STALL);
 GENERIC_EVENT_ATTR(instructions,		PM_INST_CMPL);
 GENERIC_EVENT_ATTR(branch-instructions,		PM_BRU_FIN);
 GENERIC_EVENT_ATTR(branch-misses,		PM_BR_MPRED_CMPL);
+GENERIC_EVENT_ATTR(mem-loads,			PM_MEM_LOADS);
+GENERIC_EVENT_ATTR(mem-stores,			PM_MEM_STORES);
 
 static struct attribute *power8_events_attr[] = {
 	GENERIC_EVENT_PTR(PM_CYC),
@@ -524,6 +528,8 @@ static struct attribute *power8_events_attr[] = {
 	GENERIC_EVENT_PTR(PM_INST_CMPL),
 	GENERIC_EVENT_PTR(PM_BRU_FIN),
 	GENERIC_EVENT_PTR(PM_BR_MPRED_CMPL),
+	GENERIC_EVENT_PTR(PM_MEM_LOADS),
+	GENERIC_EVENT_PTR(PM_MEM_STORES),
 	NULL
 };
 
-- 
1.7.1

