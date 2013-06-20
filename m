Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3FTGXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 02:23:44 -0400
Received: from intranet.asianux.com ([58.214.24.6]:14177 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab3FTGXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 02:23:43 -0400
X-Spam-Score: -100.8
Message-ID: <51C29FBC.1090507@asianux.com>
Date: Thu, 20 Jun 2013 14:22:52 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/itimer.c: for return value, using -EINVAL instead
 of -EFAULT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For the system call getitimer(), if the parameter 'value' is NULL, need
return -EINVAL, not -EFAULT.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/itimer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/itimer.c b/kernel/itimer.c
index 8d262b4..6f9d757 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -102,7 +102,7 @@ int do_getitimer(int which, struct itimerval *value)
 
 SYSCALL_DEFINE2(getitimer, int, which, struct itimerval __user *, value)
 {
-	int error = -EFAULT;
+	int error = -EINVAL;
 	struct itimerval get_buffer;
 
 	if (value) {
-- 
1.7.7.6
