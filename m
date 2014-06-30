Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbaF3Lxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:53:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51919 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372AbaF3LxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 007/181] intel_idle: close avn_cstates array with correct marker
Date: Mon, 30 Jun 2014 13:50:28 +0200
Message-Id: <4c65d4f6fd4ae448900a9c3a0a9a31c5a5583774.1404128997.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 88390996c95b879ba365888199b45ace3f5ca80b upstream.

Close avn_cstates array with correct marker to avoid overflow
in function intel_idle_cpu_init().

[rjw: The problem was introduced when commit 22e580d07f65 was merged
 on top of eba682a5aeb6 (intel_idle: shrink states tables).]

Fixes: 22e580d07f65 (intel_idle: Fixed C6 state on Avoton/Rangeley processors)
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/idle/intel_idle.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 53235814ea0f..97f4e807c862 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -329,7 +329,7 @@ static struct cpuidle_state atom_cstates[CPUIDLE_STATE_MAX] = {
 	{
 		.enter = NULL }
 };
-static struct cpuidle_state avn_cstates[] __initdata = {
+static struct cpuidle_state avn_cstates[] = {
 	{
 		.name = "C1-AVN",
 		.desc = "MWAIT 0x00",
@@ -344,6 +344,8 @@ static struct cpuidle_state avn_cstates[] __initdata = {
 		.exit_latency = 15,
 		.target_residency = 45,
 		.enter = &intel_idle },
+	{
+		.enter = NULL }
 };
 
 /**
-- 
2.0.0

