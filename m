Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbbAQXgf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 18:36:35 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58135 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbbAQXge convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 18:36:34 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, sboyd@codeaurora.org
User-Agent: alot/0.3.5
To: torvalds@linux-foundation.org
Message-ID: <20150117233624.22722.29951@quantum>
Subject: [GIT PULL] clk: fixes for 3.19
Date: Sat, 17 Jan 2015 15:36:24 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  https://git.linaro.org/people/mike.turquette/linux.git tags/clk-fixes-for-linus

for you to fetch changes up to c7662fc59ca38517e0ec04ceaa123ed8209ab6bf:

  clk: fix possible null pointer dereference (2015-01-17 11:33:57 -0800)

----------------------------------------------------------------
Small number of fixes for clock drivers and a single null pointer
dereference fix in the framework core code. The driver fixes vary from
fixing section mismatch warnings to preventing machines from hanging
(and preventing developers from crying).

----------------------------------------------------------------
Boris Brezillon (1):
      clk: at91: keep slow clk enabled to prevent system hang

Heiko Stuebner (2):
      clk: rockchip: fix rk3066 pll lock bit location
      clk: rockchip: fix rk3288 cpuclk core dividers

Heiko Stübner (1):
      clk: rockchip: fix deadlock possibility in cpuclk

Jisheng Zhang (1):
      clk: berlin: bg2q: remove non-exist "smemc" gate clock

Julien CHAUVEAU (1):
      clk: rockchip: add CLK_IGNORE_UNUSED flag to fix rk3066/rk3188 USB Host

Kevin Hao (1):
      Revert "clk: ppc-corenet: Fix Section mismatch warning"

Michael Turquette (1):
      Merge tag 'v3.19-rockhip-clkfixes1' of git://git.kernel.org/.../mmind/linux-rockchip into clk-fixes

Romain Perier (1):
      clk: rockchip: Fix clock gate for rk3188 hclk_emem_peri

Stanimir Varbanov (1):
      clk: fix possible null pointer dereference

 drivers/clk/at91/clk-slow.c       | 27 +++++++++++++++++++++++++++
 drivers/clk/berlin/bg2q.c         |  1 -
 drivers/clk/clk-ppc-corenet.c     |  2 +-
 drivers/clk/clk.c                 |  2 +-
 drivers/clk/rockchip/clk-cpu.c    | 10 ++++++----
 drivers/clk/rockchip/clk-rk3188.c | 27 ++++++++++++++++++++-------
 drivers/clk/rockchip/clk-rk3288.c | 28 ++++++++++++++--------------
 7 files changed, 69 insertions(+), 28 deletions(-)
