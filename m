Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbaEEIsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:48:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47573 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468AbaEEIsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:48:08 -0400
Date: Mon, 5 May 2014 01:46:38 -0700
From: tip-bot for Michael Kerrisk <tipbot@zytor.com>
Message-ID: <tip-2779ac167b1a1bf8153dca9f3a141c6148c6b89f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rdunlap@infradead.org, tglx@linutronix.de, mtk.manpages@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org, tglx@linutronix.de, mtk.manpages@gmail.com
In-Reply-To: <53636FB6.9060407@gmail.com>
References: <53636FB6.9060407@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timer_stats/doc: Fix /proc/
 timer_stats documentation
Git-Commit-ID: 2779ac167b1a1bf8153dca9f3a141c6148c6b89f
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

Commit-ID:  2779ac167b1a1bf8153dca9f3a141c6148c6b89f
Gitweb:     http://git.kernel.org/tip/2779ac167b1a1bf8153dca9f3a141c6148c6b89f
Author:     Michael Kerrisk <mtk.manpages@gmail.com>
AuthorDate: Fri, 2 May 2014 12:13:10 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 4 May 2014 20:46:32 +0200

timer_stats/doc: Fix /proc/timer_stats documentation

Documentation/timers/timer_stats.txt claims:

 "The readout of /proc/timer_stats automatically disables sampling. The sampled
  information is kept until a new sample period is started. This allows multiple
  readouts."

Some simple testing shows that reading from /proc/timer_stats
does not disable sampling. Looking back over past source code,
it appears that it never did.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Link: http://lkml.kernel.org/r/53636FB6.9060407@gmail.com
[ Small tidyup of the changelog. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/timers/timer_stats.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/timers/timer_stats.txt b/Documentation/timers/timer_stats.txt
index 8abd40b..de835ee 100644
--- a/Documentation/timers/timer_stats.txt
+++ b/Documentation/timers/timer_stats.txt
@@ -39,9 +39,9 @@ To stop a sample period issue:
 The statistics can be retrieved by:
 # cat /proc/timer_stats
 
-The readout of /proc/timer_stats automatically disables sampling. The sampled
-information is kept until a new sample period is started. This allows multiple
-readouts.
+While sampling is enabled, each readout from /proc/timer_stats will see
+newly updated statistics. Once sampling is disabled, the sampled information
+is kept until a new sample period is started. This allows multiple readouts.
 
 Sample output of /proc/timer_stats:
 
