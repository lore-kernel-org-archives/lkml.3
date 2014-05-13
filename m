Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761266AbaEMKhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:37:11 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933318AbaEMKKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:10:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Chris Ball <chris@printf.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 179/182] mmc: sdhci-bcm-kona: fix build errors when built-in
Date: Tue, 13 May 2014 11:28:51 +0200
Message-Id: <ab734ab7b585080bcc5e09563ec7c0a702de9e6d.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4025ce24f326830135341814307c072f6c2a7738 upstream.

`sdhci_bcm_kona_remove' referenced in section `.data' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o

Fixes: 058feb53666f ("mmc: sdhci-bcm-kona: make linker-section warning go away")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Tested-by: Markus Mayer <markus.mayer@linaro.org>
Acked-by: Matt Porter <mporter@linaro.org>
Signed-off-by: Chris Ball <chris@printf.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mmc/host/sdhci-bcm-kona.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-bcm-kona.c b/drivers/mmc/host/sdhci-bcm-kona.c
index 85472d3fd37f..d002eb9e01cd 100644
--- a/drivers/mmc/host/sdhci-bcm-kona.c
+++ b/drivers/mmc/host/sdhci-bcm-kona.c
@@ -314,7 +314,7 @@ err_pltfm_free:
 	return ret;
 }
 
-static int __exit sdhci_bcm_kona_remove(struct platform_device *pdev)
+static int sdhci_bcm_kona_remove(struct platform_device *pdev)
 {
 	struct sdhci_host *host = platform_get_drvdata(pdev);
 	int dead;
-- 
1.9.3

