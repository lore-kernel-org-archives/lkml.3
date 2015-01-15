Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbbAOMv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:51:58 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:42047 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbbAOMv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:51:57 -0500
From: Dmitry Osipenko <digetx@gmail.com>
To: digetx@gmail.com, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: tegra20: cpuidle: remove unnecessary "resettable" status clear
Date: Thu, 15 Jan 2015 15:49:37 +0300
Message-Id: <1421326202-29845-1-git-send-email-digetx@gmail.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU1 "resettable" status is already cleared by final suspend function in case
of suspend abortion and by reset handler in case of completed CPU powergate,
no point to do it again.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 arch/arm/mach-tegra/cpuidle-tegra20.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-tegra/cpuidle-tegra20.c b/arch/arm/mach-tegra/cpuidle-tegra20.c
index b30bf5c..ad6158e 100644
--- a/arch/arm/mach-tegra/cpuidle-tegra20.c
+++ b/arch/arm/mach-tegra/cpuidle-tegra20.c
@@ -158,8 +158,6 @@ static bool tegra20_idle_enter_lp2_cpu_1(struct cpuidle_device *dev,
 
 	cpu_suspend(0, tegra20_sleep_cpu_secondary_finish);
 
-	tegra20_cpu_clear_resettable();
-
 	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
 
 	return true;
-- 
2.2.1

