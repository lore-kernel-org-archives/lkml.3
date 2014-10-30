Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbaJ3KvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:51:10 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:46744 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758326AbaJ3KvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:51:08 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Alex Elder <elder@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-omap@vger.kernel.org, Manuel Lauss <manuel.lauss@gmail.com>,
        Matt Porter <mporter@linaro.org>, Ralf Baechle <ralf@linux-mips.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v5 0/7] Per-user clock constraints
Date: Thu, 30 Oct 2014 11:48:26 +0100
Message-Id: <1414666135-14313-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this fifth version of the series has just one change, suggested by Stephen:

* Initialize clk.ceiling_constraint to ULONG_MAX and warn about new floor
constraints being higher than the existing ceiling.

The first five patches are just cleanups that should be desirable on their own,
and that should make easier to review the actual per-user clock patch.

The sixth patch actually moves the per-clock data that was stored in struct
clk to a new struct clk_core and adds references to it from both struct clk and
struct clk_hw. struct clk is now ready to contain information that is specific
to a given clk consumer.

The seventh patch adds API for setting floor and ceiling constraints and stores
that information on the per-user struct clk, which is iterable from struct
clk_core.

They are based on top of 3.18-rc1.

http://cgit.collabora.com/git/user/tomeu/linux.git/log/?h=per-user-clk-constraints-v5

Thanks,

Tomeu

Tomeu Vizoso (7):
  clk: Remove unused function __clk_get_prepare_count
  clk: Don't try to use a struct clk* after it could have been freed
  clk: Don't expose __clk_get_accuracy
  clk: change clk_debugfs_add_file to take a struct clk_hw
  clk: Change clk_ops->determine_rate to return a clk_hw as the best
    parent
  clk: Make clk API return per-user struct clk instances
  clk: Add floor and ceiling constraints to clock rates

 Documentation/clk.txt                   |   2 +-
 arch/arm/mach-omap2/cclock3xxx_data.c   | 108 +++--
 arch/arm/mach-omap2/clock.h             |  11 +-
 arch/arm/mach-omap2/clock_common_data.c |   5 +-
 arch/mips/alchemy/common/clock.c        |  10 +-
 drivers/clk/at91/clk-programmable.c     |   4 +-
 drivers/clk/bcm/clk-kona.c              |   4 +-
 drivers/clk/clk-composite.c             |   9 +-
 drivers/clk/clk.c                       | 793 +++++++++++++++++++++-----------
 drivers/clk/clk.h                       |   5 +
 drivers/clk/clkdev.c                    |  73 ++-
 drivers/clk/hisilicon/clk-hi3620.c      |   2 +-
 drivers/clk/qcom/clk-rcg.c              |  20 +-
 drivers/clk/qcom/clk-rcg2.c             |  28 +-
 drivers/clk/sunxi/clk-factors.c         |   4 +-
 drivers/clk/sunxi/clk-sun6i-ar100.c     |   4 +-
 include/linux/clk-private.h             |  41 +-
 include/linux/clk-provider.h            |  17 +-
 include/linux/clk.h                     |  18 +
 19 files changed, 773 insertions(+), 385 deletions(-)

-- 
1.9.3

