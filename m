Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbaF3Q4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:56:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63245 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250AbaF3Q4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:56:52 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, netdev@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 0/4] Introduce clk_find_nearest_rate()
Date: Mon, 30 Jun 2014 09:56:32 -0700
Message-Id: <1404147396-8041-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.0.1.1.gfbfc394
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Zynq I encountered issues due to rounding here and there. Often the
issue would have been resolved by rounding towards the requested
frequency. Unfortunately, the CCF does not specify  the behavior of
clk_round_rate() in terms of rounding, making this proposed API
call useful for certain use-cases.

An RFC of this series has been discussed here:
https://lkml.org/lkml/2014/5/14/694

Mike: IIRC, you wanted to fix the return type of __clk_round_rate(). Do
you have any patches for that already? I couldn't find anything in
clk-next.

Patch 1 adds the new API call.
2 and 3 apply the new API.
And 4 is a minor fixup of the Zynq DT. The frequencies in the Zynq OPPs
had been specified taking this rounding issues into account, which
is no longer required with this patchset.

	Thanks,
	Sören


Soren Brinkmann (4):
  clk: Introduce 'clk_find_nearest_rate()'
  cpufreq: cpu0: Use clk_find_nearest_rate()
  net: macb: Use clk_find_nearest_rate() API
  ARM: zynq: dt: Use properly rounded frequencies in OPPs

 arch/arm/boot/dts/zynq-7000.dtsi    |  4 +--
 drivers/clk/clk.c                   | 57 +++++++++++++++++++++++++++++++++++++
 drivers/cpufreq/cpufreq-cpu0.c      |  3 +-
 drivers/net/ethernet/cadence/macb.c |  2 +-
 include/linux/clk.h                 |  9 ++++++
 5 files changed, 71 insertions(+), 4 deletions(-)

-- 
2.0.1.1.gfbfc394

