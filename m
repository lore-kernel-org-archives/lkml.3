Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400AbaE2IDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:03:30 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:37880 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553AbaE2IDZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:03:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: alot/0.3.5
To: torvalds@linux-foundation.org
Message-ID: <20140529080320.10062.15946@quantum>
Subject: [GIT PULL] clk: fixes for 3.15, part 2
Date: Thu, 29 May 2014 01:03:20 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4b660a7f5c8099d88d1a43d8ae138965112592c7:

  Linux 3.15-rc6 (2014-05-22 06:42:02 +0900)

are available in the git repository at:

  git://git.linaro.org/people/mike.turquette/linux.git tags/clk-fixes-for-linus

for you to fetch changes up to 5178438041cc94680e606e5a9c6d1ad9c911199b:

  Merge tag 'clk-tegra-fixes-3.15' of git://nv-tegra.nvidia.com/user/pdeschrijver/linux into clk-fixes (2014-05-27 21:11:08 -0700)

----------------------------------------------------------------

Small number of user-visible regression fixes for clock drivers. There
is a memory leak fix for an ST platform, an infinite Loop Of Doom fix
for the recent changes to the basic clock divider (hopefully the last
fix for those recent changes) and some Tegra PLL changes which keep PCI
from being hosed on that platform.

----------------------------------------------------------------
Maxime COQUELIN (1):
      clk: divider: Fix table round up function

Mike Turquette (1):
      Merge tag 'clk-tegra-fixes-3.15' of git://nv-tegra.nvidia.com/user/pdeschrijver/linux into clk-fixes

Thierry Reding (3):
      clk: tegra: Fix PLLE programming
      clk: tegra: Introduce divider mask and shift helpers
      clk: tegra: Fix enabling of PLLE

Valentin Ilie (1):
      clk: st: Fix memory leak

 drivers/clk/clk-divider.c   |  2 +-
 drivers/clk/st/clkgen-pll.c |  4 ++-
 drivers/clk/tegra/clk-pll.c | 64 ++++++++++++++++++++++++++++++---------------
 3 files changed, 47 insertions(+), 23 deletions(-)
