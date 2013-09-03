Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab3ICNh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:37:57 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:65211 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609Ab3ICNh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:37:56 -0400
Date: Tue, 3 Sep 2013 15:37:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fix
Message-ID: <20130903133752.GA27030@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: ae23bff1d71f8b416ed740bc458df67355c77c92 perf: Prevent race in unthrottling code

This is a leftover fix from the v3.11 cycle.

 Thanks,

	Ingo

------------------>
Jiri Olsa (1):
      perf: Prevent race in unthrottling code


 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f86599e..258eaaf 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2712,7 +2712,7 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
 
 		hwc = &event->hw;
 
-		if (needs_unthr && hwc->interrupts == MAX_INTERRUPTS) {
+		if (hwc->interrupts == MAX_INTERRUPTS) {
 			hwc->interrupts = 0;
 			perf_log_throttle(event, 1);
 			event->pmu->start(event, 0);
