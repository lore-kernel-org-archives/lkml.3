Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaEBKNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 06:13:23 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:63236 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaEBKNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 06:13:22 -0400
Message-ID: <53636FB6.9060407@gmail.com>
Date: Fri, 02 May 2014 12:13:10 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mtk.manpages@gmail.com, Randy Dunlap <rdunlap@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [patch] timer_stats, doc: Readout of /proc/timer_stats doesn't disable
 sampling
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Kerrisk <mtk.manpages@gmail.com>

Some simple testing shows that reading from /proc/timer_stats
does not disable sampling. Looking back over past source code,
it appears that it never did.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
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
 
-- 
1.9.0
