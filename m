Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaKXE4h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 23:56:37 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:49088 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaKXE4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 23:56:36 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: alot/0.3.5
To: torvalds@linux-foundation.org
Message-ID: <20141124045631.12298.63239@quantum>
Subject: [GIT PULL] clk: fixes for 3.18
Date: Sun, 23 Nov 2014 20:56:31 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:

  Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)

are available in the git repository at:

  https://git.linaro.org/people/mike.turquette/linux.git tags/clk-fixes-for-linus

for you to fetch changes up to dcf3d458304aafda3d12413ade39fdf19740dbc3:

  clk: pxa: fix pxa27x CCCR bit usage (2014-11-17 11:25:29 -0800)

----------------------------------------------------------------
The fixes for the clock framework are all regressions in drivers, plus a
single fix in one of the basic clock templates. No fixes to the core
this time around. As with most clock driver fixes these run the gamut
from fixing a build warning to fixing wrecked memory timings, with a
little USB tossed in for fun. Please consider pulling.

----------------------------------------------------------------
Boris Brezillon (2):
      clk: at91: usb: fix at91rm9200 round and set rate
      clk: at91: usb: fix at91sam9x5 recalc, round and set rate

Georgi Djakov (1):
      clk: qcom: Fix duplicate rbcpr clock name

James Hogan (1):
      clk-divider: Fix READ_ONLY when divider > 1

Robert Jarzmik (1):
      clk: pxa: fix pxa27x CCCR bit usage

 drivers/clk/at91/clk-usb.c                    | 35 ++++++++++++++-------------
 drivers/clk/clk-divider.c                     | 18 +++++++-------
 drivers/clk/pxa/clk-pxa27x.c                  |  4 +--
 drivers/clk/qcom/mmcc-apq8084.c               |  2 +-
 drivers/clk/rockchip/clk.c                    |  4 +--
 include/dt-bindings/clock/qcom,mmcc-apq8084.h |  2 +-
 include/linux/clk-provider.h                  |  1 -
 7 files changed, 32 insertions(+), 34 deletions(-)
