Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538AbaBKUc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:32:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbaBKTGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>, Chris Ball <chris@printf.net>
Subject: [PATCH 3.13 120/120] mmc: sdhci-pci: Fix possibility of chip->fixes being null
Date: Tue, 11 Feb 2014 11:06:01 -0800
Message-Id: <20140211184827.067308699@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit 945be38caa287b177b8c17ffaae7754cab6a658f upstream.

It is possible for chip->fixes to be null.  Check before dereferencing it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Chris Ball <chris@printf.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -1466,7 +1466,8 @@ static struct sdhci_pci_slot *sdhci_pci_
 	 * from runtime suspend.  If it is not there, don't allow runtime PM.
 	 * Note sdhci_pci_add_own_cd() sets slot->cd_gpio to -EINVAL on failure.
 	 */
-	if (chip->fixes->own_cd_for_runtime_pm && !gpio_is_valid(slot->cd_gpio))
+	if (chip->fixes && chip->fixes->own_cd_for_runtime_pm &&
+	    !gpio_is_valid(slot->cd_gpio))
 		chip->allow_runtime_pm = false;
 
 	return slot;


