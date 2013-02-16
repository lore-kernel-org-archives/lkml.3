Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab3BPJyA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 04:54:00 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33034 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab3BPJx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 04:53:57 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 4/5] freezer: clear fake signal on exit from __refrigerator
Date: Sat, 16 Feb 2013 01:53:25 -0800
Message-Id: <1361008406-2307-4-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1361008406-2307-1-git-send-email-msb@chromium.org>
References: <1361008406-2307-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In freeze_task, a freeze request is sent as a fake signal.

Recalculate signal pending on exit from __refrigerator so that
TIF_SIGPENDING doesn't remain incorrectly set.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: Ingo Molnar <mingo@redhat.com>
---
 kernel/freezer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index c38893b..fa66d0f 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -81,6 +81,9 @@ bool __refrigerator(bool check_kthr_stop)
 	 */
 	set_current_state(save);
 
+	/* Clear fake signal from freeze_task(). */
+	recalc_sigpending();
+
 	return was_frozen;
 }
 EXPORT_SYMBOL(__refrigerator);
-- 
1.7.12.4

