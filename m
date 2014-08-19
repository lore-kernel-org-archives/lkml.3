Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaHSLOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:14:53 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40639 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbaHSLOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:14:03 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: linux-mmc@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v2 0/4] mmc: mmci: sdio related fixes
Date: Tue, 19 Aug 2014 12:13:05 +0100
Message-Id: <1408446785-1399-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407844950-8072-1-git-send-email-srinivas.kandadgatla@linaro.org>
References: <1407844950-8072-1-git-send-email-srinivas.kandadgatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes few sdio related issues encountered while testing
WLAN ath6kl via SDIO on IFC6410 board with Qualcomm APQ8064 SOC.

Patch: "mmc: mmci: Support any block sizes for ux500v2 and qcom variant" is
a very old patch by Ulf to support IPs which support any size of block sizes.
http://www.spinics.net/lists/linux-mmc/msg12160.html I modified the subject
line to include qcom.

Patches "mmc: mmci: move block size validation under relevant code" 
Moves a BUG check to relevant code path.

Both of the patches fixes below issues reported while testing sdio.
The issue was ath6kl driver was issuing 12 bytes and 24 bytes reads
which are caught as part of the error handing in the driver and
resulting in failures. 

Patch "mmc: mmci: Add sdio enable mask in variant data" adds extra
variant parameter to enable sdio. This makes mmci driver more flexible.

Patch "mmc: mmci: rename sdio flag in vendor data to st_sdio" renames sdio
flag in vendor data to st_sdio, as this flag is only used to setup st
specific sdio logic.

All these patches are tested on IFC6410 board with ath6kl WLAN via SDIO.

Thanks to Linus W and Russell for comments on RFC.

Changes since RFC:
	- moved sdio flag to st_sdio to simplify the checks.
	- use Ulf's patch to address IP's which support anysize blocks.

Thanks,
srini

Srinivas Kandagatla (3):
  mmc: mmci: move block size validation under relevant code
  mmc: mmci: Add sdio enable mask in variant data
  mmc: mmci: rename sdio flag in vendor data to st_sdio

Ulf Hansson (1):
  mmc: mmci: Support any block sizes for ux500v2 and qcom variant

 drivers/mmc/host/mmci.c | 78 ++++++++++++++++++++++++++-----------------------
 1 file changed, 42 insertions(+), 36 deletions(-)

-- 
1.9.1

