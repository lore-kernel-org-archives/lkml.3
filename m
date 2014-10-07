Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaJGD5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 23:57:55 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:53411 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaJGD5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 23:57:54 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        linux-mips@linux-mips.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] MIPS: rtlx: Remove unnecessary KERN_DEBUG in rtlx.c
Date: Tue,  7 Oct 2014 12:57:45 +0900
Message-Id: <1412654265-31983-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.1.273.g97b8860
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove unnecessary KERNL_DEBUG in pr_debug() within rtlx.c.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/mips/kernel/rtlx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/rtlx.c b/arch/mips/kernel/rtlx.c
index 31b1b76..c5c4fd5 100644
--- a/arch/mips/kernel/rtlx.c
+++ b/arch/mips/kernel/rtlx.c
@@ -94,12 +94,12 @@ int rtlx_open(int index, int can_sleep)
 	int ret = 0;
 
 	if (index >= RTLX_CHANNELS) {
-		pr_debug(KERN_DEBUG "rtlx_open index out of range\n");
+		pr_debug("rtlx_open index out of range\n");
 		return -ENOSYS;
 	}
 
 	if (atomic_inc_return(&channel_wqs[index].in_open) > 1) {
-		pr_debug(KERN_DEBUG "rtlx_open channel %d already opened\n", index);
+		pr_debug("rtlx_open channel %d already opened\n", index);
 		ret = -EBUSY;
 		goto out_fail;
 	}
-- 
2.1.1.273.g97b8860

