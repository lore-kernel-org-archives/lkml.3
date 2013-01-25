Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab3AYRnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:43:22 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55654 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab3AYRnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:43:20 -0500
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Andi Kleen <ak@linux.intel.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH] x86, perf_event: Fix build warning
Date: Fri, 25 Jan 2013 18:46:07 +0100
Message-Id: <1359135967-31401-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Fix this one:

arch/x86/kernel/cpu/perf_event.c: In function ‘init_hw_perf_events’:
arch/x86/kernel/cpu/perf_event.c:1508:7: warning: assignment from incompatible
pointer type [enabled by default]
arch/x86/kernel/cpu/perf_event.c:1510:31: warning: assignment from incompatible
pointer type [enabled by default]

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1e2519d0dc7a..c6ef37af76b0 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1503,7 +1503,7 @@ static int __init init_hw_perf_events(void)
 		filter_events(x86_pmu_events_group.attrs);
 
 	if (x86_pmu.cpu_events) {
-		struct attribute *tmp;
+		struct attribute **tmp;
 
 		tmp = merge_attr(x86_pmu_events_group.attrs, x86_pmu.cpu_events);
 		if (!WARN_ON(!tmp))
-- 
1.8.1.rc3

