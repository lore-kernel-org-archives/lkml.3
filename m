Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaAKK2h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 05:28:37 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:47042 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbaAKK2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 05:28:35 -0500
Date: Sat, 11 Jan 2014 15:58:30 +0530
From: Monam Agarwal <monamagarwal123@gmail.com>
To: gregkh@linuxfoundation.org, rashika.kheria@gmail.com,
        peter.p.waskiewicz.jr@intel.com, monamagarwal123@gmail.com,
        andreas.dilger@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] Staging: lustre: Fix return does not need parantheses
Message-ID: <52d11cd2.e2a1440a.126c.ffffa935@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warning in
lustre/ldlm/interval_tree.c
ERROR: return is not a function, parentheses are not required

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/staging/lustre/lustre/ldlm/interval_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/interval_tree.c b/drivers/staging/lustre/lustre/ldlm/interval_tree.c
index 7c956de..fb64aea 100644
--- a/drivers/staging/lustre/lustre/ldlm/interval_tree.c
+++ b/drivers/staging/lustre/lustre/ldlm/interval_tree.c
@@ -585,8 +585,8 @@ EXPORT_SYMBOL(interval_erase);
 static inline int interval_may_overlap(struct interval_node *node,
 					  struct interval_node_extent *ext)
 {
-	return (ext->start <= node->in_max_high &&
-		ext->end >= interval_low(node));
+	return ext->start <= node->in_max_high &&
+		ext->end >= interval_low(node);
 }
 
 /*
-- 
1.7.9.5

