Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691AbaEMOHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:07:31 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6354 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933585AbaEMOH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:07:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 13 May 2014 07:02:27 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: [RFC PATCH 0/3] Introduce shared and cbus clocks
Date: Tue, 13 May 2014 17:06:53 +0300
Message-ID: <1399990023-30318-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cbus clocks are virtual clocks which implement coordinated changes to
clock rates. They are used to change PLL rates with active child clocks.
On some SoCs (eg. Tegra) this requires the active child clocks to be moved
to a different parent durint the rate change.

Shared clocks are virtual clocks which implement clock policies such as
minimum required rate or maximum allowed rate.

Peter De Schrijver (3):
  clk: Implement cbus and shared clocks
  clk: tegra: Implement common shared clks
  clk: tegra: Implement Tegra124 shared/cbus clks

 drivers/clk/Makefile                     |    1 +
 drivers/clk/clk-shared-cbus.c            |  448 ++++++++++++++++++++++++++++++
 drivers/clk/tegra/Makefile               |    1 +
 drivers/clk/tegra/clk-id.h               |   58 ++++
 drivers/clk/tegra/clk-tegra-shared.c     |  128 +++++++++
 drivers/clk/tegra/clk-tegra124.c         |   50 ++++
 drivers/clk/tegra/clk.h                  |    1 +
 include/dt-bindings/clock/tegra124-car.h |   70 +++++-
 include/linux/clk-provider.h             |   56 ++++
 9 files changed, 812 insertions(+), 1 deletions(-)
 create mode 100644 drivers/clk/clk-shared-cbus.c
 create mode 100644 drivers/clk/tegra/clk-tegra-shared.c

-- 
1.7.7.rc0.72.g4b5ea.dirty

