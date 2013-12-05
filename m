Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab3LEHo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 02:44:29 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:16336 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3LEHo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 02:44:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 04 Dec 2013 23:37:45 -0800
From: Bill Huang <bilhuang@nvidia.com>
To: <rjw@rjwysocki.net>, <viresh.kumar@linaro.org>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Bill Huang <bilhuang@nvidia.com>
Subject: [PATCH v3 0/2] Remodel Tegra cpufreq drivers to support Tegra series SoC 
Date: Thu, 5 Dec 2013 15:44:20 +0800
Message-ID: <1386229462-3474-1-git-send-email-bilhuang@nvidia.com>
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
are going to support DVFS.

Changes since v2:

- Fix Kconfig.
- Rebase on top of branch 'cpufreq-next' on git://git.linaro.org/people/vireshk/linux.git.

Changes since v1:

- Split up patches.
- Split configuration-time data out of structure "tegra_cpufreq_data".
- Bug fixes.

Bill Huang (2):
  cpufreq: tegra: Call tegra_cpufreq_init() specifically in machine
    code
  cpufreq: tegra: Re-model Tegra cpufreq driver

 arch/arm/mach-tegra/tegra.c       |    2 +
 drivers/cpufreq/Kconfig.arm       |   12 +++
 drivers/cpufreq/Makefile          |    1 +
 drivers/cpufreq/tegra-cpufreq.c   |  188 +++++++++++++++++--------------------
 drivers/cpufreq/tegra-cpufreq.h   |   40 ++++++++
 drivers/cpufreq/tegra20-cpufreq.c |  136 +++++++++++++++++++++++++++
 include/linux/tegra-soc.h         |   11 ++-
 7 files changed, 287 insertions(+), 103 deletions(-)
 create mode 100644 drivers/cpufreq/tegra-cpufreq.h
 create mode 100644 drivers/cpufreq/tegra20-cpufreq.c

-- 
1.7.9.5

