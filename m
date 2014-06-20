Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966486AbaFTJF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:05:56 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:56449 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965860AbaFTJFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:05:53 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, andreas.noever@gmail.com, spk.linux@gmail.com
Subject: [PATCH 4/6] thunderbolt: Use NULL instead of 0 in ctl.c
Date: Fri, 20 Jun 2014 14:32:32 +0530
Message-Id: <1403254954-14429-4-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403254954-14429-1-git-send-email-sachin.kamat@samsung.com>
References: <1403254954-14429-1-git-send-email-sachin.kamat@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function returns a pointer. Hence return NULL instead of 0.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
 drivers/thunderbolt/ctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thunderbolt/ctl.c b/drivers/thunderbolt/ctl.c
index d04fee4acb2e..4c6da92edcb4 100644
--- a/drivers/thunderbolt/ctl.c
+++ b/drivers/thunderbolt/ctl.c
@@ -305,13 +305,13 @@ static struct ctl_pkg *tb_ctl_pkg_alloc(struct tb_ctl *ctl)
 {
 	struct ctl_pkg *pkg = kzalloc(sizeof(*pkg), GFP_KERNEL);
 	if (!pkg)
-		return 0;
+		return NULL;
 	pkg->ctl = ctl;
 	pkg->buffer = dma_pool_alloc(ctl->frame_pool, GFP_KERNEL,
 				     &pkg->frame.buffer_phy);
 	if (!pkg->buffer) {
 		kfree(pkg);
-		return 0;
+		return NULL;
 	}
 	return pkg;
 }
-- 
1.7.9.5

