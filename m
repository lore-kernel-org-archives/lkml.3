Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbbAGCHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:07:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46747 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373AbbAGCHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:07:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Guo <peter.guo@bayhubtech.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 3.14 10/52] mmc: sdhci-pci-o2micro: Fix Dell E5440 issue
Date: Tue,  6 Jan 2015 18:06:38 -0800
Message-Id: <20150107020556.748169982@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107020555.043793795@linuxfoundation.org>
References: <20150107020555.043793795@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Guo <peter.guo@bayhubtech.com>

commit 6380ea099cdd46d7377b6fbec0291cf2aa387bad upstream.

Fix Dell E5440 when reboot Linux, can't find o2micro sd host chip issue.

Fixes: 01acf6917aed (mmc: sdhci-pci: add support of O2Micro/BayHubTech SD hosts)
Signed-off-by: Peter Guo <peter.guo@bayhubtech.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-pci-o2micro.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/mmc/host/sdhci-pci-o2micro.c
+++ b/drivers/mmc/host/sdhci-pci-o2micro.c
@@ -88,8 +88,6 @@ void sdhci_pci_o2_fujin2_pci_init(struct
 		return;
 	scratch_32 &= ~((1 << 21) | (1 << 30));
 
-	/* Set RTD3 function disabled */
-	scratch_32 |= ((1 << 29) | (1 << 28));
 	pci_write_config_dword(chip->pdev, O2_SD_FUNC_REG3, scratch_32);
 
 	/* Set L1 Entrance Timer */


