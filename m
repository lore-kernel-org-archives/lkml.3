Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796AbaEKTg5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:36:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757780AbaEKTZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:25:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Markus Mayer <markus.mayer@linaro.org>,
        Matt Porter <mporter@linaro.org>, Chris Ball <chris@printf.net>
Subject: [PATCH 3.14 73/83] mmc: sdhci-bcm-kona: fix build errors when built-in
Date: Sun, 11 May 2014 21:20:14 +0200
Message-Id: <20140511191916.441539902@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 4025ce24f326830135341814307c072f6c2a7738 upstream.

`sdhci_bcm_kona_remove' referenced in section `.data' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o

Fixes: 058feb53666f ("mmc: sdhci-bcm-kona: make linker-section warning go away")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Tested-by: Markus Mayer <markus.mayer@linaro.org>
Acked-by: Matt Porter <mporter@linaro.org>
Signed-off-by: Chris Ball <chris@printf.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-bcm-kona.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-bcm-kona.c
+++ b/drivers/mmc/host/sdhci-bcm-kona.c
@@ -314,7 +314,7 @@ err_pltfm_free:
 	return ret;
 }
 
-static int __exit sdhci_bcm_kona_remove(struct platform_device *pdev)
+static int sdhci_bcm_kona_remove(struct platform_device *pdev)
 {
 	return sdhci_pltfm_unregister(pdev);
 }


