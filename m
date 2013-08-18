Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab3HRI3V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 04:29:21 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:47582 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755078Ab3HRI3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 04:29:19 -0400
From: Lei Wen <leiwen@marvell.com>
To: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/8] sched: document the difference between nr_running and h_nr_running
Date: Sun, 18 Aug 2013 16:25:22 +0800
Message-ID: <1376814322-7320-9-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376814322-7320-1-git-send-email-leiwen@marvell.com>
References: <1376814322-7320-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/sched/sched.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ef0a7b2..b8f0924 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -248,6 +248,12 @@ struct cfs_bandwidth { };
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
 	struct load_weight load;
+	/*
+	 * The difference between nr_running and h_nr_running is:
+	 * nr_running:   present how many entity would take part in the sharing
+	 *               the cpu power of that cfs_rq
+	 * h_nr_running: present how many tasks in current cfs runqueue
+	 */
 	unsigned int nr_running, h_nr_running;
 
 	u64 exec_clock;
-- 
1.7.5.4

