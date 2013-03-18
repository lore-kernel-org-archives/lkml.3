Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3CRLCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:02:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34045 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3CRLCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:02:03 -0400
Date: Mon, 18 Mar 2013 04:00:46 -0700
From: tip-bot for anish kumar <tipbot@zytor.com>
Message-ID: <tip-b66a2356d7108a15b8b5c9b8e6213e05ead22cd6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        anish198519851985@gmail.com, tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        anish198519851985@gmail.com, tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <1363113848-18344-1-git-send-email-dzickus@redhat.com>
References: <1363113848-18344-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] watchdog:
  Add comments to explain the watchdog_disabled variable
Git-Commit-ID: b66a2356d7108a15b8b5c9b8e6213e05ead22cd6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Mar 2013 04:00:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b66a2356d7108a15b8b5c9b8e6213e05ead22cd6
Gitweb:     http://git.kernel.org/tip/b66a2356d7108a15b8b5c9b8e6213e05ead22cd6
Author:     anish kumar <anish198519851985@gmail.com>
AuthorDate: Tue, 12 Mar 2013 14:44:08 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Mar 2013 08:24:05 +0100

watchdog: Add comments to explain the watchdog_disabled variable

The watchdog_disabled flag is a bit cryptic. However it's
usefulness is multifold. Uses are:

 1. Check if smpboot_register_percpu_thread function passed.

 2. Makes sure that user enables and disables the watchdog in
    sequence i.e. enable watchdog->disable watchdog->enable watchdog
    Unlike enable watchdog->enable watchdog which is wrong.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
[small text cleanups]
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: chuansheng.liu@intel.com
Cc: paulmck@linux.vnet.ibm.com
Link: http://lkml.kernel.org/r/1363113848-18344-1-git-send-email-dzickus@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/watchdog.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 4a94467..05039e3 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -517,6 +517,11 @@ int proc_dowatchdog(struct ctl_table *table, int write,
 		return ret;
 
 	set_sample_period();
+	/*
+	 * Watchdog threads shouldn't be enabled if they are
+	 * disabled. The 'watchdog_disabled' variable check in
+	 * watchdog_*_all_cpus() function takes care of this.
+	 */
 	if (watchdog_enabled && watchdog_thresh)
 		watchdog_enable_all_cpus();
 	else
