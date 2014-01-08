Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbaAHS5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:57:17 -0500
Received: from mail-qe0-f73.google.com ([209.85.128.73]:46886 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaAHS5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:57:16 -0500
From: Greg Hackmann <ghackmann@google.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, john.stultz@linaro.org,
        Greg Hackmann <ghackmann@google.com>
Subject: [PATCH] timerfd: support CLOCK_BOOTTIME clock
Date: Wed,  8 Jan 2014 10:57:03 -0800
Message-Id: <1389207423-31154-1-git-send-email-ghackmann@google.com>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CLOCK_BOOTTIME support to timerfd

Signed-off-by: Greg Hackmann <ghackmann@google.com>
---
 fs/timerfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 9293121..0013142 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -317,6 +317,7 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 	    (clockid != CLOCK_MONOTONIC &&
 	     clockid != CLOCK_REALTIME &&
 	     clockid != CLOCK_REALTIME_ALARM &&
+	     clockid != CLOCK_BOOTTIME &&
 	     clockid != CLOCK_BOOTTIME_ALARM))
 		return -EINVAL;
 
-- 
1.8.5.1

