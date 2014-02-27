Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaB0LfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:35:07 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:54665 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaB0LfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:35:05 -0500
Date: Thu, 27 Feb 2014 17:02:48 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        josh@joshtriplett.org
Subject: [PATCH 08/46] kernel: MOve prototype declaration to header file
 include/linux/perf_event.h
Message-ID: <137eb91c7ce020384a1fb967c1c8b7eaeded21d8.1393493276.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prototype declaration of function to header file
include/linux/perf_event.h because it is used by more than one file.

This eliminates the following warning in kernel/events/core.c:
kernel/events/core.c:3743:13: warning: no previous prototype for ‘arch_perf_update_userpage’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/perf_event.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e56b07f..b9e1673 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -526,6 +526,8 @@ struct perf_output_handle {
 	int				page;
 };
 
+void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now);
+
 #ifdef CONFIG_PERF_EVENTS
 
 extern int perf_pmu_register(struct pmu *pmu, const char *name, int type);
-- 
1.7.9.5

