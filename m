Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaHQRdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:33:08 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:59852
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134AbaHQRbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:31:53 -0400
Message-Id: <20140817173037.881915198@linux.com>
Date: Sun, 17 Aug 2014 12:30:55 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 32/35] [PATCH 32/36] clocksource: Replace __this_cpu_ptr with raw_cpu_ptr
References: <20140817173023.439660246@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0032-clocksource-Replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One newly introduced __this_cpu_ptr should be raw_cpu_ptr.

Signed-off-by: Christoph Lameter <cl@linux.com>
---
 drivers/clocksource/qcom-timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/clocksource/qcom-timer.c
===================================================================
--- linux.orig/drivers/clocksource/qcom-timer.c
+++ linux/drivers/clocksource/qcom-timer.c
@@ -219,7 +219,7 @@ static void __init msm_timer_init(u32 dg
 		}
 
 		/* Immediately configure the timer on the boot CPU */
-		msm_local_timer_setup(__this_cpu_ptr(msm_evt));
+		msm_local_timer_setup(raw_cpu_ptr(msm_evt));
 	}
 
 err:

