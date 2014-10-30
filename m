Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbaJ3GhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:37:06 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:15186 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757260AbaJ3GhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:37:03 -0400
X-IronPort-AV: E=Sophos;i="5.07,284,1413270000"; 
   d="scan'208";a="49476484"
From: Scott Branden <sbranden@broadcom.com>
To: Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Peter Griffin <peter.griffin@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Chris Ball <chris@printf.net>,
        Piotr Krol <pietrushnic@gmail.com>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, <linux-rpi-kernel@lists.infradead.org>,
        Ray Jui <rjui@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>
Subject: [PATCHv2 0/5] sdhci-bcm2835: added quirk and removed udelay in write ops
Date: Wed, 29 Oct 2014 23:36:52 -0700
Message-ID: <1414651017-3545-1-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Scott Branden <sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains driver cleanup of sdhci-bcm2835.
Please note that this has not actually been tested on bcm2835 yet.
Testing comes from other devices with the same sdhci controller.

This patch is being put out for testing and acceptance on the 2835.
Please test and comment.

Scott Branden (5):
  mmc: sdhci-bcm2835: group read and write functions to improve
    readability
  mmc: sdhci-bcm2835: make shift calculations consistent
  mmc: shdci-bcm2835: add efficient back-to-back write workaround
  mmc: shdci-bcm2835: add verify for 32-bit back-to-back workaround
  mmc: sdhci-bcm2835: add sdhci quirk
    SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12

 drivers/mmc/host/Kconfig         |    9 ++
 drivers/mmc/host/sdhci-bcm2835.c |  172 +++++++++++++++++++++-----------------
 2 files changed, 105 insertions(+), 76 deletions(-)

-- 
1.7.9.5

