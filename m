Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab3AUDHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 22:07:51 -0500
Received: from talus.maths.usyd.edu.au ([129.78.68.1]:59556 "EHLO
	talus.maths.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab3AUDHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 22:07:50 -0500
X-smtpdoor-from: psz@maths.usyd.edu.au
X-smtpdoor-want-Message-ID: <201301210307.r0L37YuG018834@como.maths.usyd.edu.au>
Date: Mon, 21 Jan 2013 14:07:34 +1100
From: paul.szabo@sydney.edu.au
Message-Id: <201301210307.r0L37YuG018834@como.maths.usyd.edu.au>
To: linux-mm@kvack.org
Subject: [PATCH] MAX_PAUSE to be at least 4
Cc: 695182@bugs.debian.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure MAX_PAUSE is 4 or larger, so limits in
	return clamp_val(t, 4, MAX_PAUSE);
(the only use of it) are not back-to-front.

(This patch does not solve the PAE OOM issue.)

Paul Szabo   psz@maths.usyd.edu.au   http://www.maths.usyd.edu.au/u/psz/
School of Mathematics and Statistics   University of Sydney    Australia

Reported-by: Paul Szabo <psz@maths.usyd.edu.au>
Reference: http://bugs.debian.org/695182
Signed-off-by: Paul Szabo <psz@maths.usyd.edu.au>

--- mm/page-writeback.c.old	2012-12-06 22:20:40.000000000 +1100
+++ mm/page-writeback.c	2013-01-21 13:57:05.000000000 +1100
@@ -39,7 +39,7 @@
 /*
  * Sleep at most 200ms at a time in balance_dirty_pages().
  */
-#define MAX_PAUSE		max(HZ/5, 1)
+#define MAX_PAUSE		max(HZ/5, 4)
 
 /*
  * Estimate write bandwidth at 200ms intervals.
