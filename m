Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab3K0W1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:27:17 -0500
Received: from asav4.altibox.net ([81.167.36.153]:39311 "EHLO
	asav4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452Ab3K0W1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:27:13 -0500
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Nov 2013 17:27:13 EST
From: Henrik Austad <henrik@austad.us>
To: LKML doc <linux-doc@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Henrik Austad <henrik@austad.us>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Documentation/robust-futex-API: count properly to 4
Date: Wed, 27 Nov 2013 23:18:00 +0100
Message-Id: <1385590680-8110-1-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A strictly monotonically increasing sequence is normally used in
numbered lists as they provide an intuitive ordering of the elements.

However, in situations where race conditions can appear, this assumption
breaks down and you can end up with unpredictable results, leading to a
rather confusing list :-)

This changes the numbered list 1,2,2,2 to the more intuitive 1,2,3,4.

Introduces in 2eec9ad9 (lightweight robust futexes: docs)

CC: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Henrik Austad <henrik@austad.us>
---
 Documentation/robust-futex-ABI.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/robust-futex-ABI.txt b/Documentation/robust-futex-ABI.txt
index fd1cd8a..16eb314 100644
--- a/Documentation/robust-futex-ABI.txt
+++ b/Documentation/robust-futex-ABI.txt
@@ -146,8 +146,8 @@ On removal:
  1) set the 'list_op_pending' word to the address of the 'lock entry'
     to be removed,
  2) remove the lock entry for this lock from the 'head' list,
- 2) release the futex lock, and
- 2) clear the 'lock_op_pending' word.
+ 3) release the futex lock, and
+ 4) clear the 'lock_op_pending' word.
 
 On exit, the kernel will consider the address stored in
 'list_op_pending' and the address of each 'lock word' found by walking
-- 
1.7.10.4

