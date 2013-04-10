Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936587Ab3DJNxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:53:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59484 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935117Ab3DJNxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:53:32 -0400
Date: Wed, 10 Apr 2013 06:53:21 -0700
From: tip-bot for Sasha Levin <tipbot@zytor.com>
Message-ID: <tip-8184004ed7a0bc9538f5e825615c29fc52466bab@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1363795105-5884-1-git-send-email-sasha.levin@oracle.com>
References: <1363795105-5884-1-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking/rtmutex/tester:
  Set correct permissions on sysfs files
Git-Commit-ID: 8184004ed7a0bc9538f5e825615c29fc52466bab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 06:53:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8184004ed7a0bc9538f5e825615c29fc52466bab
Gitweb:     http://git.kernel.org/tip/8184004ed7a0bc9538f5e825615c29fc52466bab
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Wed, 20 Mar 2013 11:58:25 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 14:48:37 +0200

locking/rtmutex/tester: Set correct permissions on sysfs files

sysfs started complaining about cases where permissions don't
match what's in the sysfs ops structure (such as allowing read
without a "show" callback).

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: williams@redhat.com
Link: http://lkml.kernel.org/r/1363795105-5884-1-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/rtmutex-tester.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/rtmutex-tester.c b/kernel/rtmutex-tester.c
index 7890b10..1d96dd0 100644
--- a/kernel/rtmutex-tester.c
+++ b/kernel/rtmutex-tester.c
@@ -14,6 +14,7 @@
 #include <linux/spinlock.h>
 #include <linux/timer.h>
 #include <linux/freezer.h>
+#include <linux/stat.h>
 
 #include "rtmutex.h"
 
@@ -366,8 +367,8 @@ static ssize_t sysfs_test_status(struct device *dev, struct device_attribute *at
 	return curr - buf;
 }
 
-static DEVICE_ATTR(status, 0600, sysfs_test_status, NULL);
-static DEVICE_ATTR(command, 0600, NULL, sysfs_test_command);
+static DEVICE_ATTR(status, S_IRUSR, sysfs_test_status, NULL);
+static DEVICE_ATTR(command, S_IWUSR, NULL, sysfs_test_command);
 
 static struct bus_type rttest_subsys = {
 	.name = "rttest",
