Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbaHGXCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 19:02:10 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5987 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaHGXCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 19:02:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 07 Aug 2014 15:49:11 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, <linux-pm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 0/3] Introduce of_match_machine() helper
Date: Fri, 8 Aug 2014 02:01:52 +0300
Message-ID: <1407452515-2390-1-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some mach-specific drivers that don't require their own node in the device tree
(for example drivers/soc/*, cpufreq, cpuidle etc.) want to match on the device
tree root compatible property instead. Instead of open-coding (and forgetting
to call of_node_put on the root node) everywhere, add a helper to the OF core.

Tuomas Tynkkynen (3):
  of: Add of_match_machine helper
  soc/tegra: Use of_match_machine in soc_is_tegra()
  cpuidle: big.LITTLE: Use of_match_machine

 drivers/cpuidle/cpuidle-big_little.c |  6 +-----
 drivers/of/base.c                    | 21 +++++++++++++++++++++
 drivers/soc/tegra/common.c           |  8 +-------
 include/linux/of.h                   |  3 +++
 4 files changed, 26 insertions(+), 12 deletions(-)

-- 
1.8.1.5

