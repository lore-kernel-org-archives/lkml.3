Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbaFDLrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:47:46 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6989 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaFDLrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:47:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 04 Jun 2014 04:42:34 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <tj@kernel.org>,
        <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 6/9] ARM: tegra: Export tegra_powergate_power_on
Date: Wed, 4 Jun 2014 14:32:36 +0300
Message-ID: <1401881559-18469-7-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This symbol needs to be exported to power on rails without using
tegra_powergate_sequence_power_up. tegra_powergate_sequence_power_up
cannot be used in situations where the driver wants to handle clocking
by itself.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 arch/arm/mach-tegra/powergate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-tegra/powergate.c b/arch/arm/mach-tegra/powergate.c
index 50a9af4..254c42e 100644
--- a/arch/arm/mach-tegra/powergate.c
+++ b/arch/arm/mach-tegra/powergate.c
@@ -125,6 +125,7 @@ int tegra_powergate_power_on(int id)
 
 	return tegra_powergate_set(id, true);
 }
+EXPORT_SYMBOL(tegra_powergate_power_on);
 
 int tegra_powergate_power_off(int id)
 {
-- 
1.8.1.5

