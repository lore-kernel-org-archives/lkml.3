Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab3IKLTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:19:45 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11824 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3IKLTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:19:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 11 Sep 2013 04:19:41 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: <rjw@sisk.pl>, <viresh.kumar@linaro.org>, <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Bill Huang <bilhuang@nvidia.com>
Subject: [PATCH 0/2] Remodel Tegra cpufreq driver to support Tegra series SoCs 
Date: Wed, 11 Sep 2013 04:19:12 -0700
Message-ID: <1378898355-31290-1-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series remodel Tegra cpufreq driver to make it more easy to
add new SoC support, in addition to that, adding probe function in the
driver to let probe defer can be used to control init sequence when we
going to support DVFS.

Bill Huang (2):
  cpufreq: tegra: Remove not used header and clean up codes
  cpufreq: tegra: Re-model Tegra cpufreq driver

 arch/arm/mach-tegra/common.c      |    2 +
 drivers/cpufreq/Kconfig.arm       |   16 +++-
 drivers/cpufreq/Makefile          |    1 +
 drivers/cpufreq/tegra-cpufreq.c   |  192 +++++++++++++++++--------------------
 drivers/cpufreq/tegra-cpufreq.h   |   37 +++++++
 drivers/cpufreq/tegra20-cpufreq.c |  133 +++++++++++++++++++++++++
 include/linux/tegra-soc.h         |   11 ++-
 7 files changed, 283 insertions(+), 109 deletions(-)
 create mode 100644 drivers/cpufreq/tegra-cpufreq.h
 create mode 100644 drivers/cpufreq/tegra20-cpufreq.c

-- 
1.7.9.5

