Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214AbaJ2MtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:49:14 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14402 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932960AbaJ2MqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:23 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 28/35] UBI: Fastmap: Make self_check_eba() depend on fastmap self checking
Date: Wed, 29 Oct 2014 13:45:51 +0100
Message-Id: <1414586758-9972-29-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414586758-9972-1-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...instead of generic self checking.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 9364348..e36fd2e 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1454,7 +1454,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 		goto out_wl;
 
 #ifdef CONFIG_MTD_UBI_FASTMAP
-	if (ubi->fm && ubi_dbg_chk_gen(ubi)) {
+	if (ubi->fm && ubi_dbg_chk_fastmap(ubi)) {
 		struct ubi_attach_info *scan_ai;
 
 		scan_ai = alloc_ai();
-- 
1.8.4.5

