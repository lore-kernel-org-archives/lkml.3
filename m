Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190Ab3E1NcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:32:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50550 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934122Ab3E1NcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:32:11 -0400
Date: Tue, 28 May 2013 06:30:57 -0700
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-a6572f84c5b135d9b6df279ed3c8de028bd1edd9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, dzickus@redhat.com, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, lizefan@huawei.com, dzickus@redhat.com
In-Reply-To: <51959668.9040106@huawei.com>
References: <51959668.9040106@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] watchdog: Disallow setting watchdog_thresh to -1
Git-Commit-ID: a6572f84c5b135d9b6df279ed3c8de028bd1edd9
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

Commit-ID:  a6572f84c5b135d9b6df279ed3c8de028bd1edd9
Gitweb:     http://git.kernel.org/tip/a6572f84c5b135d9b6df279ed3c8de028bd1edd9
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Fri, 17 May 2013 10:31:04 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 11:28:18 +0200

watchdog: Disallow setting watchdog_thresh to -1

In old kernels, it's allowed to set softlockup_thresh to -1 or 0
to disable softlockup detection. However watchdog_thresh only
uses 0 to disable detection, and setting it to -1 just froze my
box and nothing I can do but reboot.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/51959668.9040106@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sysctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 9edcf45..b0a1f99 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -120,7 +120,6 @@ extern int blk_iopoll_enabled;
 /* Constants used for minimum and  maximum */
 #ifdef CONFIG_LOCKUP_DETECTOR
 static int sixty = 60;
-static int neg_one = -1;
 #endif
 
 static int zero;
@@ -814,7 +813,7 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dowatchdog,
-		.extra1		= &neg_one,
+		.extra1		= &zero,
 		.extra2		= &sixty,
 	},
 	{
