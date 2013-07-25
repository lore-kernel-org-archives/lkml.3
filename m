Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab3GYAnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 20:43:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34866 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab3GYAnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 20:43:45 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Hogan <james.hogan@imgtec.com>, devicetree@vger.kernel.org
Subject: [PATCH v1 00/14] Add support for MSM's mmio clocks
Date: Wed, 24 Jul 2013 17:43:28 -0700
Message-Id: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.4.840.g6a90778
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reposting this RFC due to conflicts with v3.11-rc1 and because I haven't
gone through and generated all the data needed yet. This is just a few
clocks for now to give a general idea until I get some comments from DT
reviewers.

The first 4 patches are generic clock framework patches. They add support
for finding clocks in DT and parsing them generically. They also add support
for setting the rate and the parent at the same time based on patches from
James Hogan's remuxing set_rate series [1].

After that we add MSM clock hardware support and then fill in the DT and
data to actually register clocks. This is sufficient enough to get the UART
going on my msm8960 device.

If DT reviewers are ok I'll go ahead and generate the rest of the data
and post v2.

Stephen Boyd (14):
  clk: fixed-rate: Export clk_fixed_rate_register()
  clk: Add of_init_clk_data() to parse common clock bindings
  clk: Add of_clk_match() for device drivers
  clk: Add set_rate_and_parent() op
  clk: msm: Add support for phase locked loops (PLLs)
  clk: msm: Add support for root clock generators (RCGs)
  clk: msm: Add support for branches/gate clocks
  clk: msm: Add MSM clock driver
  clk: msm: Add support for MSM8960's global clock controller (GCC)
  clk: msm: Add support for MSM8960's multimedia clock controller (MMCC)
  ARM: dts: msm: Add MSM8960 GCC DT nodes
  ARM: dts: msm: Add MSM8960 MMCC DT nodes
  clk: msm: Add MSM8974 GCC data
  ARM: dts: msm: Add clock entries for MSM8960 uart device

 Documentation/clk.txt                              |   3 +
 Documentation/devicetree/bindings/clock/msm.txt    |  99 +++
 .../devicetree/bindings/clock/qcom,gcc.txt         |  56 ++
 .../devicetree/bindings/clock/qcom,mmcc.txt        |  38 ++
 arch/arm/boot/dts/msm8960-cdp.dts                  | 111 +++
 drivers/clk/Kconfig                                |   2 +
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-fixed-rate.c                       |   1 +
 drivers/clk/clk.c                                  | 201 +++++-
 drivers/clk/msm/Kconfig                            |  29 +
 drivers/clk/msm/Makefile                           |  12 +
 drivers/clk/msm/clk-branch.c                       | 190 ++++++
 drivers/clk/msm/clk-branch.h                       |  48 ++
 drivers/clk/msm/clk-pll.c                          | 233 +++++++
 drivers/clk/msm/clk-pll.h                          |  43 ++
 drivers/clk/msm/clk-rcg.c                          | 754 +++++++++++++++++++++
 drivers/clk/msm/clk-rcg.h                          | 114 ++++
 drivers/clk/msm/clk-rcg2.c                         | 320 +++++++++
 drivers/clk/msm/core.c                             | 274 ++++++++
 drivers/clk/msm/gcc-8960.c                         | 174 +++++
 drivers/clk/msm/gcc-8974.c                         | 107 +++
 drivers/clk/msm/internal.h                         |  28 +
 drivers/clk/msm/mmcc-8960.c                        | 142 ++++
 include/linux/clk-provider.h                       |  38 ++
 24 files changed, 2998 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/msm.txt
 create mode 100644 Documentation/devicetree/bindings/clock/qcom,gcc.txt
 create mode 100644 Documentation/devicetree/bindings/clock/qcom,mmcc.txt
 create mode 100644 drivers/clk/msm/Kconfig
 create mode 100644 drivers/clk/msm/Makefile
 create mode 100644 drivers/clk/msm/clk-branch.c
 create mode 100644 drivers/clk/msm/clk-branch.h
 create mode 100644 drivers/clk/msm/clk-pll.c
 create mode 100644 drivers/clk/msm/clk-pll.h
 create mode 100644 drivers/clk/msm/clk-rcg.c
 create mode 100644 drivers/clk/msm/clk-rcg.h
 create mode 100644 drivers/clk/msm/clk-rcg2.c
 create mode 100644 drivers/clk/msm/core.c
 create mode 100644 drivers/clk/msm/gcc-8960.c
 create mode 100644 drivers/clk/msm/gcc-8974.c
 create mode 100644 drivers/clk/msm/internal.h
 create mode 100644 drivers/clk/msm/mmcc-8960.c

[1] Subject: [PATCH v5 0/5] clk: implement remuxing during set_rate                 Message-ID: <1371139562-305-1-git-send-email-james.hogan@imgtec.com>  

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

