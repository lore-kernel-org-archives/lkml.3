Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3BCVxG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 16:53:06 -0500
Received: from mout.gmx.net ([212.227.17.20]:63409 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab3BCVva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 16:51:30 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19e5CsZPx1ePOstDDbFBhKdqr+mJROYcKlCmgGLmw
	3ACoKOC3tvb0/n
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] staging/xgifb: Fix return of uninitialized variable
Date: Sun,  3 Feb 2013 22:54:33 +0100
Message-Id: <1359928479-8484-4-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
References: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clang warning:
drivers/staging/xgifb/XGI_main_26.c: warning: variable 'ret' is
used uninitialized whenever 'if' condition:
	if (xgifb_info->mode_idx < 0) {
evaluates to true.

drivers/staging/xgifb/XGI_main_26.c:
note: uninitialized use occurs here
	return ret;

This patch initializes the variable in this case.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/XGI_main_26.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index fa351f9..106abc8 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1921,6 +1921,7 @@ static int xgifb_probe(struct pci_dev *pdev,
 
 	if (xgifb_info->mode_idx < 0) {
 		dev_err(&pdev->dev, "No supported video mode found\n");
+		ret = -EINVAL;
 		goto error_1;
 	}
 
-- 
1.7.8.6

