Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbbAMPGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:06:53 -0500
Received: from mail.bmw-carit.de ([62.245.222.98]:53298 "EHLO
	linuxmail.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751190AbbAMPGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:06:52 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2015 10:06:52 EST
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v0] lockstat: Add documentation on contention and contenting points
Date: Tue, 13 Jan 2015 15:59:30 +0100
Message-Id: <1421161170-13045-1-git-send-email-daniel.wagner@bmw-carit.de>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
---

I spent some time to figure out what I saw in /proc/lock_stat. Maybe
someone else has the same question.
---
 Documentation/locking/lockstat.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/locking/lockstat.txt b/Documentation/locking/lockstat.txt
index 7428773..568bbba 100644
--- a/Documentation/locking/lockstat.txt
+++ b/Documentation/locking/lockstat.txt
@@ -121,6 +121,11 @@ show the header with column descriptions. Lines 05-18 and 20-31 show the actual
 statistics. These statistics come in two parts; the actual stats separated by a
 short separator (line 08, 13) from the contention points.
 
+Lines 09-12 show the first 4 recorded contention points (the code
+which tries to get the lock) and lines 14-17 show the first 4 recorded
+contended points (the lock holder). It is possible that the max
+con-bounces point is missing in the statistics.
+
 The first lock (05-18) is a read/write lock, and shows two lines above the
 short separator. The contention points don't match the column descriptors,
 they have two: contentions and [<IP>] symbol. The second set of contention
-- 
2.1.0

