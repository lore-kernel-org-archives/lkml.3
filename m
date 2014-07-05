Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756AbaGEUbH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 16:31:07 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:39924 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664AbaGEUbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 16:31:04 -0400
From: Pawel Lebioda <pawel.lebioda89@gmail.com>
To: Julian Andres Klode <jak@jak-linux.org>, Marc Dietrich <marvin24@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, ac100@lists.launchpad.net,
        linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: nvec: remove unneccessary 'out of memory' message
Date: Sat,  5 Jul 2014 22:30:56 +0200
Message-Id: <df2e426106dbb1040fded1f2ae69cb88e6c8c5cc.1404586529.git.pawel.lebioda89@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1404586529.git.pawel.lebioda89@gmail.com>
References: <cover.1404586529.git.pawel.lebioda89@gmail.com>
In-Reply-To: <cover.1404586529.git.pawel.lebioda89@gmail.com>
References: <cover.1404586529.git.pawel.lebioda89@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning reported by checkpatch.pl:

WARNING: Possible unnecessary 'out of memory' message
811: FILE: drivers/staging/nvec/nvec.c:811

Signed-off-by: Pawel Lebioda <pawel.lebioda89@gmail.com>
---
 drivers/staging/nvec/nvec.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index 8a3dd47..d325048 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -806,10 +806,9 @@ static int tegra_nvec_probe(struct platform_device *pdev)
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
 
-- 
1.8.3.2

