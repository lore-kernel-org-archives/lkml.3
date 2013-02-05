Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab3BEXTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 18:19:46 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57548 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756400Ab3BEXTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 18:19:45 -0500
Date: Tue, 5 Feb 2013 15:19:38 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: sfr@canb.auug.org.au, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: [PATCH] perf/powerpc: Fix compile warnings
Message-ID: <20130205231938.GA24125@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020523-9360-0000-0000-00001033C71C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Tue, 5 Feb 2013 15:04:49 -0800
Subject: [PATCH] perf/powerpc: Fix compile warnings

Fix compile errors like those below:

  CC      arch/powerpc/perf/power7-pmu.o
/home/git/linux/arch/powerpc/perf/power7-pmu.c:397:2: error: initialization from
incompatible pointer type [-Werror]

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/include/asm/perf_event_server.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index ee63205..92460bc 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -124,7 +124,7 @@ extern ssize_t power_events_sysfs_show(struct device *dev,
  * POWER CPU specification.
  */
 #define	EVENT_VAR(_id, _suffix)		event_attr_##_id##_suffix
-#define	EVENT_PTR(_id, _suffix)		&EVENT_VAR(_id, _suffix)
+#define	EVENT_PTR(_id, _suffix)		&EVENT_VAR(_id, _suffix).attr.attr
 
 #define	EVENT_ATTR(_name, _id, _suffix)					\
 	PMU_EVENT_ATTR(_name, EVENT_VAR(_id, _suffix), PME_PM_##_id,	\
-- 
1.7.1

