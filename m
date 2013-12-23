Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab3LWVzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:55:04 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43247 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574Ab3LWVzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:55:02 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 23 Dec 2013 13:54:56 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: David Woodhouse <dwmw2@infradead.org>, Jingoo Han <jg1.han@samsung.com>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] mtd: denali: Drop print of build date/time
Message-ID: <21175198efaf34a67e5108c1dae384656012b7a0.1387833347.git.josh@joshtriplett.org>
References: <cover.1387833347.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387833347.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel already has this information, and individual drivers
shouldn't duplicate that.  This also eliminates the use of __DATE__ and
__TIME__, which make the build non-deterministic.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/mtd/nand/denali_pci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/nand/denali_pci.c b/drivers/mtd/nand/denali_pci.c
index 033f177..ab64416 100644
--- a/drivers/mtd/nand/denali_pci.c
+++ b/drivers/mtd/nand/denali_pci.c
@@ -131,7 +131,6 @@ static struct pci_driver denali_pci_driver = {
 
 static int denali_init_pci(void)
 {
-	pr_info("Spectra MTD driver built on %s @ %s\n", __DATE__, __TIME__);
 	return pci_register_driver(&denali_pci_driver);
 }
 module_init(denali_init_pci);
-- 
1.8.5.2

