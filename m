Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab3FPLqv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 07:46:51 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:56256 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab3FPLqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 07:46:49 -0400
From: Emil Goode <emilgoode@gmail.com>
To: stern@rowland.harvard.edu, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] USB: EHCI: Remove double assignment of .start in ehci_msp_hc_driver
Date: Sun, 16 Jun 2013 13:46:38 +0200
Message-Id: <1371383198-11383-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a double assignment of .start in struct hc_driver
ehci_msp_hc_driver and also makes the code look more tidy.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/usb/host/ehci-pmcmsp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-pmcmsp.c b/drivers/usb/host/ehci-pmcmsp.c
index 363890e..601e208 100644
--- a/drivers/usb/host/ehci-pmcmsp.c
+++ b/drivers/usb/host/ehci-pmcmsp.c
@@ -291,8 +291,7 @@ static const struct hc_driver ehci_msp_hc_driver = {
 	/*
 	 * basic lifecycle operations
 	 */
-	.reset =		ehci_msp_setup,
-	.start =		ehci_run,
+	.reset			= ehci_msp_setup,
 	.shutdown		= ehci_shutdown,
 	.start			= ehci_run,
 	.stop			= ehci_stop,
-- 
1.7.10.4

