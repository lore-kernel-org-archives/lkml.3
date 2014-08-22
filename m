Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbaHVEyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 00:54:25 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36303 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaHVEyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 00:54:23 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: linux-mmc@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v3 0/3] mmc: mmci: sdio related fixes
Date: Fri, 22 Aug 2014 05:53:39 +0100
Message-Id: <1408683219-7939-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408446785-1399-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1408446785-1399-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes few sdio related issues encountered while testing
WLAN ath6kl via SDIO on IFC6410 board with Qualcomm APQ8064 SOC.

Patch: "mmc: mmci: Support any block sizes for ux500v2 and qcom variant" is
a very old patch by Ulf to support IPs which support any size of block sizes.
http://www.spinics.net/lists/linux-mmc/msg12160.html I modified the subject
line to include qcom.
Patch fixes below issues reported while testing sdio.
The issue was ath6kl driver was issuing 12 bytes and 24 bytes reads
which are caught as part of the error handing in the driver and
resulting in failures. 

Patch "mmc: mmci: Add sdio enable mask in variant data" adds extra
variant parameter to enable sdio. This makes mmci driver more flexible.

Patch "mmc: mmci: rename sdio flag in vendor data to st_sdio" renames sdio
flag in vendor data to st_sdio, as this flag is only used to setup st
specific sdio logic.

All these patches are tested on IFC6410 board with ath6kl WLAN via SDIO.

Thanks to Linus W, Ulf annd Russell for comments since RFC.

Changes since v2:
	- removed "mmc: mmci: move block size validation under relevant code" patch
	as this is already fixed by original patch from Ulf.

Changes since RFC:
	- moved sdio flag to st_sdio to simplify the checks.
	- use Ulf's patch to address IP's which support anysize blocks.

Thanks,
srini

Srinivas Kandagatla (2):
  mmc: mmci: Add sdio enable mask in variant data
  mmc: mmci: rename sdio flag in vendor data to st_sdio

Ulf Hansson (1):
  mmc: mmci: Support any block sizes for ux500v2 and qcom variant

 drivers/mmc/host/mmci.c | 68 ++++++++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 32 deletions(-)

-- 
1.9.1

