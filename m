Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967634Ab3DRJoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:44:09 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:23612 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966428Ab3DRJoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:44:05 -0400
Message-ID: <516FC03F.9070100@parallels.com>
Date: Thu, 18 Apr 2013 13:43:27 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip:timers/core] kernel/posix-timers.c: Fix unused variable
References: <516f06a8.xFxNSO51jS+u5rc5%fengguang.wu@intel.com>
In-Reply-To: <516f06a8.xFxNSO51jS+u5rc5%fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kbuild test robot detected unused variable introduced by commit 5ed67f05 (posix
timers: Allocate timer id per process (v2)).

   kernel/posix-timers.c: In function '__posix_timers_find':
   kernel/posix-timers.c:157:21: warning: unused variable 'node' [-Wunused-variable]

This var is just not needed.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>

---

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 34d7592..424c2d4 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -154,7 +154,6 @@ static struct k_itimer *__posix_timers_find(struct hlist_head *head,
 					    struct signal_struct *sig,
 					    timer_t id)
 {
-	struct hlist_node *node;
 	struct k_itimer *timer;
 
 	hlist_for_each_entry_rcu(timer, head, t_hash) {
