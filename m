Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024AbaGDUFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 16:05:08 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:55450 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759563AbaGDUFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 16:05:05 -0400
Date: Fri, 4 Jul 2014 22:04:59 +0200
From: Pawel Lebioda <pawel.lebioda89@gmail.com>
To: Marc Dietrich <marvin24@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julian Andres Klode <jak@jak-linux.org>, ac100@lists.launchpad.net,
        linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: nvec: remove unneccessary 'out of memory' message
Message-ID: <20140704200457.GA4932@ThinkPad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch fixes the following warning reported by checkpatch.pl:

WARNING: Possible unnecessary 'out of memory' message
#811: FILE: drivers/staging/nvec/nvec.c:811

Regards
Pawel Lebioda

Signed-off-by: Pawel Lebioda <pawel.lebioda89@gmail.com>
 drivers/staging/nvec/nvec.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index 90f1c4d..70109f6 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -807,10 +807,9 @@ static int tegra_nvec_probe(struct platform_device *pdev)
 	}
 
 	nvec = devm_kzalloc(&pdev->dev, sizeof(struct nvec_chip), GFP_KERNEL);
-	if (nvec == NULL) {
-		dev_err(&pdev->dev, "failed to reserve memory\n");
+	if (nvec == NULL)
 		return -ENOMEM;
-	}
+
 	platform_set_drvdata(pdev, nvec);
 	nvec->dev = &pdev->dev;
 
