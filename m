Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab3BFNvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 08:51:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60566 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3BFNvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 08:51:46 -0500
Date: Wed, 6 Feb 2013 05:51:17 -0800
From: tip-bot for Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Message-ID: <tip-f2b4367a69c60c644a1df36f63a65e0e677d3b0f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        acme@ghostprotocols.net, sfr@canb.auug.org.au,
        sukadev@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, tglx@linutronix.de,
        sukadev@linux.vnet.ibm.com, sfr@canb.auug.org.au
In-Reply-To: <20130205231938.GA24125@us.ibm.com>
References: <20130205231938.GA24125@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/powerpc: Fix build error
Git-Commit-ID: f2b4367a69c60c644a1df36f63a65e0e677d3b0f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 05:51:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f2b4367a69c60c644a1df36f63a65e0e677d3b0f
Gitweb:     http://git.kernel.org/tip/f2b4367a69c60c644a1df36f63a65e0e677d3b0f
Author:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
AuthorDate: Tue, 5 Feb 2013 15:04:49 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Feb 2013 12:07:21 +0100

perf/powerpc: Fix build error

Fix compile errors like those below:

  CC      arch/powerpc/perf/power7-pmu.o
   /home/git/linux/arch/powerpc/perf/power7-pmu.c:397:2: error: initialization from incompatible pointer type [-Werror]

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linuxppc-dev@ozlabs.org
Link: http://lkml.kernel.org/r/20130205231938.GA24125@us.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/powerpc/include/asm/perf_event_server.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index b29fcc6..136bba6 100644
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
