Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaJPLET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 07:04:19 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51813 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbaJPLER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 07:04:17 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: mmarek@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: use cscope -q option
Date: Thu, 16 Oct 2014 13:04:12 +0200
Message-Id: <1413457452-17656-1-git-send-email-jbarnes@virtuousgeek.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes symbol lookups significantly faster at the cost of some disk
space.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 scripts/tags.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 293828b..3de7719 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -142,7 +142,7 @@ all_defconfigs()
 docscope()
 {
 	(echo \-k; echo \-q; all_target_sources) > cscope.files
-	cscope -b -f cscope.out
+	cscope -bq -f cscope.out
 }
 
 dogtags()
-- 
1.9.1

