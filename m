Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbaAKUQL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 15:16:11 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:63052 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaAKUQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 15:16:07 -0500
From: Monam Agarwal <monamagarwal123@gmail.com>
To: gregkh@linuxfoundation.org, monamagarwal123@gmail.com,
        andreas.dilger@intel.com, peter.p.waskiewicz.jr@intel.com,
        tao.peng@emc.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] Staging: lustre: Use of fls to find last set bit
Date: Sun, 12 Jan 2014 01:45:51 +0530
Message-Id: <1389471351-31782-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389468763-25662-1-git-send-email-monamagarwal123@gmail.com>
References: <1389468763-25662-1-git-send-email-monamagarwal123@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces fls in lustre/ldlm/ldlm_extent.c
to find the last set bit.

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
Changes since v1:
* Incorrect commit message
* Use of fls function
Changes since v2:
* Removal of extra variable

 drivers/staging/lustre/lustre/ldlm/ldlm_extent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c b/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c
index ac5d66a..a4f382d 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c
@@ -153,7 +153,7 @@ static inline int lock_mode_to_index(ldlm_mode_t mode)
 
 	LASSERT(mode != 0);
 	LASSERT(IS_PO2(mode));
-	for (index = -1; mode; index++, mode >>= 1) ;
+	index = fls(mode)-1;
 	LASSERT(index < LCK_MODE_NUM);
 	return index;
 }
-- 
1.7.9.5

