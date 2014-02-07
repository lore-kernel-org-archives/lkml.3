Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbaBGMQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:16:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42224 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbaBGLvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Adrian Hunter <adrian.hunter@intel.com>, Chris Ball <chris@printf.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 170/233] mmc: sdhci-pci: Fix possibility of chip->fixes being null
Date: Fri,  7 Feb 2014 11:46:29 +0000
Message-Id: <1391773652-25214-171-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit 945be38caa287b177b8c17ffaae7754cab6a658f upstream.

It is possible for chip->fixes to be null.  Check before dereferencing it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Chris Ball <chris@printf.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mmc/host/sdhci-pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 33593e7..27ae563 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -1389,7 +1389,8 @@ static struct sdhci_pci_slot *sdhci_pci_probe_slot(
 	 * from runtime suspend.  If it is not there, don't allow runtime PM.
 	 * Note sdhci_pci_add_own_cd() sets slot->cd_gpio to -EINVAL on failure.
 	 */
-	if (chip->fixes->own_cd_for_runtime_pm && !gpio_is_valid(slot->cd_gpio))
+	if (chip->fixes && chip->fixes->own_cd_for_runtime_pm &&
+	    !gpio_is_valid(slot->cd_gpio))
 		chip->allow_runtime_pm = false;
 
 	return slot;
-- 
1.8.3.2

