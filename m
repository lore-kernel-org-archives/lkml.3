Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073AbaLBH4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:56:04 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:59200 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267AbaLBHz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:55:59 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Alex Elder <elder@linaro.org>, Bintian Wang <bintian.wang@huawei.com>,
        Chao Xie <chao.xie@marvell.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-mips@linux-mips.org, linux-omap@vger.kernel.org,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Matt Porter <mporter@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v7 0/7] Per-user clock constraints
Date: Tue,  2 Dec 2014 08:54:17 +0100
Message-Id: <1417506933-8915-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this seventh version of the series has added just a few fixes for new
implementations in linux-next of the determine_rate callback.

A rough test module was used to test this:

http://cgit.collabora.com/git/user/tomeu/linux.git/commit/?h=per-user-clk-constraints-v7&id=3d87d46d98f74b6f53eadf0d28785a3cd85c2178

The first five patches are just cleanups that should be desirable on their own,
and that should make easier to review the actual per-user clock patch.

The sixth patch actually moves the per-clock data that was stored in struct
clk to a new struct clk_core and adds references to it from both struct clk and
struct clk_hw. struct clk is now ready to contain information that is specific
to a given clk consumer.

The seventh patch adds API for setting floor and ceiling constraints and stores
that information on the per-user struct clk, which is iterable from struct
clk_core.

They are based on top of linux-next 20141201.

http://cgit.collabora.com/git/user/tomeu/linux.git/log/?h=per-user-clk-constraints-v7

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

 Documentation/clk.txt                   |   4 +-
 arch/arm/mach-omap2/cclock3xxx_data.c   | 108 +++--
 arch/arm/mach-omap2/clock.h             |  11 +-
 arch/arm/mach-omap2/clock_common_data.c |   5 +-
 arch/arm/mach-omap2/dpll3xxx.c          |   8 +-
 arch/arm/mach-omap2/dpll44xx.c          |   8 +-
 arch/mips/alchemy/common/clock.c        |  18 +-
 drivers/clk/at91/clk-programmable.c     |   6 +-
 drivers/clk/bcm/clk-kona.c              |   6 +-
 drivers/clk/clk-composite.c             |  18 +-
 drivers/clk/clk.c                       | 807 +++++++++++++++++++++-----------
 drivers/clk/clk.h                       |   5 +
 drivers/clk/clkdev.c                    |  80 +++-
 drivers/clk/hisilicon/clk-hi3620.c      |   4 +-
 drivers/clk/mmp/clk-mix.c               |   6 +-
 drivers/clk/qcom/clk-pll.c              |   3 +-
 drivers/clk/qcom/clk-rcg.c              |  30 +-
 drivers/clk/qcom/clk-rcg2.c             |  34 +-
 drivers/clk/sunxi/clk-factors.c         |   6 +-
 drivers/clk/sunxi/clk-sun6i-ar100.c     |   6 +-
 include/linux/clk-private.h             |  41 +-
 include/linux/clk-provider.h            |  26 +-
 include/linux/clk.h                     |  28 ++
 include/linux/clk/ti.h                  |   8 +-
 24 files changed, 873 insertions(+), 403 deletions(-)

-- 
1.9.3

