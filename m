Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbaEaXHm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 19:07:42 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:60273 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbaEaXHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 19:07:40 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Chas Williams <chas@cmf.nrl.navy.mil>,
        Grant Likely <grant.likely@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Rob Herring <robh+dt@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] atm: fore200e.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 01:08:32 +0200
Message-Id: <1401577712-4447-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/atm/fore200e.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index 204814e..d4725fc 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -2780,7 +2780,7 @@ static struct pci_driver fore200e_pca_driver = {
 
 static int __init fore200e_module_init(void)
 {
-	int err;
+	int err = 0;
 
 	printk(FORE200E "FORE Systems 200E-series ATM driver - version " FORE200E_VERSION "\n");
 
-- 
1.7.10.4

