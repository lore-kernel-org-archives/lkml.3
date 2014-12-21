Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbaLUVPf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 16:15:35 -0500
Received: from sauhun.de ([89.238.76.85]:52864 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbaLUVPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 16:15:19 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [PATCH 03/28] mips: pci: drop owner assignment from platform_drivers
Date: Sun, 21 Dec 2014 22:14:24 +0100
Message-Id: <1419196495-9626-4-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This platform_driver does not need to set an owner, it will be populated by the
driver core.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Generated with coccinelle. SmPL file is in the introductory msg. The big
cleanup was pulled in this merge window. This series catches the bits fallen
through. The patches shall go in via the subsystem trees.

 arch/mips/pci/pci-ar2315.c | 1 -
 arch/mips/pci/pci-rt2880.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/mips/pci/pci-ar2315.c b/arch/mips/pci/pci-ar2315.c
index bd2b3b60da83..07a18228e63a 100644
--- a/arch/mips/pci/pci-ar2315.c
+++ b/arch/mips/pci/pci-ar2315.c
@@ -488,7 +488,6 @@ static struct platform_driver ar2315_pci_driver = {
 	.probe = ar2315_pci_probe,
 	.driver = {
 		.name = "ar2315-pci",
-		.owner = THIS_MODULE,
 	},
 };
 
diff --git a/arch/mips/pci/pci-rt2880.c b/arch/mips/pci/pci-rt2880.c
index a4574947e698..8a978022630b 100644
--- a/arch/mips/pci/pci-rt2880.c
+++ b/arch/mips/pci/pci-rt2880.c
@@ -267,7 +267,6 @@ static struct platform_driver rt288x_pci_driver = {
 	.probe = rt288x_pci_probe,
 	.driver = {
 		.name = "rt288x-pci",
-		.owner = THIS_MODULE,
 		.of_match_table = rt288x_pci_match,
 	},
 };
-- 
2.1.3

