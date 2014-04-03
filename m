Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162685AbaDCIxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:53:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:43876 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162578AbaDCIxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:53:35 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Bockholdt Arne <a.bockholdt@precitec-optronik.de>,
        Arne Bockholdt <linux-kernel@bockholdt.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 04/41] intel_idle: Fixed C6 state on Avoton/Rangeley processors
Date: Thu,  3 Apr 2014 10:53:30 +0200
Message-Id: <34bf8801b2b4f6205a4f9e0045fbcf035c709e76.1396514932.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bockholdt Arne <a.bockholdt@precitec-optronik.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 22e580d07f6529a395c129575127ea6d860aed3a upstream.

Corrected the MWAIT flag for C-State C6 on Intel Avoton/Rangeley processors.

Signed-off-by: Arne Bockholdt <linux-kernel@bockholdt.com>
Acked-by: Len Brown <len.brown@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/idle/intel_idle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 000d370519d9..53235814ea0f 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -329,7 +329,7 @@ static struct cpuidle_state atom_cstates[CPUIDLE_STATE_MAX] = {
 	{
 		.enter = NULL }
 };
-static struct cpuidle_state avn_cstates[CPUIDLE_STATE_MAX] = {
+static struct cpuidle_state avn_cstates[] __initdata = {
 	{
 		.name = "C1-AVN",
 		.desc = "MWAIT 0x00",
@@ -340,7 +340,7 @@ static struct cpuidle_state avn_cstates[CPUIDLE_STATE_MAX] = {
 	{
 		.name = "C6-AVN",
 		.desc = "MWAIT 0x51",
-		.flags = MWAIT2flg(0x58) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x51) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 15,
 		.target_residency = 45,
 		.enter = &intel_idle },
-- 
1.9.1

