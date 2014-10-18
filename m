Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaJRWO6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 18:14:58 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:61091 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaJRWO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 18:14:56 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH 4/5] power: charger-manager.c:  Cleaning up missing null-terminate by switching from strncpy to strzcpy
Date: Sun, 19 Oct 2014 00:17:08 +0200
Message-Id: <1413670628-6531-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensures that the string is null-terminate in connection with the
use of strncpy, by switching from strncpy to strzcpy.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/power/charger-manager.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 9e4dab4..18dad9e 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1764,9 +1764,9 @@ static int charger_manager_probe(struct platform_device *pdev)
 	memcpy(&cm->charger_psy, &psy_default, sizeof(psy_default));
 
 	if (!desc->psy_name)
-		strncpy(cm->psy_name_buf, psy_default.name, PSY_NAME_MAX);
+		strzcpy(cm->psy_name_buf, psy_default.name, PSY_NAME_MAX);
 	else
-		strncpy(cm->psy_name_buf, desc->psy_name, PSY_NAME_MAX);
+		strzcpy(cm->psy_name_buf, desc->psy_name, PSY_NAME_MAX);
 	cm->charger_psy.name = cm->psy_name_buf;
 
 	/* Allocate for psy properties because they may vary */
-- 
1.7.10.4

