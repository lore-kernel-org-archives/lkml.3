Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab3EQCcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 22:32:05 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:63032 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab3EQCcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 22:32:02 -0400
Message-ID: <51959668.9040106@huawei.com>
Date: Fri, 17 May 2013 10:31:04 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] watchdog: Disallow setting watchdog_thresh to -1
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In old kernels, it's allowed to set softlockup_thresh to -1 or 0
to disable softlockup detection. However watchdog_thresh only
uses 0 to disable detection, and setting it to -1 just froze my
box and nothing I can do but reboot.

Signed-off-by: Li Zefan <lizefan@huawei.com>
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
-- 
1.8.0.2
