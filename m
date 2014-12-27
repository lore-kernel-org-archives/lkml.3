Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaL0Kfp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 05:35:45 -0500
Received: from down.free-electrons.com ([37.187.137.238]:47267 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750937AbaL0Kf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 05:35:26 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 1/3] ata: libahci: Clean-up the ahci_platform_en/disable_phys functions
Date: Sat, 27 Dec 2014 11:34:41 +0100
Message-Id: <1419676483-10346-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419676483-10346-1-git-send-email-gregory.clement@free-electrons.com>
References: <1419676483-10346-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The phy_ functions handle the NULL pointer case, so there is no need
to skip them if there is a NULL pointer. Moreover, after the error
label there is already no check on the pointer. This patch removes the
unnecessary tests and brings some consistency.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/ata/libahci_platform.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index 0b03f9056692..a147aaadca85 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -54,9 +54,6 @@ static int ahci_platform_enable_phys(struct ahci_host_priv *hpriv)
 	int rc, i;
 
 	for (i = 0; i < hpriv->nports; i++) {
-		if (!hpriv->phys[i])
-			continue;
-
 		rc = phy_init(hpriv->phys[i]);
 		if (rc)
 			goto disable_phys;
@@ -89,9 +86,6 @@ static void ahci_platform_disable_phys(struct ahci_host_priv *hpriv)
 	int i;
 
 	for (i = 0; i < hpriv->nports; i++) {
-		if (!hpriv->phys[i])
-			continue;
-
 		phy_power_off(hpriv->phys[i]);
 		phy_exit(hpriv->phys[i]);
 	}
-- 
1.9.1

