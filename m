Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbaGWCeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:34:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:54597 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbaGWCeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:34:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="363778383"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, paulus@samba.org,
        benh@kernel.crashing.org, tony.luck@intel.com, hpa@zytor.com,
        jkosina@suse.cz, rafael.j.wysocki@intel.com, bp@alien8.de,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [RFC PATCH v1 31/70] kernel, relay: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:07 -0400
Message-Id: <1406080786-3938-32-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from fs/relay.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 kernel/relay.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index 5a56d3c..3f7b6b1 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -523,9 +523,8 @@ static int relay_hotcpu_callback(struct notifier_block *nb,
 	unsigned int hotcpu = (unsigned long)hcpu;
 	struct rchan *chan;
 
-	switch(action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		mutex_lock(&relay_channels_mutex);
 		list_for_each_entry(chan, &relay_channels, list) {
 			if (chan->buf[hotcpu])
@@ -542,7 +541,6 @@ static int relay_hotcpu_callback(struct notifier_block *nb,
 		mutex_unlock(&relay_channels_mutex);
 		break;
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		/* No need to flush the cpu : will be flushed upon
 		 * final relay_flush() call. */
 		break;
-- 
2.0.0.rc2

