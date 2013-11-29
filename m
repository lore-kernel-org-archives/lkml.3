Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab3K2RFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:05:21 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:58495 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab3K2RFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:05:17 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chad Williamson <chad@dahc.us>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: silicom: remove dead code
Date: Fri, 29 Nov 2013 18:05:01 +0100
Message-Id: <1385744701-9936-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

bus_info field of struct ethtool_drvinfo is an array thus it always
evaluates to true in a boolean context.  Therefore operation
depending on it being false will never be executed.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/staging/silicom/bpctl_mod.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 39dc92a..20325f5 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -135,8 +135,6 @@ static int bp_get_dev_idx_bsf(struct net_device *dev, int *index)
 	else
 		return -EOPNOTSUPP;
 
-	if (!drvinfo.bus_info)
-		return -ENODATA;
 	if (!strcmp(drvinfo.bus_info, "N/A"))
 		return -ENODATA;
 
-- 
1.8.4.1

