Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaAIHaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 02:30:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:65026 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbaAIH35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 02:29:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,629,1384329600"; 
   d="scan'208";a="455923312"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: " Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        " H. Peter Anvin" <hpa@linux.intel.com>,
        Len Brown <len.brown@intel.com>, Len Brown <lenb@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] intel_idle: close avn_cstates array with correct marker
Date: Thu,  9 Jan 2014 15:30:27 +0800
Message-Id: <1389252628-1033-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389252628-1033-1-git-send-email-jiang.liu@linux.intel.com>
References: <1389252628-1033-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Close avn_cstates array with correct marker to avoid overflow
in function intel_idle_cpu_init().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: <stable@vger.kernel.org> # 3.13
---
 drivers/idle/intel_idle.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 6f456f0..797ed29 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -329,7 +329,7 @@ static struct cpuidle_state atom_cstates[] = {
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
1.7.10.4

