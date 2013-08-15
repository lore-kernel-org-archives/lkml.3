Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab3HOOcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 10:32:06 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:52471 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305Ab3HOOcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 10:32:04 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH 0/5] mmc: sdhci: Add quirks for Qualcomm MSM SDHCI controller
Date: Thu, 15 Aug 2013 17:32:15 +0300
Message-Id: <1376577140-2652-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds quirks for various workarounds and performance
improvements required for Qualcomm MSM SDHCI driver.

1. Read Transfer Active/ Write Transfer Active may be not de-asserted
   after end of transaction.
2. Slow interrupt clearance at 400KHz may cause host driver interrupt
   handler to be called twice.
3. Controller does not support tuning commands as defined in SD 3.0 spec
   and CMD CRC errors are expected for tuning commands.
4. Improve the speed of secure discard operations by not using the
   calculated value, but the default one instead.
5. Controller can not handle large timeout values for R1B commands.

Patches are based on v3.11-rc5.

Georgi Djakov (5):
  mmc: sdhci: add quirk for R/W Transfer Active EOT
  mmc: sdhci: add quirk for slow interrupt clearance
  mmc: sdhci: add quirk to ignore CMD CRC err for tuning commands
  mmc: sdhci: add quirk for max_discard calculation
  mmc: sdhci: add quirk to ignore timeout err for R1B

 drivers/mmc/host/sdhci.c  |   35 ++++++++++++++++++++++++++++++++++-
 include/linux/mmc/sdhci.h |   14 ++++++++++++++
 2 files changed, 48 insertions(+), 1 deletion(-)

-- 
1.7.9.5

