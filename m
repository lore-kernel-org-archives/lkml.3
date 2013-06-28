Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab3F1VTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 17:19:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49082 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab3F1VTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 17:19:03 -0400
Date: Fri, 28 Jun 2013 14:18:46 -0700
From: tip-bot for David Vrabel <tipbot@zytor.com>
Message-ID: <tip-0eb071651474952c8b6daecd36b378e2d01be22c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, john.stultz@linaro.org,
        xen-devel@lists.xen.org, tglx@linutronix.de, david.vrabel@citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, john.stultz@linaro.org,
        xen-devel@lists.xen.org, tglx@linutronix.de, david.vrabel@citrix.com
In-Reply-To: <1372329348-20841-2-git-send-email-david.vrabel@citrix.com>
References: <1372329348-20841-2-git-send-email-david.vrabel@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] xen: Remove clock_was_set()
  call in the resume path
Git-Commit-ID: 0eb071651474952c8b6daecd36b378e2d01be22c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 28 Jun 2013 14:18:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0eb071651474952c8b6daecd36b378e2d01be22c
Gitweb:     http://git.kernel.org/tip/0eb071651474952c8b6daecd36b378e2d01be22c
Author:     David Vrabel <david.vrabel@citrix.com>
AuthorDate: Thu, 27 Jun 2013 11:35:44 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Jun 2013 23:15:06 +0200

xen: Remove clock_was_set() call in the resume path

commit 359cdd3f866(xen: maintain clock offset over save/restore) added
a clock_was_set() call into the xen resume code to propagate the
system time changes. With the modified hrtimer resume code, which
makes sure that all cpus are notified this call is not longer necessary.

[ tglx: Separated it from the hrtimer change ]

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk  <konrad.wilk@oracle.com>
Cc: John Stultz  <john.stultz@linaro.org>
Cc: <xen-devel@lists.xen.org>
Link: http://lkml.kernel.org/r/1372329348-20841-2-git-send-email-david.vrabel@citrix.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 drivers/xen/manage.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 412b96c..421da85 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -166,9 +166,6 @@ out_resume:
 
 	dpm_resume_end(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
 
-	/* Make sure timer events get retriggered on all CPUs */
-	clock_was_set();
-
 out_thaw:
 #ifdef CONFIG_PREEMPT
 	thaw_processes();
