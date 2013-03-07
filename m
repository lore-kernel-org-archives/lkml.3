Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308Ab3CGA34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:29:56 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5307 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758222Ab3CGA3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:29:55 -0500
X-IronPort-AV: E=Sophos;i="4.84,798,1355126400"; 
   d="scan'208";a="27740513"
From: David Brown <davidb@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/6] ssbi: Fix exit mismatch in remove function
Date: Wed,  6 Mar 2013 16:29:44 -0800
Message-Id: <1362616187-21089-4-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
References: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

msm_ssbi_remove is referenced with __exit_p, but not declared with
__exit.  This causes a warning when the driver is not built as a
module:

drivers/ssbi/ssbi.c:341:23: warning: 'msm_ssbi_remove' defined but not used [-Wunused-function]

Fix by adding the __exit declaration to the function.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 drivers/ssbi/ssbi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ssbi/ssbi.c b/drivers/ssbi/ssbi.c
index 86d8416..4d503da 100644
--- a/drivers/ssbi/ssbi.c
+++ b/drivers/ssbi/ssbi.c
@@ -337,7 +337,7 @@ err_get_mem_res:
 	return ret;
 }
 
-static int msm_ssbi_remove(struct platform_device *pdev)
+static int __exit msm_ssbi_remove(struct platform_device *pdev)
 {
 	struct msm_ssbi *ssbi = platform_get_drvdata(pdev);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

