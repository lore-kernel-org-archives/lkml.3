Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab3C0QoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:44:04 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:46193 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab3C0QoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:44:01 -0400
From: Emil Goode <emilgoode@gmail.com>
To: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] staging: comedi: amplc_dio200: fix C99 array initializer warnings
Date: Wed, 27 Mar 2013 17:47:49 +0100
Message-Id: <1364402869-6280-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warnings about use of
obsolete array initializer:

drivers/staging/comedi/drivers/amplc_dio200_pci.c:256:24: warning:
	obsolete array initializer, use C99 syntax
drivers/staging/comedi/drivers/amplc_dio200_pci.c:269:24: warning:
	obsolete array initializer, use C99 syntax
drivers/staging/comedi/drivers/amplc_dio200_pci.c:281:25: warning:
	obsolete array initializer, use C99 syntax
drivers/staging/comedi/drivers/amplc_dio200_pci.c:298:25: warning:
	obsolete array initializer, use C99 syntax
drivers/staging/comedi/drivers/amplc_dio200_pci.c:315:25: warning:
	obsolete array initializer, use C99 syntax

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/staging/comedi/drivers/amplc_dio200_pci.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_dio200_pci.c b/drivers/staging/comedi/drivers/amplc_dio200_pci.c
index 55b6efd..232620c 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200_pci.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200_pci.c
@@ -253,7 +253,7 @@ enum dio200_pci_model {
 };
 
 static const struct dio200_board dio200_pci_boards[] = {
-	[pci215_model] {
+	[pci215_model] = {
 		.name = "pci215",
 		.bustype = pci_bustype,
 		.mainbar = 2,
@@ -266,7 +266,7 @@ static const struct dio200_board dio200_pci_boards[] = {
 			.has_clk_gat_sce = true,
 		},
 	},
-	[pci272_model] {
+	[pci272_model] = {
 		.name = "pci272",
 		.bustype = pci_bustype,
 		.mainbar = 2,
@@ -278,7 +278,7 @@ static const struct dio200_board dio200_pci_boards[] = {
 			.has_int_sce = true,
 		},
 	},
-	[pcie215_model] {
+	[pcie215_model] = {
 		.name = "pcie215",
 		.bustype = pci_bustype,
 		.mainbar = 1,
@@ -295,7 +295,7 @@ static const struct dio200_board dio200_pci_boards[] = {
 			.has_enhancements = true,
 		},
 	},
-	[pcie236_model] {
+	[pcie236_model] = {
 		.name = "pcie236",
 		.bustype = pci_bustype,
 		.mainbar = 1,
@@ -312,7 +312,7 @@ static const struct dio200_board dio200_pci_boards[] = {
 			.has_enhancements = true,
 		},
 	},
-	[pcie296_model] {
+	[pcie296_model] = {
 		.name = "pcie296",
 		.bustype = pci_bustype,
 		.mainbar = 1,
-- 
1.7.10.4

