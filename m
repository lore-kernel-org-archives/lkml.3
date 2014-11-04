Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbaKDHy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:54:56 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:44284 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaKDHyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:54:54 -0500
From: Kever Yang <kever.yang@rock-chips.com>
To: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, fzf@rock-chips.com, ykk@rock-chips.com,
        yzq@rock-chips.com, dkl@rock-chips.com, huangtao@rock-chips.com,
        Kever Yang <kever.yang@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] clk: rockchip: add full support for HDMI clock on rk3288
Date: Tue,  4 Nov 2014 15:52:34 +0800
Message-Id: <1415087559-19444-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we are going to make a clock usage solution for rk3288:
1. CPLL and GPLL always not change after assign init;
2. NPLL default as 500MHz, may used for most scene;
3. NPLL may be changed by VOP(HDMI) clock for some special
   frequency requirement.

    I test it with rk3288 evb on top of Heiko's clk-for-next


Kever Yang (5):
  clk: rockchip: add some clock rate into rate table for rk3288
  clk: divider: make clk_divider_recalc/set_rate available
  clk: rockchip: introduce the div_ops handling for composite branches
  clk: rockchip: add the vop_determine_rate for vop dclock
  clk: rockchip: change DCLK_VOP0 to use new COMPOSITE_DIVOPS

 drivers/clk/clk-divider.c         |  4 +--
 drivers/clk/rockchip/clk-rk3288.c | 76 ++++++++++++++++++++++++++++++++++++++-
 drivers/clk/rockchip/clk.c        | 13 ++++---
 drivers/clk/rockchip/clk.h        | 24 +++++++++++++
 include/linux/clk-provider.h      |  4 +++
 5 files changed, 114 insertions(+), 7 deletions(-)

-- 
1.9.1

