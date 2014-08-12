Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaHLMD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 08:03:29 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60280 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaHLMD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 08:03:27 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
X-Google-Original-From: Srinivas Kandagatla <srinivas.kandadgatla@linaro.org>
To: linux-mmc@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH RFC 0/5] mmc: mmci: sdio related fixes
Date: Tue, 12 Aug 2014 13:02:30 +0100
Message-Id: <1407844950-8072-1-git-send-email-srinivas.kandadgatla@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patchset fixes few sdio related issues encountered while testing
WLAN ath6kl via SDIO on IFC6410 board with Qualcomm APQ8064 SOC.

First patch "mmc: mmci: Enable SDIO support for Qualcomm variant data"
enables sdio support for Qualcom SOCs. I can move this out of this series
if it make sense to do.

Patches "mmc: mmci: move block size validation under relevant code" and
"mmc: mmci: relax blksz check for SDIO"
relaxes error checks for blocksizes which are not exactly power of 2.
The issue was ath6kl driver was issuing 12 bytes and 24 bytes reads
which are caught as part of the error handing in the driver and
resulting in failures.

Patch "mmc: mmci: Add sdio enable mask in variant data" adds extra
variant parameter to enable sdio. This makes mmci driver more flexible.

Patch "mmc: mmci: move ST specific sdio setup under a condition"
move ST specific sdio setup under a vendor id check condition so that
other variants dont use it. Am happy to change this if there is any
other better way.

All these patches are tested on IFC6410 board with ath6kl WLAN via SDIO.

Thanks,
srini

Srinivas Kandagatla (5):
  mmc: mmci: Enable SDIO support for Qualcomm variant data
  mmc: mmci: move block size validation under relevant code
  mmc: mmci: relax blksz check for SDIO
  mmc: mmci: Add sdio enable mask in variant data
  mmc: mmci: move ST specific sdio setup under a condition

 drivers/mmc/host/mmci.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

-- 
1.9.1

